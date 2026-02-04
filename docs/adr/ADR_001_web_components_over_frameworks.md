# ADR 001: Web Components Over JavaScript Frameworks

> **Status:** Accepted
> **Date:** 2024-01-01 (Retroactive documentation of founding decision)
> **Deciders:** Shopify Theme Team
> **Applies to:** Theme/Extension (Archetype D)

## Context

When building interactive UI components for the Horizon theme, we needed to choose an approach for client-side interactivity. The theme requires:

- Product variant selection with dynamic price/availability updates
- Cart drawer with add/remove/update functionality
- Image galleries with zoom and video playback
- Predictive search with debounced API calls
- Slideshow/carousel components

The decision space included:
1. **JavaScript frameworks** (React, Vue, Svelte, etc.)
2. **Lightweight libraries** (Alpine.js, Petite-Vue, etc.)
3. **Native Web Components** (Custom Elements API)
4. **Vanilla JavaScript** with no component abstraction

Key constraints:
- Shopify themes are server-rendered via Liquid
- Themes must work without a build step in development
- Performance is critical for e-commerce conversion
- Themes run on Shopify's CDN, not custom infrastructure
- Long-term maintenance by merchants and agencies who may not be JS experts

## Decision

We use **native Web Components** (Custom Elements) with a minimal base class (`Component` extending `DeclarativeShadowElement`) for all interactive UI.

Components are:
- Defined as ES2020 classes extending `Component`
- Registered via `customElements.define()`
- Used in Liquid templates as custom HTML elements
- Enhanced progressively over server-rendered HTML

```javascript
// Example: assets/my-component.js
import { Component } from './component.js';

class MyComponent extends Component {
  connectedCallback() {
    super.connectedCallback();
    // Enhancement logic
  }
}

customElements.define('my-component', MyComponent);
```

## Consequences

### Benefits

- **Zero framework overhead:** No React/Vue runtime (50-100KB saved)
- **Native browser support:** Custom Elements work in all modern browsers
- **No build step required:** ES modules load directly; no webpack/vite needed
- **Progressive enhancement:** Components enhance server-rendered HTML
- **Platform longevity:** Web standards don't deprecate like framework versions
- **Declarative Shadow DOM:** Server-rendered shadow roots hydrate without FOUC
- **Simpler mental model:** Just HTML elements with behavior attached

### Costs

- **Learning curve:** Developers familiar with React/Vue must learn Web Component patterns
- **Less ecosystem:** No component library ecosystem like React has
- **Manual state management:** No reactive state system; must handle updates manually
- **Verbose boilerplate:** More code than framework equivalents for same functionality
- **Shadow DOM complexity:** Styling across shadow boundaries requires CSS custom properties

### Neutral Effects

- Testing approach remains similar (component behavior testing)
- Debugging tools are browser DevTools (no React DevTools)

## Alternatives Considered

### React/Vue/Svelte

- **Description:** Use a modern JavaScript framework for all interactivity
- **Why rejected:**
  - Requires build step, adding toolchain complexity
  - Large runtime increases page weight
  - Hydration cost for server-rendered content
  - Framework updates create maintenance burden
  - Overkill for enhancement-focused interactivity

### Alpine.js / Petite-Vue

- **Description:** Lightweight reactive libraries that work with HTML attributes
- **Why rejected:**
  - Still adds runtime dependency
  - Attribute-based syntax mixed with Liquid is confusing
  - Limited component isolation
  - Less aligned with web platform direction

### Vanilla JavaScript (no abstraction)

- **Description:** Plain JS with DOM manipulation, no component pattern
- **Why rejected:**
  - No consistent patterns across codebase
  - Harder to maintain as complexity grows
  - No encapsulation or lifecycle management
  - Every developer reinvents the wheel

## Validation

**Signals that this decision is succeeding:**
- Theme loads fast with minimal JS payload (~20KB total)
- Components work reliably across browsers
- New components follow consistent patterns
- Developers can understand component code quickly

**Signals that this decision should be revisited:**
- Browser support for Web Components regresses
- A critical feature is impossible without a framework
- Component complexity exceeds what Web Components handle well
- Build tools become required for other reasons anyway

## Related

- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#javascript-component-pattern) — Component patterns
- [DOMAIN_GLOSSARY.md](../DOMAIN_GLOSSARY.md#component-javascript) — Component terminology
- `assets/component.js` — Base Component class implementation
- `assets/events.js` — Theme event system
