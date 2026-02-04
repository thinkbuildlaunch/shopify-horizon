# Directive: Modifying Theme Styles

> **Applies to:** Theme/Extension (Archetype D)
> **Complexity:** Low to Medium
> **Typical files touched:** 1-3 (base.css, settings_schema.json, Liquid snippets)

## Structural Pattern

### What This Pattern Does

Modifies the theme's visual appearance through CSS custom properties, direct CSS rules, or theme settings. The styling system is built on native CSS with variables generated from Shopify settings.

### Why This Pattern Exists

The CSS architecture enables:
- **Merchant customization:** Colors, fonts, spacing via theme editor
- **Live preview:** Changes reflect immediately without reload
- **Multiple color schemes:** Different sections can use different palettes
- **No build step:** Pure CSS works directly in browser
- **Maintainability:** Variables centralize values used across components

### When to Apply This Pattern

**Signals that trigger this pattern:**
- Need to change colors, fonts, or spacing theme-wide
- Adding a new component that needs styling
- Creating a new color scheme option
- Overriding default styles for specific elements
- Adding responsive behavior

**Signals that this pattern does NOT apply:**
- Logic changes (use Liquid or JavaScript)
- Layout structure changes (modify HTML in Liquid)
- Content changes (modify Liquid templates)

## Concrete Example

### Context

Adding a new button style variant that uses a gradient background and is configurable via theme settings.

### Implementation

**File: `assets/base.css`** (adding styles)

```css
/* Gradient button variant */
.button-gradient {
  background: linear-gradient(
    135deg,
    rgb(var(--color-primary-rgb)) 0%,
    rgb(var(--color-accent-rgb)) 100%
  );
  color: rgb(var(--color-primary-foreground-rgb));
  border: none;
  padding: var(--spacing-button-vertical) var(--spacing-button-horizontal);
  border-radius: var(--style-border-radius-buttons);
  font-family: var(--font-button-family);
  font-weight: var(--font-button-weight);
  cursor: pointer;
  transition: opacity var(--hover-transition-duration) var(--hover-transition-timing);
}

.button-gradient:hover {
  opacity: 0.9;
}

.button-gradient:focus-visible {
  outline: 2px solid rgb(var(--color-primary-rgb));
  outline-offset: 2px;
}
```

**File: `config/settings_schema.json`** (adding setting)

```json
{
  "name": "t:settings_schema.buttons.name",
  "settings": [
    {
      "type": "checkbox",
      "id": "enable_gradient_buttons",
      "label": "t:settings_schema.buttons.enable_gradient",
      "default": false
    },
    {
      "type": "color",
      "id": "gradient_accent_color",
      "label": "t:settings_schema.buttons.gradient_accent",
      "default": "#ff6b6b"
    }
  ]
}
```

**File: `snippets/css-variables.liquid`** (generating variable)

```liquid
{%- if settings.enable_gradient_buttons -%}
  :root {
    --color-accent-rgb: {{ settings.gradient_accent_color | color_extract: 'red' }},
                        {{ settings.gradient_accent_color | color_extract: 'green' }},
                        {{ settings.gradient_accent_color | color_extract: 'blue' }};
  }
{%- endif -%}
```

### How the Pattern Was Applied

1. Added CSS class with styles using existing CSS variables
2. Created new theme setting for merchant control
3. Generated CSS variable from setting via Liquid
4. Used RGB color format for alpha transparency support

## Transfer Recipe

### Prerequisites

- [ ] Clear understanding of what visual change is needed
- [ ] Knowledge of existing CSS variables available
- [ ] Decision: theme-wide setting or section-specific

### Steps

#### Option A: Simple CSS Addition (No New Settings)

1. **Locate the appropriate CSS file**
   - Main styles: `assets/base.css`
   - Component-specific: Check if component has own CSS

2. **Add CSS rules using existing variables**
   ```css
   .my-new-element {
     color: rgb(var(--color-foreground-rgb));
     background: rgb(var(--color-background-rgb));
     padding: var(--spacing-base);
     font-family: var(--font-body-family);
   }
   ```

3. **Use responsive breakpoints**
   ```css
   @media (min-width: 750px) {
     .my-new-element {
       padding: calc(var(--spacing-base) * 2);
     }
   }
   ```

#### Option B: Adding New Theme Setting

1. **Add setting to `config/settings_schema.json`**
   ```json
   {
     "type": "range",
     "id": "custom_border_radius",
     "label": "t:settings_schema.style.border_radius",
     "min": 0,
     "max": 20,
     "step": 1,
     "unit": "px",
     "default": 4
   }
   ```

2. **Generate CSS variable from setting**
   - Find or create appropriate Liquid snippet in `snippets/`
   - Add variable declaration:
   ```liquid
   :root {
     --custom-border-radius: {{ settings.custom_border_radius }}px;
   }
   ```

3. **Use the variable in CSS**
   ```css
   .my-element {
     border-radius: var(--custom-border-radius);
   }
   ```

4. **Add translation key for setting label**
   - Add to `locales/en.default.schema.json`

#### Option C: Adding Color Scheme Support

1. **Add color to color scheme settings**
   - In `config/settings_schema.json`, find color scheme definition
   - Add new color setting

2. **Generate in color scheme Liquid**
   ```liquid
   .color-scheme-{{ scheme.id }} {
     --color-new-accent: {{ scheme.settings.new_accent_color }};
   }
   ```

3. **Apply via color scheme class**
   ```liquid
   <section class="color-scheme-{{ section.settings.color_scheme }}">
   ```

### Verification

- [ ] Styles apply correctly in browser
- [ ] Theme editor shows new settings (if added)
- [ ] Live preview updates when settings change
- [ ] Responsive breakpoints work correctly
- [ ] Color schemes apply correctly to styled elements
- [ ] No CSS specificity conflicts with existing styles

### Common Mistakes

- **Hardcoding colors:** Always use CSS variables for themeable values
- **Missing RGB format:** For alpha transparency, store colors as RGB components
- **High specificity selectors:** Avoid `!important` and deep nesting
- **Not testing color schemes:** Styles may break with different schemes
- **Forgetting responsive styles:** Test on mobile viewports

## Available CSS Variables

### Colors (RGB format for alpha support)
```css
--color-background-rgb
--color-foreground-rgb
--color-primary-rgb
--color-secondary-rgb
--color-accent-rgb
```

### Typography
```css
--font-body-family
--font-heading-family
--font-subheading-family
--font-accent-family
--font-body-weight
--font-heading-weight
```

### Spacing
```css
--spacing-base
--spacing-section-vertical
--spacing-section-horizontal
```

### Borders & Shadows
```css
--style-border-radius-buttons
--style-border-radius-inputs
--style-border-radius-cards
--style-shadow-card
```

### Animations
```css
--hover-transition-duration
--hover-transition-timing
--surface-transition-duration
```

## Related Documents

- [ADR_002_css_variables_over_preprocessors.md](../adr/ADR_002_css_variables_over_preprocessors.md) — Why CSS variables
- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#css-architecture) — CSS architecture details
- [DOMAIN_GLOSSARY.md](../DOMAIN_GLOSSARY.md#css-custom-properties-variables) — CSS variables terminology
- `assets/base.css` — Main stylesheet
- `config/settings_schema.json` — Theme settings definitions
- `snippets/color-schemes.liquid` — Color scheme generation
