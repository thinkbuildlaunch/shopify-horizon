# Directive: Adding Translations

> **Applies to:** Theme/Extension (Archetype D)
> **Complexity:** Low
> **Typical files touched:** 2-4 (en.default.json, en.default.schema.json, Liquid files)

## Structural Pattern

### What This Pattern Does

Adds localized text strings that can be translated into multiple languages. Shopify themes support 27+ languages, and all user-facing text should use translation keys rather than hardcoded strings.

### Why This Pattern Exists

Translation keys enable:
- **Multi-language support:** Merchants can serve customers in their language
- **Centralized text:** All UI text in one location for easy updates
- **Shopify translation apps:** Third-party tools can manage translations
- **Consistent terminology:** Same term used consistently throughout theme

### When to Apply This Pattern

**Signals that trigger this pattern:**
- Adding user-facing text (buttons, labels, messages)
- Creating new section/block with settings labels
- Adding accessibility text (aria-labels, screen reader text)
- Any text visible to customers or in theme editor

**Signals that this pattern does NOT apply:**
- Code comments (use English directly)
- Internal variable names
- Debug/development messages
- Content that merchants will customize (use settings instead)

## Concrete Example

### Context

Adding translations for a new "Quick View" feature with button text, modal title, and accessibility labels.

### Implementation

**File: `locales/en.default.json`** (customer-facing text)

```json
{
  "products": {
    "quick_view": {
      "button_label": "Quick view",
      "modal_title": "Quick view: {{ product_title }}",
      "close_button": "Close quick view",
      "add_to_cart": "Add to cart",
      "view_full_details": "View full details"
    }
  },
  "accessibility": {
    "quick_view_opened": "Quick view opened for {{ product_title }}",
    "quick_view_closed": "Quick view closed"
  }
}
```

**File: `locales/en.default.schema.json`** (theme editor labels)

```json
{
  "settings_schema": {
    "quick_view": {
      "name": "Quick view",
      "settings": {
        "enable": "Enable quick view",
        "animation": "Animation style",
        "animation_options": {
          "fade": "Fade",
          "slide": "Slide up",
          "none": "None"
        }
      }
    }
  },
  "sections": {
    "product_card": {
      "blocks": {
        "quick_view_button": {
          "name": "Quick view button"
        }
      }
    }
  }
}
```

**File: `snippets/quick-view-button.liquid`** (using translations)

```liquid
<button
  type="button"
  class="quick-view-button"
  aria-label="{{ 'products.quick_view.button_label' | t }} - {{ product.title }}"
  data-product-url="{{ product.url }}"
>
  {{ 'products.quick_view.button_label' | t }}
</button>
```

**File: `sections/quick-view-modal.liquid`** (with interpolation)

```liquid
<div
  class="quick-view-modal"
  role="dialog"
  aria-label="{{ 'products.quick_view.modal_title' | t: product_title: product.title }}"
>
  <button
    class="quick-view-modal__close"
    aria-label="{{ 'products.quick_view.close_button' | t }}"
  >
    {% render 'icon-close' %}
  </button>

  <h2>{{ product.title }}</h2>

  <a href="{{ product.url }}">
    {{ 'products.quick_view.view_full_details' | t }}
  </a>
</div>
```

### How the Pattern Was Applied

1. Added nested structure in `en.default.json` following existing patterns
2. Used interpolation `{{ product_title }}` for dynamic values
3. Added schema translations in `en.default.schema.json` for theme editor
4. Used `| t` filter in Liquid to output translated text
5. Passed variables to translation with `| t: key: value` syntax

## Transfer Recipe

### Prerequisites

- [ ] List of all text strings needed
- [ ] Identification of which are customer-facing vs theme editor
- [ ] Variable interpolation needs identified
- [ ] Existing translation key structure reviewed

### Steps

1. **Identify translation type**
   - Customer-facing text → `locales/en.default.json`
   - Theme editor labels → `locales/en.default.schema.json`

2. **Choose appropriate location in JSON structure**
   - Follow existing nesting patterns
   - Group related strings together
   - Common top-level keys: `products`, `collections`, `cart`, `accessibility`, `general`

3. **Add translation keys to `en.default.json`**
   ```json
   {
     "section_name": {
       "feature_name": {
         "string_key": "The visible text"
       }
     }
   }
   ```

4. **Add schema translations to `en.default.schema.json`**
   ```json
   {
     "settings_schema": {
       "section_name": {
         "settings": {
           "setting_id": "Setting label"
         }
       }
     }
   }
   ```

5. **Use translations in Liquid**
   ```liquid
   {%- comment -%} Simple translation {%- endcomment -%}
   {{ 'section.feature.key' | t }}

   {%- comment -%} With variable interpolation {%- endcomment -%}
   {{ 'section.feature.key' | t: variable_name: actual_value }}

   {%- comment -%} In an attribute {%- endcomment -%}
   aria-label="{{ 'accessibility.label' | t }}"
   ```

6. **Reference in schemas**
   ```json
   {
     "name": "t:sections.section_name.name",
     "settings": [
       {
         "label": "t:sections.section_name.settings.setting_id"
       }
     ]
   }
   ```

### Verification

- [ ] Text displays correctly in storefront
- [ ] Theme editor shows translated labels
- [ ] Variables interpolate correctly
- [ ] No JSON syntax errors (validate JSON)
- [ ] Keys follow existing naming conventions

### Common Mistakes

- **Invalid JSON:** Missing commas, extra commas, unescaped quotes
- **Wrong file:** Customer text in schema file or vice versa
- **Missing `| t` filter:** Key displayed instead of translated text
- **Incorrect interpolation syntax:** Use `{{ variable }}` in JSON, `: variable: value` in Liquid
- **Inconsistent nesting:** Not following existing structure patterns

## Translation Key Conventions

### Naming Pattern
```
[top_level].[feature].[specific_string]
```

### Common Top-Level Keys

| Key | Purpose | Example |
|-----|---------|---------|
| `products` | Product-related text | `products.inventory.in_stock` |
| `collections` | Collection pages | `collections.filter.clear_all` |
| `cart` | Cart and checkout | `cart.summary.total` |
| `accessibility` | Screen reader text | `accessibility.skip_to_content` |
| `general` | Site-wide text | `general.search.placeholder` |
| `customer` | Account pages | `customer.login.title` |
| `gift_cards` | Gift card pages | `gift_cards.issued.title` |

### Interpolation Syntax

**In JSON (en.default.json):**
```json
{
  "items_count": "{{ count }} items in your cart"
}
```

**In Liquid:**
```liquid
{{ 'cart.items_count' | t: count: cart.item_count }}
```

### Pluralization

For count-dependent text, use separate keys:
```json
{
  "item_count": {
    "one": "{{ count }} item",
    "other": "{{ count }} items"
  }
}
```

## Related Documents

- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#localization-pattern) — Localization patterns
- [DIRECTIVE_adding_section.md](DIRECTIVE_adding_section.md) — Schema translation references
- [DIRECTIVE_adding_block.md](DIRECTIVE_adding_block.md) — Block schema translations
- `locales/en.default.json` — Main translation file
- `locales/en.default.schema.json` — Schema translation file
