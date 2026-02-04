# Domain Glossary

> Terminology mapping for Shopify platform concepts and Horizon theme patterns

## Shopify Platform Terms

### Section

**Business meaning:** A modular, configurable component that can be added to pages via the theme editor. Sections are the primary building blocks of Shopify theme pages.

**Technical mapping:**
- **Code location:** `sections/*.liquid`
- **Schema:** JSON block within `{% schema %}{% endschema %}` tags
- **Settings access:** `section.settings.{setting_name}`
- **Blocks access:** `section.blocks` (array)

**When this matters:**
- Adding new page components
- Configuring page layouts in theme editor
- Understanding template structure

---

### Block

**Business meaning:** A nested content unit within a section. Blocks allow merchants to add, remove, and reorder content within a section.

**Technical mapping:**
- **Code location:** `blocks/_*.liquid` (Horizon convention: underscore prefix)
- **Schema definition:** Within parent section's `{% schema %}` under `"blocks"`
- **Settings access:** `block.settings.{setting_name}`
- **Attributes:** `block.id`, `block.type`, `block.shopify_attributes`

**When this matters:**
- Creating reusable content components
- Enabling merchant customization within sections
- Related: [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md#section-architecture)

---

### Snippet

**Business meaning:** A reusable template fragment that can be included in sections, blocks, or other snippets. Snippets don't have schemas and cannot be configured via the theme editor.

**Technical mapping:**
- **Code location:** `snippets/*.liquid`
- **Usage:** `{% render 'snippet-name', param: value %}`
- **Scope:** Variables must be explicitly passed; no access to parent scope

**When this matters:**
- Extracting repeated rendering logic
- Creating utility templates
- Sharing code between sections/blocks

---

### Template

**Business meaning:** Defines the structure of a specific page type (product, collection, cart, etc.) by specifying which sections appear and in what order.

**Technical mapping:**
- **Code location:** `templates/*.json`
- **Structure:** JSON with `sections` object and `order` array
- **Variants:** `templates/product.json`, `templates/product.alternate.json`

**When this matters:**
- Creating page layouts
- Adding/removing sections from page types
- Creating alternate templates for specific pages

---

### Layout

**Business meaning:** The outermost wrapper template that includes elements common to all pages (head, header, footer, scripts).

**Technical mapping:**
- **Code location:** `layout/theme.liquid`, `layout/password.liquid`
- **Content insertion:** `{{ content_for_layout }}`
- **Group sections:** `{% sections 'header-group' %}`, `{% sections 'footer-group' %}`

**When this matters:**
- Modifying site-wide elements
- Adding global scripts or styles
- Understanding page rendering flow

---

### Group Section

**Business meaning:** A collection of sections that appear on every page (or every page of a type), such as header and footer.

**Technical mapping:**
- **Code location:** `sections/header-group.json`, `sections/footer-group.json`
- **Rendering:** `{% sections 'group-name' %}` in layout
- **Structure:** JSON defining section references and order

**When this matters:**
- Modifying site-wide navigation
- Adding announcement bars or footer content
- Understanding header/footer architecture

---

### Settings Schema

**Business meaning:** Defines all theme-level settings that merchants can configure in the theme editor.

**Technical mapping:**
- **Code location:** `config/settings_schema.json`
- **Access:** `settings.{setting_name}` in Liquid
- **Structure:** Array of setting groups with individual settings

**When this matters:**
- Adding new theme-wide options
- Understanding available customization
- Modifying color schemes or typography

---

### Color Scheme

**Business meaning:** A named collection of colors (background, text, accents) that can be applied to sections for consistent theming.

**Technical mapping:**
- **Definition:** `config/settings_schema.json` under color scheme settings
- **CSS generation:** `snippets/color-schemes.liquid`
- **Application:** `.color-scheme-{id}` CSS class on elements
- **Variables:** `--color-background`, `--color-foreground`, etc.

**When this matters:**
- Customizing theme colors
- Applying color schemes to sections
- Understanding CSS variable architecture

---

## Horizon-Specific Terms

### Component (JavaScript)

**Business meaning:** An interactive UI element implemented as a Web Component (custom HTML element) that extends the theme's base `Component` class.

**Technical mapping:**
- **Base class:** `assets/component.js` → `Component` extends `DeclarativeShadowElement`
- **Registration:** `customElements.define('component-name', ComponentClass)`
- **Usage:** `<component-name>` in Liquid templates
- **Refs system:** `ref="name"` attributes → `this.refs.name`

**When this matters:**
- Adding interactive functionality
- Understanding JavaScript architecture
- Extending existing components

---

### Theme Events

**Business meaning:** A standardized event system for communication between components across the theme.

**Technical mapping:**
- **Code location:** `assets/events.js`
- **Event types:** `ThemeEvents.VARIANT_SELECTED`, `ThemeEvents.CART_UPDATE`, etc.
- **Custom events:** `VariantUpdateEvent`, `CartUpdateEvent`, `CartErrorEvent`
- **Usage:** `document.addEventListener(ThemeEvents.EVENT_NAME, handler)`

**When this matters:**
- Coordinating component behavior
- Responding to cart or variant changes
- Building reactive features

---

### Morph

**Business meaning:** A DOM diffing technique used to update sections without full page reloads, preserving component state and focus.

**Technical mapping:**
- **Code location:** `assets/morph.js`
- **Function:** `morph(existingElement, newElement, options)`
- **Used by:** Section rendering updates, cart drawer, predictive search

**When this matters:**
- Understanding dynamic updates
- Debugging state preservation issues
- Implementing smooth transitions

---

### Refs System

**Business meaning:** A pattern for accessing child elements within a component using `ref` attributes, similar to React refs.

**Technical mapping:**
- **Definition:** Elements with `ref="name"` attribute
- **Access:** `this.refs.name` in component JavaScript
- **Setup:** Handled by `Component` base class in `connectedCallback`

**When this matters:**
- Accessing DOM elements in components
- Understanding component internals
- Following Horizon's component patterns

---

### Block Prefix Convention

**Business meaning:** Horizon uses an underscore prefix (`_`) for block files to distinguish them from sections.

**Technical mapping:**
- **Pattern:** `blocks/_block-name.liquid`
- **Reference in schema:** `"type": "_block-name"`
- **Rendering:** `{% render '_block-name', block: block %}`

**When this matters:**
- Creating new blocks
- Understanding file organization
- Navigating the codebase

---

### Declarative Shadow DOM

**Business meaning:** A web standard for defining shadow DOM in HTML without JavaScript, used by Horizon's component system.

**Technical mapping:**
- **Base class:** `DeclarativeShadowElement` in `assets/component.js`
- **Template:** `<template shadowrootmode="open">` in Liquid
- **Hydration:** Component JavaScript enhances server-rendered shadow DOM

**When this matters:**
- Understanding component rendering
- Working with shadow DOM styles
- Debugging component issues

---

## Shopify API Terms

### Section Rendering API

**Business meaning:** Allows fetching updated HTML for a specific section via URL parameter, enabling dynamic updates without full page reload.

**Technical mapping:**
- **URL pattern:** `?section_id={section-id}`
- **Response:** Raw HTML for that section only
- **Usage:** Fetch API → morph DOM

**When this matters:**
- Implementing dynamic section updates
- Cart drawer updates
- Filter/sort operations

---

### Cart AJAX API

**Business meaning:** RESTful endpoints for cart operations without page refresh.

**Technical mapping:**
- **Endpoints:** `/cart.js`, `/cart/add.js`, `/cart/change.js`, `/cart/update.js`
- **Format:** JSON request/response
- **Used by:** `cart-drawer.js`, `add-to-cart.js`, `product-form.js`

**When this matters:**
- Implementing add-to-cart functionality
- Updating cart quantities
- Building cart UI

---

### Predictive Search API

**Business meaning:** Endpoint for search-as-you-type functionality.

**Technical mapping:**
- **Endpoint:** `/search/suggest.json`
- **Parameters:** `q` (query), `resources[type]` (product, collection, article, page)
- **Used by:** `assets/predictive-search.js`

**When this matters:**
- Customizing search behavior
- Understanding search UI
- Debugging search issues

---

## CSS Architecture Terms

### CSS Custom Properties (Variables)

**Business meaning:** Native CSS variables used for dynamic theming, generated from Shopify settings via Liquid.

**Technical mapping:**
- **Generation:** Various `snippets/*-style.liquid` files
- **Root definition:** `:root { --property-name: value; }`
- **Usage:** `var(--property-name)` or `rgb(var(--color-name))`

**When this matters:**
- Customizing styles
- Understanding theming system
- Adding new style options

---

## Adding New Terms

When adding terms to this glossary:

1. Use the business meaning that someone unfamiliar with the code would understand
2. Include specific file paths and code patterns
3. List scenarios where the term becomes relevant
4. Link to related documentation or directives

**Growth limit:** Maximum 50 active terms. Archive unused terms to `docs/archive/glossary-archive.md`.

---

## Related Documentation

- [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md) — How Horizon follows Shopify patterns
- [PRODUCT_OVERVIEW.md](../PRODUCT_OVERVIEW.md) — Theme features and architecture
- [Shopify Theme Docs](https://shopify.dev/docs/themes) — Official platform documentation
