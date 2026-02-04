# ADR 002: CSS Custom Properties Over Preprocessors

> **Status:** Accepted
> **Date:** 2024-01-01 (Retroactive documentation of founding decision)
> **Deciders:** Shopify Theme Team
> **Applies to:** Theme/Extension (Archetype D)

## Context

Shopify themes require extensive styling customization:
- Color schemes (multiple palettes with foreground, background, accent colors)
- Typography (4 font families: body, heading, subheading, accent)
- Spacing and layout variations
- Component-specific styling (buttons, cards, inputs)
- Responsive design adaptations

The styling system must:
- Allow merchant customization via theme editor
- Apply changes without page reload (live preview)
- Work without a build step
- Support multiple color schemes on the same page
- Be maintainable by developers of varying skill levels

Options considered:
1. **CSS preprocessors** (SCSS, LESS, PostCSS)
2. **Utility frameworks** (Tailwind CSS)
3. **CSS-in-JS** (styled-components, emotion)
4. **Native CSS Custom Properties** (CSS variables)

## Decision

We use **native CSS Custom Properties** (CSS variables) for all dynamic styling, generated from Shopify settings via Liquid templates.

Architecture:
1. Theme settings define values in `config/settings_schema.json`
2. Liquid snippets generate CSS variable declarations from settings
3. Components reference variables: `var(--color-foreground)`
4. Color schemes apply via class: `.color-scheme-{id}`

```liquid
{%- comment -%} snippets/color-schemes.liquid {%- endcomment -%}
{% for scheme in settings.color_schemes %}
  .color-scheme-{{ scheme.id }} {
    --color-background: {{ scheme.settings.background }};
    --color-foreground: {{ scheme.settings.text }};
    --color-primary: {{ scheme.settings.primary }};
  }
{% endfor %}
```

```css
/* Usage in base.css */
.button {
  background: rgb(var(--color-primary));
  color: rgb(var(--color-background));
}
```

## Consequences

### Benefits

- **No build step:** CSS works directly in browser
- **Runtime theming:** Variables update live in theme editor
- **Multiple schemes:** Different sections can use different color schemes simultaneously
- **Browser-native:** No tooling dependencies, works everywhere
- **Inspectable:** DevTools show computed values clearly
- **Future-proof:** CSS variables are a web standard
- **Smaller bundles:** No Tailwind utilities or preprocessor output

### Costs

- **No nesting (legacy browsers):** CSS nesting requires modern browsers
- **No mixins:** Repeated patterns must be written out or use Liquid
- **No compile-time validation:** Typos in variable names fail silently
- **RGB gymnastics:** Colors stored as RGB components for alpha manipulation: `rgb(var(--color-primary-rgb) / 0.5)`
- **Verbosity:** More CSS lines than Tailwind equivalent

### Neutral Effects

- Responsive design uses native media queries (same as preprocessors)
- Specificity management is unchanged
- File organization is similar

## Alternatives Considered

### SCSS/LESS

- **Description:** CSS preprocessors with variables, nesting, mixins
- **Why rejected:**
  - Requires build step to compile
  - Variables are compile-time only, can't change at runtime
  - Theme editor live preview would require on-the-fly compilation
  - Adds toolchain dependency

### Tailwind CSS

- **Description:** Utility-first CSS framework
- **Why rejected:**
  - Requires build step for purging unused classes
  - Utility classes in Liquid templates reduce readability
  - Custom theme values need tailwind.config.js
  - Large file if not purged properly
  - Learning curve for Tailwind-specific classes

### CSS-in-JS

- **Description:** JavaScript libraries that generate CSS (styled-components, emotion)
- **Why rejected:**
  - Requires JavaScript runtime for styling
  - Conflicts with server-rendered Liquid approach
  - Adds bundle size and complexity
  - Not compatible with Shopify's asset pipeline

## Validation

**Signals that this decision is succeeding:**
- Theme editor preview updates instantly on color/font changes
- Multiple color schemes work on same page without conflicts
- CSS file size remains reasonable (~120KB uncompressed)
- Developers find styling system intuitive

**Signals that this decision should be revisited:**
- CSS file grows unmanageably large
- Complex styling patterns become too repetitive
- A feature requires capabilities CSS variables don't provide
- Build tools become required for other reasons

## Related

- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#css-architecture) — CSS architecture details
- [DOMAIN_GLOSSARY.md](../DOMAIN_GLOSSARY.md#css-custom-properties-variables) — CSS variables terminology
- `assets/base.css` — Main stylesheet
- `snippets/color-schemes.liquid` — Color scheme CSS generation
- `config/settings_schema.json` — Theme settings definitions
