# Directive: Adding a New Block Type

> **Applies to:** Theme/Extension (Archetype D)
> **Complexity:** Low to Medium
> **Typical files touched:** 1-3 (block file, parent section schema, optional snippet)

## Structural Pattern

### What This Pattern Does

Creates a reusable content unit that can be added within sections. Blocks allow merchants to compose section content by adding, removing, and reordering modular pieces in the theme editor.

### Why This Pattern Exists

Blocks enable:
- **Flexible content composition:** Merchants build sections from modular pieces
- **Reusability:** Same block type can be used in multiple sections
- **Granular control:** Each block instance has its own settings
- **Intuitive editing:** Drag-and-drop reordering in theme editor

### When to Apply This Pattern

**Signals that trigger this pattern:**
- Need a content piece that appears multiple times in a section (buttons, images, text)
- Content should be reorderable by merchants
- Multiple sections need the same content type
- Want to give merchants control over what content appears

**Signals that this pattern does NOT apply:**
- Fixed content that shouldn't be reordered (use section settings)
- Pure display logic without settings (use a snippet)
- Interactive component (add block + JavaScript component)
- Section-level configuration (use section settings)

## Concrete Example

### Context

The `button.liquid` block provides a configurable button/link that can be added to hero sections, content sections, or any section supporting buttons.

### Implementation

**File: `blocks/button.liquid`**

```liquid
{% render 'button', link: block.settings.link %}

{% schema %}
{
  "name": "t:names.button",
  "tag": null,
  "settings": [
    {
      "type": "text",
      "id": "label",
      "label": "t:settings.label",
      "default": "t:text_defaults.button_label"
    },
    {
      "type": "url",
      "id": "link",
      "label": "t:settings.link"
    },
    {
      "type": "checkbox",
      "id": "open_in_new_tab",
      "label": "t:settings.open_new_tab",
      "default": false
    },
    {
      "type": "select",
      "id": "style_class",
      "label": "t:settings.style",
      "options": [
        {
          "value": "button",
          "label": "t:options.primary"
        },
        {
          "value": "button-secondary",
          "label": "t:options.secondary"
        },
        {
          "value": "link",
          "label": "t:options.link"
        }
      ],
      "default": "button"
    }
  ],
  "presets": [
    {
      "name": "t:names.button",
      "category": "t:categories.basic",
      "settings": {
        "link": "shopify://collections/all"
      }
    }
  ]
}
{% endschema %}
```

**File: `snippets/button.liquid`** (rendering snippet)

```liquid
{%- liquid
  assign label = block.settings.label
  assign link = block.settings.link
  assign style = block.settings.style_class
  assign new_tab = block.settings.open_in_new_tab
-%}

<a
  href="{{ link }}"
  class="{{ style }}"
  {% if new_tab %}target="_blank" rel="noopener"{% endif %}
  {{ block.shopify_attributes }}
>
  {{ label }}
</a>
```

**Usage in parent section schema:**

```json
{
  "blocks": [
    {
      "type": "button",
      "name": "t:names.button"
    },
    {
      "type": "@theme"
    },
    {
      "type": "@app"
    }
  ]
}
```

### How the Pattern Was Applied

1. Created `blocks/button.liquid` with schema and minimal rendering
2. Delegated complex rendering to `snippets/button.liquid`
3. Defined settings for label, link, style, and behavior
4. Added preset with default values for theme editor
5. Referenced block type in parent section's blocks array

## Transfer Recipe

### Prerequisites

- [ ] Clear purpose for the block
- [ ] List of settings the block needs
- [ ] Parent section(s) that will use this block
- [ ] Whether to render inline or via snippet

### Steps

1. **Create the block file**
   - Create `blocks/[block-name].liquid`
   - For Horizon convention, use `blocks/_[block-name].liquid` (underscore prefix)
   - Use kebab-case for filename

2. **Add the schema**
   ```json
   {% schema %}
   {
     "name": "t:names.block_name",
     "tag": null,
     "settings": [
       {
         "type": "text",
         "id": "setting_id",
         "label": "t:settings.setting_label",
         "default": "Default value"
       }
     ],
     "presets": [
       {
         "name": "t:names.block_name",
         "category": "t:categories.basic"
       }
     ]
   }
   {% endschema %}
   ```

3. **Add rendering logic**
   - For simple blocks: render directly in block file
   - For complex blocks: use `{% render 'snippet-name', block: block %}`
   - Always include `{{ block.shopify_attributes }}` on the root element

4. **Register in parent section(s)**
   - Add block type to section's schema blocks array
   - For Horizon-style blocks: `{ "type": "_block-name", "name": "t:names.block" }`
   - For standard blocks: `{ "type": "block-name", "name": "t:names.block" }`

5. **Handle block rendering in section**
   ```liquid
   {%- for block in section.blocks -%}
     {% case block.type %}
       {% when '_block-name' %}
         {% render '_block-name', block: block %}
       {% when 'block-name' %}
         {% content_for 'block', type: 'block-name', id: block.id %}
     {% endcase %}
   {%- endfor -%}
   ```

6. **Add translation keys** (if not using existing)
   - Add name to `locales/en.default.schema.json`
   - Add setting labels to schema translations

### Verification

- [ ] Block appears in section's "Add block" menu in theme editor
- [ ] Block settings render correctly in sidebar
- [ ] Block renders correctly on page
- [ ] Block can be reordered via drag-and-drop
- [ ] Multiple instances of block work independently
- [ ] Block respects section's color scheme (if applicable)

### Common Mistakes

- **Missing `block.shopify_attributes`:** Required for theme editor selection/highlighting
- **Forgetting to register in parent section:** Block won't appear in "Add block" menu
- **Inconsistent naming:** Block file, type, and schema name should align
- **Missing presets:** Without presets, block may not appear in theme block picker
- **Not passing block to snippet:** `{% render 'snippet' %}` without `block: block`

## Horizon Block Naming Convention

Horizon uses an underscore prefix for block files to distinguish them from sections:

| Type | Location | Example |
|------|----------|---------|
| Section | `sections/` | `sections/hero.liquid` |
| Block | `blocks/` | `blocks/_product-card.liquid` |
| Snippet | `snippets/` | `snippets/button.liquid` |

When referencing in schema:
```json
{ "type": "_product-card", "name": "t:names.product_card" }
```

## Related Documents

- [DIRECTIVE_adding_section.md](DIRECTIVE_adding_section.md) — Creating sections that use blocks
- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#section-architecture) — Block architecture
- [DOMAIN_GLOSSARY.md](../DOMAIN_GLOSSARY.md#block) — Block terminology
- [DIRECTIVE_adding_translations.md](DIRECTIVE_adding_translations.md) — Adding translation keys
