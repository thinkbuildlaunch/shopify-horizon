# Directive: Adding a New Section

> **Applies to:** Theme/Extension (Archetype D)
> **Complexity:** Medium
> **Typical files touched:** 2-4 (section file, template JSON, optional blocks/snippets)

## Structural Pattern

### What This Pattern Does

Creates a new configurable page component that merchants can add to pages via the Shopify theme editor. Sections are the primary building blocks of theme pages, containing their own settings, blocks, and rendering logic.

### Why This Pattern Exists

Sections enable:
- **Merchant customization:** Non-developers can add/arrange/configure page content
- **Reusability:** Same section can be used on multiple pages
- **Isolation:** Each section is self-contained with its own schema
- **Live preview:** Theme editor shows changes in real-time

### When to Apply This Pattern

**Signals that trigger this pattern:**
- Need a new page component (hero, feature grid, testimonials, etc.)
- Existing section doesn't meet requirements and can't be extended
- Component should be configurable via theme editor
- Content will vary between pages or be merchant-controlled

**Signals that this pattern does NOT apply:**
- Pure utility code (use a snippet instead)
- JavaScript-only functionality (use a component)
- Simple repeated markup (use a snippet with render)
- Theme-wide element (consider group sections for header/footer)

## Concrete Example

### Context

The `hero.liquid` section provides a full-width hero component with media (images/video), text overlay, and call-to-action buttons.

### Implementation

**File: `sections/hero.liquid`**

```liquid
{% liquid
  assign media_count = 0
  if section.settings.image_1 != blank
    assign media_count = media_count | plus: 1
  endif
%}

<section
  class="hero color-scheme-{{ section.settings.color_scheme }}"
  data-section-id="{{ section.id }}"
>
  <div class="hero__media">
    {%- if section.settings.image_1 != blank -%}
      {{ section.settings.image_1 | image_url: width: 1920 | image_tag:
        class: 'hero__image',
        sizes: '100vw',
        widths: '375, 750, 1100, 1500, 1920'
      }}
    {%- endif -%}
  </div>

  <div class="hero__content">
    {%- for block in section.blocks -%}
      {% case block.type %}
        {% when 'heading' %}
          <h1 class="hero__heading" {{ block.shopify_attributes }}>
            {{ block.settings.text }}
          </h1>
        {% when 'text' %}
          <p class="hero__text" {{ block.shopify_attributes }}>
            {{ block.settings.text }}
          </p>
        {% when 'button' %}
          {% render 'button', block: block %}
      {% endcase %}
    {%- endfor -%}
  </div>
</section>

{% schema %}
{
  "name": "t:names.hero",
  "tag": "section",
  "class": "section-hero",
  "settings": [
    {
      "type": "image_picker",
      "id": "image_1",
      "label": "t:settings.image"
    },
    {
      "type": "color_scheme",
      "id": "color_scheme",
      "label": "t:settings.color_scheme",
      "default": "scheme-1"
    }
  ],
  "blocks": [
    {
      "type": "heading",
      "name": "t:names.heading",
      "settings": [
        {
          "type": "text",
          "id": "text",
          "label": "t:settings.heading",
          "default": "Hero heading"
        }
      ]
    },
    {
      "type": "text",
      "name": "t:names.text",
      "settings": [
        {
          "type": "richtext",
          "id": "text",
          "label": "t:settings.text"
        }
      ]
    },
    {
      "type": "button",
      "name": "t:names.button",
      "settings": [
        {
          "type": "text",
          "id": "label",
          "label": "t:settings.label",
          "default": "Shop now"
        },
        {
          "type": "url",
          "id": "link",
          "label": "t:settings.link"
        }
      ]
    },
    {
      "type": "@theme"
    },
    {
      "type": "@app"
    }
  ],
  "presets": [
    {
      "name": "t:names.hero",
      "blocks": [
        { "type": "heading" },
        { "type": "text" },
        { "type": "button" }
      ]
    }
  ]
}
{% endschema %}
```

**File: `templates/index.json`** (adding section to homepage)

```json
{
  "sections": {
    "hero": {
      "type": "hero",
      "settings": {
        "color_scheme": "scheme-1"
      },
      "blocks": {
        "heading": {
          "type": "heading",
          "settings": {
            "text": "Welcome to our store"
          }
        }
      },
      "block_order": ["heading"]
    }
  },
  "order": ["hero"]
}
```

### How the Pattern Was Applied

1. Created `sections/hero.liquid` with Liquid rendering logic
2. Added `{% schema %}` block defining settings, blocks, and presets
3. Used translation keys (`t:names.*`, `t:settings.*`) for localization
4. Included `@theme` and `@app` block types for extensibility
5. Added preset for "Add section" button in theme editor
6. Referenced section in template JSON to place on page

## Transfer Recipe

### Prerequisites

- [ ] Clear understanding of section's purpose and content structure
- [ ] List of merchant-configurable settings needed
- [ ] List of block types the section should support
- [ ] Translation keys prepared (or will use defaults initially)

### Steps

1. **Create the section file**
   - Create `sections/[section-name].liquid`
   - Use kebab-case for filename
   - Add basic HTML structure

2. **Add section settings in schema**
   - Define settings array with appropriate input types
   - Use `t:settings.*` translation keys for labels
   - Include `color_scheme` if section needs theming
   - Common types: `text`, `richtext`, `image_picker`, `url`, `select`, `checkbox`, `range`

3. **Define block types in schema**
   - Add blocks array with each block type
   - Each block needs `type`, `name`, and `settings`
   - Use underscore prefix for block file references: `type: "_block-name"`
   - Always include `{ "type": "@theme" }` and `{ "type": "@app" }` for extensibility

4. **Add preset for theme editor**
   - Include at least one preset in schema
   - Presets appear in "Add section" menu
   - Define default blocks and settings

5. **Implement block rendering in Liquid**
   - Loop through `section.blocks`
   - Use `{% case block.type %}` to render each type
   - Include `{{ block.shopify_attributes }}` on block wrapper elements
   - Render block snippets with `{% render '_block-name', block: block %}`

6. **Add section to a template** (optional for immediate testing)
   - Edit appropriate `templates/*.json`
   - Add section reference in `sections` object
   - Add section ID to `order` array

7. **Add translation keys**
   - Add entries to `locales/en.default.json` for UI text
   - Add entries to `locales/en.default.schema.json` for settings labels

### Verification

- [ ] Section appears in "Add section" menu in theme editor
- [ ] Settings render correctly in theme editor sidebar
- [ ] Blocks can be added, removed, and reordered
- [ ] Section renders correctly on the page
- [ ] Changes in theme editor reflect immediately (live preview)
- [ ] Color scheme applies correctly if used

### Common Mistakes

- **Missing `@theme` and `@app` blocks:** Always include these for theme/app block support
- **Hardcoded text:** Use translation keys, not hardcoded strings
- **Missing `block.shopify_attributes`:** Required for theme editor block selection
- **Invalid JSON in schema:** Schema must be valid JSON (no trailing commas)
- **Forgetting presets:** Without a preset, section won't appear in "Add section" menu

## Related Documents

- [PLATFORM_CONVENTIONS.md](../PLATFORM_CONVENTIONS.md#section-architecture) — Section architecture details
- [DIRECTIVE_adding_block.md](DIRECTIVE_adding_block.md) — Creating reusable blocks
- [DIRECTIVE_adding_translations.md](DIRECTIVE_adding_translations.md) — Adding translation keys
- [DOMAIN_GLOSSARY.md](../DOMAIN_GLOSSARY.md#section) — Section terminology
