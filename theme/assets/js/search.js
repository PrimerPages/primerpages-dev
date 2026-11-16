(function () {
  if (window.PrimerPagesSearchLoaded) {
    return;
  }

  window.PrimerPagesSearchLoaded = true;

  const roots = document.querySelectorAll("[data-pagefind-search]");

  if (!roots.length) {
    return;
  }

  let pagefindPromise;
  const cancelSearches = new WeakMap();

  function getPagefindBasePath(src) {
    return new URL(".", new URL(src, window.location.href)).toString();
  }

  function loadPagefind(src) {
    if (window.pagefind) {
      return Promise.resolve(window.pagefind);
    }

    if (!pagefindPromise) {
      pagefindPromise = import(src).then(async (pagefindModule) => {
        const pagefind = pagefindModule.createInstance
          ? pagefindModule.createInstance({
            basePath: getPagefindBasePath(src),
            noWorker: true,
          })
          : pagefindModule;

        if (pagefind.init) {
          await pagefind.init();
        }

        return pagefind;
      });
    }

    return pagefindPromise;
  }

  function debounce(fn, wait) {
    let timeout;

    function debounced(...args) {
      window.clearTimeout(timeout);
      timeout = window.setTimeout(() => fn.apply(this, args), wait);
    }

    debounced.cancel = () => window.clearTimeout(timeout);
    return debounced;
  }

  function stripHtml(html) {
    const template = document.createElement("template");
    template.innerHTML = html || "";
    return template.content.textContent || template.innerText || "";
  }

  function escapeHtml(value) {
    return String(value || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function closeSearch(root) {
    cancelSearches.get(root)();
    const input = root.querySelector("[data-pagefind-input]");
    const results = root.querySelector("[data-pagefind-results]");

    root.querySelector("[data-pagefind-dropdown]").hidden = true;
    results.innerHTML = "";
    root.querySelector("[data-pagefind-empty]").hidden = true;
    root.querySelector("[data-pagefind-status]").textContent = "";
    input.setAttribute("aria-expanded", "false");
    input.removeAttribute("aria-activedescendant");
  }

  function openSearch(root) {
    const input = root.querySelector("[data-pagefind-input]");
    root.querySelector("[data-pagefind-dropdown]").hidden = false;
    input.setAttribute("aria-expanded", "true");
  }

  function renderEmpty(root, message) {
    root.querySelector("[data-pagefind-results]").innerHTML = "";
    const empty = root.querySelector("[data-pagefind-empty]");
    empty.textContent = message;
    empty.hidden = false;
    root.querySelector("[data-pagefind-status]").textContent = message;
    openSearch(root);
  }

  function renderResults(root, items) {
    const results = root.querySelector("[data-pagefind-results]");

    if (!items.length) {
      renderEmpty(root, "No results found");
      return;
    }

    results.innerHTML = items.map((item, index) => {
      const title = item.meta && item.meta.title ? item.meta.title : item.url;
      const excerpt = stripHtml(item.excerpt);
      const url = escapeHtml(item.url);

      return `
        <a id="${escapeHtml(results.id)}-${index}" class="primerpages-search__result no-underline" href="${url}" role="option" tabindex="-1" data-pagefind-result aria-selected="false">
          <span class="primerpages-search__title">${escapeHtml(title)}</span>
          <span class="primerpages-search__url color-fg-muted">${url}</span>
          ${excerpt ? `<span class="primerpages-search__excerpt color-fg-muted">${escapeHtml(excerpt)}</span>` : ""}
          <span class="primerpages-search__result-arrow octicon octicon-arrow-up-right-16" aria-hidden="true"></span>
        </a>
      `;
    }).join("");

    root.querySelector("[data-pagefind-empty]").hidden = true;
    root.querySelector("[data-pagefind-status]").textContent = `${items.length} results available. Use the up and down arrow keys to navigate.`;
    openSearch(root);
  }

  function selectResult(root, nextIndex) {
    const results = Array.from(root.querySelectorAll("[data-pagefind-result]"));

    if (!results.length) {
      return;
    }

    const selectedIndex = Math.max(0, Math.min(nextIndex, results.length - 1));

    results.forEach((item) => item.setAttribute("aria-selected", "false"));
    const selected = results[selectedIndex];
    selected.setAttribute("aria-selected", "true");
    root.querySelector("[data-pagefind-input]").setAttribute("aria-activedescendant", selected.id);
    selected.scrollIntoView({ block: "nearest" });
  }

  roots.forEach((root) => {
    const input = root.querySelector("[data-pagefind-input]");
    const src = root.getAttribute("data-pagefind-src");
    const maxResults = parseInt(root.getAttribute("data-pagefind-max-results"), 10) || 8;
    let searchToken = 0;
    let returnFocus;

    const runSearch = debounce(async () => {
      const query = input.value.trim();
      const token = ++searchToken;

      if (query.length < 2) {
        closeSearch(root);
        return;
      }

      try {
        const pagefind = await loadPagefind(src);
        const search = await pagefind.search(query);
        const resultData = await Promise.all(
          search.results.slice(0, maxResults).map((result) => result.data())
        );

        if (token === searchToken) {
          renderResults(root, resultData);
        }
      } catch (error) {
        if (token === searchToken) {
          renderEmpty(root, "Search is unavailable");
        }
      }
    }, 200);

    // Dismissal also cancels queued searches and invalidates in-flight responses.
    cancelSearches.set(root, () => {
      runSearch.cancel();
      searchToken++;
    });

    input.addEventListener("input", () => {
      closeSearch(root);
      runSearch();
    });
    input.addEventListener("keydown", (event) => {
      if (event.isComposing) return;

      if (event.key === "Escape") {
        event.preventDefault();
        event.stopPropagation();
        root.close();
        return;
      }
      if (event.key === "Tab") {
        closeSearch(root);
        return;
      }

      const results = Array.from(root.querySelectorAll("[data-pagefind-result]"));
      const currentIndex = results.findIndex((item) => item.getAttribute("aria-selected") === "true");
      if (event.key === "Enter" && currentIndex !== -1) {
        event.preventDefault();
        results[currentIndex].click();
        root.close();
      }
      if ((event.key === "ArrowDown" || event.key === "ArrowUp") && results.length) {
        event.preventDefault();
        event.stopPropagation();
        const nextIndex = currentIndex === -1
          ? (event.key === "ArrowDown" ? 0 : results.length - 1)
          : currentIndex + (event.key === "ArrowDown" ? 1 : -1);
        selectResult(root, nextIndex);
      }
    });

    function showDialog(opener = document.activeElement) {
      if (root.open) return;
      returnFocus = opener;
      root.showModal();
      input.focus();
      input.select();
      if (input.value.trim().length >= 2) runSearch();
    }

    document.querySelectorAll("[data-pagefind-launcher]").forEach((launcher) => {
      launcher.addEventListener("click", () => showDialog(launcher));
    });
    root.querySelector("[data-pagefind-close]").addEventListener("click", () => root.close());
    root.addEventListener("cancel", (event) => {
      event.preventDefault();
      root.close();
    });
    root.addEventListener("close", () => {
      closeSearch(root);
      if (returnFocus && returnFocus.isConnected) returnFocus.focus();
    });
    root.addEventListener("click", (event) => {
      if (event.target === root) {
        const bounds = root.getBoundingClientRect();
        if (event.clientX < bounds.left || event.clientX > bounds.right ||
            event.clientY < bounds.top || event.clientY > bounds.bottom) root.close();
      }
    });
    document.addEventListener("keydown", (event) => {
      if (event.key !== "/" || event.defaultPrevented || event.isComposing ||
          event.ctrlKey || event.metaKey || event.altKey || event.shiftKey) return;
      const target = event.target;
      if (target.isContentEditable || target.closest("input, textarea, select, [role='textbox']")) return;
      event.preventDefault();
      showDialog();
    });

    // Mouse selection should not move DOM focus out of the combobox.
    root.addEventListener("mousedown", (event) => {
      if (event.target.closest("[data-pagefind-result]")) event.preventDefault();
    });
  });
})();
