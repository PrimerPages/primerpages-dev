document.addEventListener('DOMContentLoaded', function () {
    var html = document.documentElement;
    var selector = document.querySelector('[data-version-selector]');
    var warning = document.querySelector('[data-version-warning]');

    if (!selector && !warning) {
        return;
    }

    var baseUrl = html.dataset.baseurl || '';
    var versionedDocs = html.dataset.versionedDocs === 'true';
    var versionsUrl = html.dataset.versionsJson || '/versions.json';
    var configuredVersion = normalizeKey(html.dataset.docVersion || '');
    var defaultAlias = normalizeKey(html.dataset.defaultDocAlias || 'latest');

    function ensureLeadingSlash(path) {
        if (!path) {
            return '/';
        }

        return path.charAt(0) === '/' ? path : '/' + path;
    }

    function stripTrailingSlash(path) {
        if (!path || path === '/') {
            return '/';
        }

        return path.replace(/\/+$/, '') || '/';
    }

    function normalizeKey(value) {
        return String(value || '').trim().replace(/^\/+|\/+$/g, '');
    }

    function stripBaseUrl(path) {
        var normalized = ensureLeadingSlash(path);

        if (versionedDocs) {
            return normalized;
        }

        var normalizedBaseUrl = stripTrailingSlash(baseUrl);

        if (!normalizedBaseUrl || normalizedBaseUrl === '/') {
            return normalized;
        }

        if (normalized === normalizedBaseUrl) {
            return '/';
        }

        if (normalized.indexOf(normalizedBaseUrl + '/') === 0) {
            return normalized.slice(normalizedBaseUrl.length) || '/';
        }

        return normalized;
    }

    function normalizePath(value) {
        var path = value || '/';

        try {
            path = new URL(path, window.location.origin).pathname;
        } catch (error) {
            path = String(path);
        }

        return stripBaseUrl(ensureLeadingSlash(path));
    }

    function versionRoot(key) {
        var normalized = normalizeKey(key);
        return normalized ? '/' + normalized + '/' : '/';
    }

    function buildHref(path) {
        var normalized = normalizePath(path);

        if (versionedDocs) {
            return normalized;
        }

        var normalizedBaseUrl = stripTrailingSlash(baseUrl);

        if (!normalizedBaseUrl || normalizedBaseUrl === '/') {
            return normalized;
        }

        if (normalized === '/') {
            return normalizedBaseUrl;
        }

        return normalizedBaseUrl + normalized;
    }

    function joinPaths(left, right) {
        var leftPath = stripTrailingSlash(normalizePath(left));
        var rightPath = normalizePath(right);
        var keepTrailingSlash = right === '/' || /\/$/.test(String(right || ''));

        if (leftPath === '/') {
            return keepTrailingSlash ? stripTrailingSlash(rightPath) + '/' : rightPath;
        }

        if (rightPath === '/') {
            return leftPath + '/';
        }

        var joined = stripTrailingSlash(leftPath + '/' + rightPath.replace(/^\//, ''));
        return keepTrailingSlash ? joined + '/' : joined;
    }

    function matchesRoot(pathname, root) {
        if (root === '/') {
            return pathname === '/';
        }

        return pathname === root.slice(0, -1) || pathname.indexOf(root) === 0;
    }

    function normalizeVersions(payload) {
        if (!Array.isArray(payload)) {
            return [];
        }

        var targets = [];
        var seen = {};

        payload.forEach(function (entry) {
            if (!entry || !entry.version) {
                return;
            }

            var version = normalizeKey(entry.version);
            var title = entry.title || version;
            var aliases = Array.isArray(entry.aliases) ? entry.aliases : [];
            var normalizedAliases = aliases.map(normalizeKey).filter(Boolean);
            var hasDefaultAlias = normalizedAliases.indexOf(defaultAlias) !== -1;

            if (!version || seen[version]) {
                return;
            }

            seen[version] = true;
            targets.push({
                key: version,
                label: hasDefaultAlias ? title + ' (' + defaultAlias + ')' : title,
                root: versionRoot(version),
                version: version,
                aliases: normalizedAliases
            });
        });

        return targets;
    }

    function findActiveTarget(pathname, targets) {
        var active = null;

        targets.forEach(function (target) {
            var targetRoots = [target.root].concat(target.aliases.map(versionRoot));

            targetRoots.forEach(function (root) {
                if (matchesRoot(pathname, root) && (!active || root.length > active.root.length)) {
                    active = {
                        key: target.key,
                        label: target.label,
                        root: root,
                        version: target.version,
                        aliases: target.aliases
                    };
                }
            });

            if (matchesRoot(pathname, target.root) && (!active || target.root.length > active.root.length)) {
                active = target;
            }
        });

        if (active) {
            return active;
        }

        return targets.find(function (target) {
            return target.key === configuredVersion;
        }) || null;
    }

    function stripActiveRoot(pathname, activeTarget) {
        if (!activeTarget || activeTarget.root === '/') {
            return pathname;
        }

        if (!matchesRoot(pathname, activeTarget.root)) {
            return pathname;
        }

        if (pathname === activeTarget.root.slice(0, -1)) {
            return '/';
        }

        return pathname.slice(activeTarget.root.length - 1) || '/';
    }

    function findDefaultTarget(targets) {
        return targets.find(function (target) {
            return target.key === defaultAlias || target.aliases.indexOf(defaultAlias) !== -1;
        }) || targets.find(function (target) {
            return target.key === configuredVersion;
        }) || targets[0] || null;
    }

    function renderFallback() {
        if (!selector) {
            return;
        }

        var label = selector.dataset.docVersion || configuredVersion || 'Version';
        var unavailableLabel = selector.dataset.versionUnavailableLabel || 'Version info unavailable';
        var currentLabel = selector.querySelector('[data-version-current-label]');
        var list = selector.querySelector('[data-version-options]');
        var status = selector.querySelector('[data-version-status]');

        if (currentLabel) {
            currentLabel.textContent = label;
        }

        if (list) {
            list.innerHTML = '';

            var item = document.createElement('div');
            item.className = 'SelectMenu-item color-fg-muted';
            item.setAttribute('aria-disabled', 'true');
            item.textContent = label;
            list.appendChild(item);
        }

        if (status) {
            status.textContent = unavailableLabel;
        }

        if (warning) {
            warning.classList.add('d-none');
        }
    }

    function updateWarning(activeTarget, defaultTarget) {
        if (!warning) {
            return;
        }

        var message = warning.dataset.versionWarningMessage || 'You are viewing a non-default version of these docs.';
        var text = warning.querySelector('[data-version-warning-text]');

        if (text) {
            text.textContent = message;
        }

        if (activeTarget && defaultTarget && activeTarget.version !== defaultTarget.version) {
            warning.classList.remove('d-none');
        } else {
            warning.classList.add('d-none');
        }
    }

    function render(payload) {
        var targets = normalizeVersions(payload);

        if (!targets.length) {
            renderFallback();
            return;
        }

        var currentPath = normalizePath(window.location.pathname);
        var activeTarget = findActiveTarget(currentPath, targets);
        var defaultTarget = findDefaultTarget(targets);
        var relativePath = stripActiveRoot(currentPath, activeTarget);
        var currentSearch = window.location.search || '';
        var currentHash = window.location.hash || '';

        if (selector) {
            var list = selector.querySelector('[data-version-options]');
            var currentLabel = selector.querySelector('[data-version-current-label]');
            var status = selector.querySelector('[data-version-status]');

            if (list) {
                list.innerHTML = '';

                targets.forEach(function (target) {
                    var item = document.createElement('a');
                    item.className = 'SelectMenu-item';
                    item.setAttribute('role', 'menuitem');
                    item.href = buildHref(joinPaths(target.root, relativePath)) + currentSearch + currentHash;
                    item.textContent = target.label;

                    if (activeTarget && target.key === activeTarget.key) {
                        item.setAttribute('aria-current', 'page');
                        item.classList.add('text-semibold');
                    }

                    item.addEventListener('click', function () {
                        selector.removeAttribute('open');
                    });

                    list.appendChild(item);
                });
            }

            if (currentLabel) {
                currentLabel.textContent = activeTarget ? activeTarget.label : configuredVersion;
            }

            if (status) {
                status.textContent = targets.length + ' target' + (targets.length === 1 ? '' : 's') + ' available';
            }
        }

        updateWarning(activeTarget, defaultTarget);
    }

    fetch(versionsUrl, { cache: 'no-cache' })
        .then(function (response) {
            if (!response.ok) {
                throw new Error('Unable to load version metadata');
            }

            return response.json();
        })
        .then(render)
        .catch(renderFallback);
});
