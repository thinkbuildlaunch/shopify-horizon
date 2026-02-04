# ADR 003: Server-Rendered Liquid with Progressive JavaScript Enhancement

> **Status:** Accepted
> **Date:** 2024-01-01 (Retroactive documentation of founding decision)
> **Deciders:** Shopify Theme Team
> **Applies to:** Theme/Extension (Archetype D)

## Context

Shopify themes must render product pages, collections, cart, and checkout flows for e-commerce. The rendering approach affects:

- **Performance:** Time to First Contentful Paint, Largest Contentful Paint
- **SEO:** Search engine crawlability and indexing
- **Reliability:** Functionality when JavaScript fails or is slow
- **Development:** How logic is split between server and client
- **Shopify integration:** Platform capabilities and constraints

Shopify provides:
- Liquid templating engine (server-side)
- Section Rendering API (fetch updated HTML for sections)
- Cart AJAX API (JSON endpoints)
- Theme editor with live preview

Rendering approaches considered:
1. **Client-side rendering (CSR):** JavaScript builds all HTML
2. **Server-side rendering with hydration (SSR):** Server renders, JS takes over
3. **Server-rendered with progressive enhancement:** Server renders, JS enhances
4. **Static generation (SSG):** Pre-build all pages

## Decision

We use **server-rendered Liquid as the primary rendering layer**, with JavaScript providing **progressive enhancement** for interactivity. The page is fully functional without JavaScript; JS makes it better.

Principles:
1. **Liquid renders all content:** Products, prices, cart contents, navigation
2. **JavaScript enhances, never replaces:** Core functionality works without JS
3. **Section Rendering API for updates:** Fetch new HTML, morph DOM (no client-side state)
4. **No client-side routing:** Each page is a full server request

```liquid
{%- comment -%} Server renders complete product info {%- endcomment -%}
<product-form-component>
  <form action="/cart/add" method="post">
    {{ product.title }}
    {{ product.price | money }}
    <button type="submit">Add to Cart</button>
  </form>
</product-form-component>
```

```javascript
// JavaScript enhances the form
class ProductFormComponent extends Component {
  async handleSubmit(event) {
    event.preventDefault();
    // AJAX add to cart, update cart drawer
    // Falls back to form POST if JS fails
  }
}
```

## Consequences

### Benefits

- **Fast initial load:** HTML arrives ready to display; no JS parsing before content
- **SEO-friendly:** Search engines see complete content immediately
- **Resilient:** Works if JS fails, loads slowly, or is blocked
- **Shopify-aligned:** Uses platform as designed (Liquid is the rendering engine)
- **Theme editor compatible:** Live preview works because server re-renders
- **Simpler state:** Server is source of truth; no client state synchronization
- **Accessibility:** Semantic HTML from server; JS doesn't break a11y

### Costs

- **Liquid limitations:** Complex logic is verbose or impossible in Liquid
- **Full page fetches:** Major state changes may require page navigation
- **DOM morphing complexity:** Updating sections while preserving component state
- **Less "app-like":** Transitions between pages aren't as smooth as SPA
- **Duplicate logic:** Some validation/formatting in both Liquid and JS

### Neutral Effects

- Cart operations still use AJAX (but with full fallback)
- Analytics/tracking works the same
- Third-party app integration unchanged

## Alternatives Considered

### Client-Side Rendering (React SPA)

- **Description:** JavaScript framework renders all UI, fetches data via API
- **Why rejected:**
  - Blank page until JS loads and executes
  - Poor SEO without additional SSR setup
  - Doesn't work without JavaScript
  - Fights against Shopify's Liquid architecture
  - Loses theme editor live preview

### SSR with Full Hydration

- **Description:** Server renders HTML, JavaScript "hydrates" and takes control
- **Why rejected:**
  - Hydration cost (parse JS, attach listeners, reconcile DOM)
  - Double rendering (server + client)
  - Requires framework (Next.js, Nuxt, etc.)
  - Complexity for limited benefit in theme context
  - Build tooling required

### Static Site Generation

- **Description:** Pre-build all pages at deploy time
- **Why rejected:**
  - E-commerce content is dynamic (prices, inventory, cart)
  - Not compatible with Shopify's hosting model
  - Theme editor requires runtime rendering

## Validation

**Signals that this decision is succeeding:**
- Core Vitals scores are good (LCP, FID, CLS)
- Site works with JavaScript disabled (core flows)
- Theme editor preview is responsive
- Search engines index product content correctly

**Signals that this decision should be revisited:**
- A feature genuinely requires client-side rendering
- Performance degrades due to full-page fetches
- User experience suffers from non-SPA navigation
- Shopify provides new APIs that enable different approaches

## Related

- [ADR_001_web_components_over_frameworks.md](ADR_001_web_components_over_frameworks.md) — Why Web Components
- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#section-rendering-api) — Section Rendering API
- [DOMAIN_GLOSSARY.md](../DOMAIN_GLOSSARY.md#morph) — DOM morphing terminology
- `assets/morph.js` — DOM diffing implementation
- `layout/theme.liquid` — Main layout structure
