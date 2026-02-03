# Shopify Horizon Theme

> A modern, performance-focused Shopify theme built on web standards with server-rendered Liquid templates and progressive JavaScript enhancement.

## Codebase Archetype

**Type:** Theme / Template / Extension
**Platform:** Shopify Online Store 2.0
**Primary Language(s):** Liquid, JavaScript (ES2020), CSS
**Key Technologies:** Web Components, CSS Custom Properties, Native ES Modules

## What This Does

### Storefront Presentation
- Full e-commerce storefront with product pages, collections, cart, and checkout flow
- Blog system with articles and commenting support
- Search functionality with predictive search
- Multi-language support (27+ languages included)

### Product Experience
- Product media galleries with zoom and video support
- Variant selection with swatches and dropdowns
- Quick-add functionality from collection pages
- Product recommendations
- Compare-at pricing and sale badges

### Customization System
- Theme editor integration with live preview
- Multiple color schemes with full RGB control
- Typography system with 4 configurable font families
- Flexible section-based page building
- Block-level content customization

### Performance Features
- Server-rendered HTML via Liquid (minimal client-side rendering)
- Lazy loading and preloading strategies
- DOM morphing for smooth updates without full page reloads
- View Transitions API support for modern browsers

## Technical Overview

### Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| Templating | Liquid | Server-side HTML rendering |
| Components | Web Components (ES2020) | Interactive UI elements |
| Styling | CSS Custom Properties | Dynamic theming without build step |
| State | Custom Events | Cross-component communication |
| Build | None (native) | Direct asset serving, no compilation |

### Architecture Snapshot

- **Server-rendered first:** All HTML generated server-side via Liquid; JavaScript enhances, never replaces
- **Web Components architecture:** Custom elements extend `Component` base class with declarative shadow DOM
- **Event-driven communication:** `ThemeEvents` system for variant selection, cart updates, media playback
- **CSS variables for theming:** Color schemes, typography, and spacing driven by theme settings
- **No framework dependencies:** Pure web standards approach using ES2020+ features

### Codebase Statistics

| Category | Count | Lines |
|----------|-------|-------|
| Liquid templates | ~230 files | ~62,000 |
| JavaScript | ~60 files | ~20,000 |
| CSS | 3 files | ~5,000 |
| Locales | 27 languages | ~35,000 |
| **Total** | ~320 files | ~120,000 |

## Directory Structure

```
shopify-horizon/
├── assets/           # JS, CSS, icons, type definitions
├── blocks/           # Block snippets (prefixed with _)
├── config/           # Theme settings schema and data
├── layout/           # Base layouts (theme.liquid, password.liquid)
├── locales/          # Translation files (27+ languages)
├── sections/         # Page sections and group definitions
├── snippets/         # Reusable Liquid components
├── templates/        # JSON page templates
└── docs/             # Documentation
```

## Quick Start

### Prerequisites
- [Shopify CLI](https://shopify.dev/docs/themes/tools/cli) installed
- A Shopify Partner account or development store

### Development

```bash
# Clone and navigate to theme
cd shopify-horizon

# Connect to your store and start development
shopify theme dev --store your-store.myshopify.com

# Or push to your store
shopify theme push --store your-store.myshopify.com
```

### Theme Check (Linting)

```bash
# Run Shopify's theme linter
shopify theme check
```

## Platform Compatibility

- **Shopify Online Store 2.0:** Full compatibility
- **Theme Editor:** Full support for sections everywhere, app blocks, and theme blocks
- **Browser Support:** Modern evergreen browsers (Chrome, Firefox, Safari, Edge)

## Documentation

See `/docs` for detailed documentation:

- [PLATFORM_CONVENTIONS.md](docs/PLATFORM_CONVENTIONS.md) — How this theme follows and extends Shopify patterns
- [DOMAIN_GLOSSARY.md](docs/DOMAIN_GLOSSARY.md) — Terminology mapping for Shopify and Horizon concepts

## Version

**Current Version:** 3.3.0
**Release Notes:** See [release-notes.md](release-notes.md)

---

*This theme follows web-native principles: evergreen standards, progressive enhancement, and server-rendered HTML with JavaScript for enhancement only.*
