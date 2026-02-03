# Platform Conventions

> How the Horizon theme follows and extends Shopify platform patterns

## Platform Context

**Host Platform:** Shopify Online Store 2.0
**Platform Version(s):** Online Store 2.0 (current)
**Platform Documentation:** [Shopify Theme Developer Docs](https://shopify.dev/docs/themes)

## How We Follow Platform Patterns

### Template Hierarchy

**Platform standard:** Shopify uses JSON templates that reference sections, which in turn render blocks and snippets.

**Our implementation:**
```
templates/*.json          → Define page structure via section references
  └── sections/*.liquid   → Self-contained components with schemas
        └── blocks/*.liquid   → Reusable content blocks (prefixed with _)
        └── snippets/*.liquid → Utility templates for rendering
```

**Customizations:**
- Block files are prefixed with `_` (e.g., `_product-card.liquid`) to distinguish from sections
- Group sections (`header-group.json`, `footer-group.json`) manage site-wide elements

### Section Architecture

**Platform standard:** Sections are modular components with JSON schemas defining settings and blocks.

**Our implementation:**

```liquid
{% comment %} sections/example.liquid {% endcomment %}

<div class="example-section">
  {% for block in section.blocks %}
    {% case block.type %}
      {% when '_block-type' %}
        {% render '_block-type', block: block %}
    {% endcase %}
  {% endfor %}
</div>

{% schema %}
{
  "name": "t:names.example",
  "blocks": [
    { "type": "_block-type", "name": "t:names.block" },
    { "type": "@theme" },
    { "type": "@app" }
  ],
  "settings": [...]
}
{% endschema %}
```

**Key conventions:**
- Section names use translation keys (`t:names.*`)
- `@theme` and `@app` block types enable theme and app block insertion
- Blocks are rendered via `{% render %}` with explicit parameter passing

### Settings System

**Platform standard:** `settings_schema.json` defines theme-wide settings; `settings_data.json` stores values.

**Our implementation:**

| Settings Category | Location | Purpose |
|-------------------|----------|---------|
| Color schemes | `config/settings_schema.json` | Multiple palettes with RGB + opacity |
| Typography | `config/settings_schema.json` | 4 font families (body, subheading, heading, accent) |
| Layout | `config/settings_schema.json` | Spacing, borders, shadows |
| Section settings | Each `sections/*.liquid` schema | Per-section customization |

**CSS variable generation:**
```liquid
{% comment %} snippets/color-schemes.liquid {% endcomment %}
{% for scheme in settings.color_schemes %}
  .color-scheme-{{ scheme.id }} {
    --color-background: {{ scheme.settings.background }};
    --color-text: {{ scheme.settings.text }};
    /* ... */
  }
{% endfor %}
```

### Localization Pattern

**Platform standard:** JSON files in `locales/` with translation keys accessed via `| t` filter.

**Our implementation:**
- 27+ language files following Shopify naming: `{locale}.json`, `{locale}.schema.json`
- Default locale: `en.default.json`
- Schema translations separate: `en.default.schema.json`

**Usage patterns:**
```liquid
{{ 'products.product.add_to_cart' | t }}
{{ 'products.product.price' | t: price: product.price | money }}
```

### Asset Pipeline

**Platform standard:** Assets served from `assets/` directory via `| asset_url` filter.

**Our implementation:**

```liquid
{% comment %} Stylesheet loading {% endcomment %}
{{ 'base.css' | asset_url | stylesheet_tag: preload: true }}

{% comment %} Script loading (ES modules) {% endcomment %}
<script type="module" src="{{ 'component.js' | asset_url }}"></script>

{% comment %} Preloading critical assets {% endcomment %}
{{ 'base.css' | asset_url | preload_tag: as: 'style' }}
```

**No build step:** All assets are native (no transpilation, bundling, or minification in development).

## Platform Hooks/APIs We Use

### Liquid Objects

| Object | Usage Location | Purpose |
|--------|----------------|---------|
| `product` | Product templates, cards | Product data access |
| `collection` | Collection templates | Collection data and filtering |
| `cart` | Cart drawer, cart page | Cart contents and totals |
| `section` | All sections | Section settings and blocks |
| `block` | Block rendering | Block settings and attributes |
| `settings` | Theme-wide | Global theme settings |
| `request` | Layout | Page type, locale detection |
| `routes` | Navigation | Shopify route URLs |
| `shop` | Various | Store information |

### Liquid Filters

| Filter | Purpose | Example |
|--------|---------|---------|
| `| t` | Translation | `{{ 'cart.title' | t }}` |
| `| money` | Currency formatting | `{{ price | money }}` |
| `| image_url` | Image CDN URL | `{{ image | image_url: width: 400 }}` |
| `| asset_url` | Asset CDN URL | `{{ 'base.css' | asset_url }}` |
| `| font_face` | Font CSS generation | `{{ font | font_face }}` |
| `| color_modify` | Color manipulation | `{{ color | color_modify: 'alpha', 0.5 }}` |

### JavaScript APIs

| API | Location | Purpose |
|-----|----------|---------|
| `Shopify.routes` | Global | Store route URLs |
| `Shopify.currency` | Global | Active currency info |
| `Shopify.locale` | Global | Active locale |
| `/cart.js` | Fetch API | Cart AJAX operations |
| `/search/suggest.json` | Fetch API | Predictive search |
| `section_id` parameter | Section rendering | Section-specific updates |

### Section Rendering API

**Platform feature:** Sections can be re-rendered via URL parameter for dynamic updates.

**Our implementation:**
```javascript
// Fetch updated section HTML
const response = await fetch(`${url}?section_id=${sectionId}`);
const html = await response.text();

// Morph DOM instead of replacing (preserves state)
import { morph } from './morph.js';
morph(existingElement, newElement);
```

## Platform Constraints

### Template Constraints
- Templates must be JSON (except `gift_card.liquid`)
- Section schemas must be valid JSON within `{% schema %}` tags
- Block types limited to those defined in section schema plus `@theme`/`@app`

### Liquid Constraints
- No custom Liquid tags (only Shopify-provided)
- No server-side JavaScript execution
- Limited control flow (no recursion, limited loops)

### Asset Constraints
- No server-side asset processing (no SCSS compilation, etc.)
- Assets must be self-contained (no node_modules)
- Maximum file sizes apply per Shopify limits

### JavaScript Constraints
- No access to server-side data without Liquid pre-rendering
- Cart operations must use Shopify's AJAX API
- Checkout is controlled by Shopify (limited customization)

## Customization Points for Users

### Theme Editor Customizations

| What Can Be Customized | How | Location |
|------------------------|-----|----------|
| Colors | Color scheme editor | Theme Settings > Colors |
| Typography | Font picker (4 families) | Theme Settings > Typography |
| Logo & Favicon | Image upload | Theme Settings > Logo |
| Page layouts | Section arrangement | Page-specific editors |
| Section content | Block editing | Section settings |
| Social links | URL inputs | Theme Settings > Social |

### Developer Customizations

| Customization Type | Method | Files Affected |
|--------------------|--------|----------------|
| New section | Create `sections/name.liquid` with schema | `sections/` |
| New block | Create `blocks/_name.liquid` | `blocks/` |
| Style overrides | Edit CSS variables or add rules | `assets/base.css` |
| New component | Extend `Component` class | `assets/` |
| Translations | Edit/add locale files | `locales/` |

## JavaScript Component Pattern

### Base Component Class

All interactive components extend the `Component` base class:

```javascript
// assets/component.js
class Component extends DeclarativeShadowElement {
  // Manages refs, mutation observers, event delegation
}
```

### Creating a Component

```javascript
// assets/my-component.js
import { Component } from './component.js';

class MyComponent extends Component {
  connectedCallback() {
    super.connectedCallback();
    // Component initialization
  }

  // Use this.refs to access elements with ref="name" attributes
}

customElements.define('my-component', MyComponent);
```

### Event Communication

```javascript
// assets/events.js - Theme-wide event types
ThemeEvents.VARIANT_SELECTED = 'variant:selected';
ThemeEvents.CART_UPDATE = 'cart:update';
ThemeEvents.CART_ERROR = 'cart:error';

// Dispatching events
this.dispatchEvent(new VariantUpdateEvent({ variant }));

// Listening for events
document.addEventListener(ThemeEvents.CART_UPDATE, (e) => {
  // Handle cart update
});
```

## CSS Architecture

### Variable-Driven Theming

All visual properties derive from CSS custom properties:

```css
/* Generated from settings via Liquid */
:root {
  --color-background: 255 255 255;
  --color-foreground: 0 0 0;
  --font-body-family: "Inter", sans-serif;
  --spacing-base: 1rem;
}

/* Usage in components */
.component {
  background: rgb(var(--color-background));
  color: rgb(var(--color-foreground));
  font-family: var(--font-body-family);
  padding: var(--spacing-base);
}
```

### No Preprocessor

- Pure CSS (no SCSS, LESS, or PostCSS)
- CSS custom properties for dynamic values
- Native CSS nesting where supported (progressive enhancement)

## File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Sections | `kebab-case.liquid` | `featured-product.liquid` |
| Blocks | `_kebab-case.liquid` (underscore prefix) | `_product-card.liquid` |
| Snippets | `kebab-case.liquid` | `price-display.liquid` |
| JavaScript | `kebab-case.js` | `product-form.js` |
| Group sections | `name-group.json` | `header-group.json` |
| Templates | `name.json` | `product.json` |

## Related Documentation

- [PRODUCT_OVERVIEW.md](../PRODUCT_OVERVIEW.md) — Theme features and architecture overview
- [DOMAIN_GLOSSARY.md](DOMAIN_GLOSSARY.md) — Terminology definitions
- [Shopify Theme Docs](https://shopify.dev/docs/themes) — Official platform documentation
