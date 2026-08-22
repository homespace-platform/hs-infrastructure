(function () {
    const HOME_ORIGIN_STORAGE_KEY = "homespace.homeOrigin";
    const LOCAL_HOME_URL = "http://localhost:3000";

    function isHttpUrl(value) {
        try {
            const url = new URL(value);
            return url.protocol === "http:" || url.protocol === "https:";
        } catch (_error) {
            return false;
        }
    }

    function resolveHomeUrl() {
        const redirectUri = new URLSearchParams(window.location.search).get("redirect_uri");

        if (redirectUri && isHttpUrl(redirectUri)) {
            const homeOrigin = new URL(redirectUri).origin;
            window.sessionStorage.setItem(HOME_ORIGIN_STORAGE_KEY, homeOrigin);
            return homeOrigin;
        }

        const storedOrigin = window.sessionStorage.getItem(HOME_ORIGIN_STORAGE_KEY);
        return storedOrigin && isHttpUrl(storedOrigin) ? storedOrigin : LOCAL_HOME_URL;
    }

    function makeLogoClickable() {
        const headerWrapper = document.getElementById("kc-header-wrapper");
        if (!headerWrapper || headerWrapper.querySelector(".hs-home-link")) {
            return;
        }

        const homeLink = document.createElement("a");
        homeLink.className = "hs-home-link";
        homeLink.href = resolveHomeUrl();
        homeLink.setAttribute("aria-label", "HomeSpace home page");
        homeLink.title = "HomeSpace";
        headerWrapper.prepend(homeLink);
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", makeLogoClickable);
    } else {
        makeLogoClickable();
    }
})();
