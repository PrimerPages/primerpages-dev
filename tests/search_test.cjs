const assert = require("node:assert/strict");
const { readFileSync } = require("node:fs");
const { test } = require("node:test");
const { runInNewContext } = require("node:vm");

function setup() {
  const inputEvents = {};
  const documentEvents = {};
  let timer;
  let resolveSearch;
  let searchCalls = 0;
  const dropdown = { hidden: true };
  const empty = { hidden: true, textContent: "" };
  const status = { textContent: "" };
  let options = [];
  let html = "";
  const attributes = {};
  let activated;
  const results = {
    id: "search-results",
    get innerHTML() { return html; },
    set innerHTML(value) {
      html = value;
      options = [...value.matchAll(/<a id="([^"]+)"[^>]*href="([^"]+)"[^>]*>/g)].map((match) => {
        const attrs = { "aria-selected": "false" };
        return {
          id: match[1],
          getAttribute(name) { return attrs[name]; },
          setAttribute(name, value) { attrs[name] = value; },
          scrollIntoView() {},
          click() { activated = match[2]; },
        };
      });
    },
  };
  const input = {
    value: "hello",
    setAttribute(name, value) { attributes[name] = value; },
    getAttribute(name) { return attributes[name]; },
    removeAttribute(name) { delete attributes[name]; },
    addEventListener(name, fn) { inputEvents[name] = fn; },
  };
  const nodes = {
    "[data-pagefind-input]": input,
    "[data-pagefind-results]": results,
    "[data-pagefind-dropdown]": dropdown,
    "[data-pagefind-empty]": empty,
    "[data-pagefind-status]": status,
  };
  const root = {
    getAttribute(name) { return name === "data-pagefind-src" ? "/pagefind/pagefind.js" : "8"; },
    querySelector(selector) { return nodes[selector]; },
    querySelectorAll() { return options; },
    addEventListener() {},
    contains() { return false; },
  };
  const document = {
    activeElement: input,
    createElement() { return { content: { textContent: "" } }; },
    querySelectorAll() { return [root]; },
    addEventListener(name, fn) { documentEvents[name] = fn; },
  };
  const window = {
    clearTimeout() { timer = undefined; },
    setTimeout(fn) { timer = fn; },
    pagefind: {
      search() {
        searchCalls++;
        return new Promise((resolve) => { resolveSearch = resolve; });
      },
    },
  };
  runInNewContext(readFileSync(require.resolve("../theme/assets/js/search.js"), "utf8"), {
    window, document, URL,
  });
  return {
    input, results, dropdown, status, document,
    get activated() { return activated; },
    key(key) { inputEvents.keydown({ key, preventDefault() {}, stopPropagation() {} }); },
    type() { inputEvents.input(); },
    escape() { this.key("Escape"); },
    clickOutside() { documentEvents.click({ target: {} }); },
    runTimer() { const fn = timer; timer = undefined; return fn?.(); },
    finish(items = []) { resolveSearch({ results: items.map((item) => ({ data: async () => item })) }); },
    get searchCalls() { return searchCalls; },
  };
}

for (const dismiss of ["escape", "clickOutside"]) {
  test(`${dismiss} cancels a queued search`, async () => {
    const ui = setup();
    ui.type();
    ui[dismiss]();
    await ui.runTimer();
    assert.equal(ui.searchCalls, 0);
    assert.equal(ui.dropdown.hidden, true);
  });

  test(`${dismiss} discards an in-flight response`, async () => {
    const ui = setup();
    ui.type();
    const pending = ui.runTimer();
    await Promise.resolve();
    ui[dismiss]();
    ui.finish();
    await pending;
    assert.equal(ui.dropdown.hidden, true);
    assert.equal(ui.results.innerHTML, "");
  });
}

test("clearing the input invalidates the previous query immediately", async () => {
  const ui = setup();
  ui.type();
  const pending = ui.runTimer();
  await Promise.resolve();
  ui.input.value = "";
  ui.type();
  ui.finish();
  await pending;
  assert.equal(ui.dropdown.hidden, true);
  await ui.runTimer();
  assert.equal(ui.searchCalls, 1);
});

test("a new search after dismissal can display results", async () => {
  const ui = setup();
  ui.type();
  ui.escape();
  ui.type();
  const pending = ui.runTimer();
  await Promise.resolve();
  ui.finish();
  await pending;
  assert.equal(ui.dropdown.hidden, false);
  assert.match(ui.status.textContent, /No results found/);
});

async function showResults(ui) {
  ui.type();
  const pending = ui.runTimer();
  await Promise.resolve();
  ui.finish([
    { url: "/first/", meta: { title: "First" } },
    { url: "/second/", meta: { title: "Second" } },
  ]);
  await pending;
}

test("arrow navigation announces the active option while focus stays in the input", async () => {
  const ui = setup();
  await showResults(ui);
  assert.equal(ui.input.getAttribute("aria-expanded"), "true");
  assert.match(ui.status.textContent, /2 results available/);
  assert.equal(ui.input.getAttribute("aria-activedescendant"), undefined);
  ui.key("ArrowDown");
  assert.equal(ui.input.getAttribute("aria-activedescendant"), "search-results-0");
  ui.key("ArrowDown");
  assert.equal(ui.input.getAttribute("aria-activedescendant"), "search-results-1");
  ui.key("ArrowDown");
  assert.equal(ui.input.getAttribute("aria-activedescendant"), "search-results-1");
  ui.key("ArrowUp");
  assert.equal(ui.input.getAttribute("aria-activedescendant"), "search-results-0");
  assert.equal(ui.document.activeElement, ui.input);
  ui.key("Enter");
  assert.equal(ui.activated, "/first/");
  assert.equal(ui.dropdown.hidden, true);
  assert.equal(ui.input.getAttribute("aria-activedescendant"), undefined);
});

for (const key of ["Escape", "Tab"]) {
  test(`${key} dismisses results and clears the active descendant`, async () => {
    const ui = setup();
    await showResults(ui);
    ui.key("ArrowUp");
    assert.equal(ui.input.getAttribute("aria-activedescendant"), "search-results-1");
    ui.key(key);
    assert.equal(ui.dropdown.hidden, true);
    assert.equal(ui.input.getAttribute("aria-expanded"), "false");
    assert.equal(ui.input.getAttribute("aria-activedescendant"), undefined);
    assert.equal(ui.document.activeElement, ui.input);
  });
}
