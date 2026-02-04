# Retrieval Directive

> **Purpose:** Protocol for AI agents to navigate this codebase's documentation
> **For humans:** This document optimizes AI behavior; you can use it as a reference but it's designed for LLMs

## Codebase Context

**Archetype:** Theme / Template / Extension (Archetype D)
**Platform:** Shopify Online Store 2.0
**Documentation depth:** Standard (MVD + Rationale + Procedural layers)
**Total document count:** 14

## Query Classification

### Type 1: Definition Questions

**Patterns:** "What is [term]?" | "What does [thing] mean?" | "Define [concept]"

**Protocol:**
1. Check `docs/DOMAIN_GLOSSARY.md` first
2. If not found, check `docs/PLATFORM_CONVENTIONS.md` for platform patterns
3. If still unclear, search codebase for type definitions or usage

**Example queries:**
- "What is a section?" → DOMAIN_GLOSSARY.md#section
- "What are theme events?" → DOMAIN_GLOSSARY.md#theme-events
- "What does morph mean?" → DOMAIN_GLOSSARY.md#morph

### Type 2: Implementation Questions

**Patterns:** "How do I [task]?" | "How should I [action]?" | "Add a [thing]"

**Protocol:**
1. Check `docs/directives/` for matching `DIRECTIVE_*.md`
2. If no directive exists, check `docs/PLATFORM_CONVENTIONS.md` for patterns
3. Find similar implementation in codebase as reference
4. Check related ADRs for constraints

**Directive mapping:**
| Task Pattern | Directive |
|--------------|-----------|
| "add/create section" | DIRECTIVE_adding_section.md |
| "add/create block" | DIRECTIVE_adding_block.md |
| "add/create component", "JavaScript" | DIRECTIVE_adding_component.md |
| "style", "CSS", "color", "font" | DIRECTIVE_modifying_styles.md |
| "translate", "localize", "language" | DIRECTIVE_adding_translations.md |

### Type 3: Rationale Questions

**Patterns:** "Why is [thing] this way?" | "Why did we [decision]?" | "Why not [alternative]?"

**Protocol:**
1. Search `docs/adr/` for relevant ADR
2. Check code comments near implementation
3. Check git history for context

**ADR mapping:**
| Topic | ADR |
|-------|-----|
| Web Components, no React/Vue | ADR_001 |
| CSS variables, no SCSS/Tailwind | ADR_002 |
| Server-rendered, Liquid-first | ADR_003 |
| Event system, ThemeEvents | ADR_004 |

### Type 4: Debugging Questions

**Patterns:** "Why isn't [thing] working?" | "[Error] when [action]" | "Not rendering"

**Protocol:**
1. Identify component type (section, block, JS component, CSS)
2. Check relevant directive's "Common Mistakes" section
3. Check PLATFORM_CONVENTIONS.md for correct patterns
4. Search codebase for working examples

**Common debugging paths:**
| Symptom | Check |
|---------|-------|
| Section not appearing | Template JSON, section preset |
| Block not rendering | Parent section schema, block type reference |
| JavaScript not working | Custom element registration, ref attributes |
| Styles not applying | CSS variable names, color scheme class |
| Translation not showing | `| t` filter, JSON key path |

### Type 5: Location Questions

**Patterns:** "Where is [thing]?" | "Find the [component]" | "Which file has [feature]?"

**Protocol:**
1. Use codebase search directly (faster than docs)
2. Check DOMAIN_GLOSSARY.md "Code location" mappings
3. Check PLATFORM_CONVENTIONS.md for directory structure

**Quick location reference:**
| Looking for | Location |
|-------------|----------|
| Sections | `sections/*.liquid` |
| Blocks | `blocks/*.liquid` (prefixed `_`) |
| Snippets | `snippets/*.liquid` |
| Templates | `templates/*.json` |
| JavaScript | `assets/*.js` |
| Base styles | `assets/base.css` |
| Settings | `config/settings_schema.json` |
| Translations | `locales/en.default.json` |
| Schema translations | `locales/en.default.schema.json` |

### Type 6: Architecture Questions

**Patterns:** "How does [system] work?" | "Explain [architecture]" | "What's the flow for [feature]?"

**Protocol:**
1. Check PLATFORM_CONVENTIONS.md for system patterns
2. Check relevant ADRs for design rationale
3. Trace through codebase starting from entry points

## Document Precedence

When documents conflict or overlap:

1. **Specific supersedes general:** Directive > Platform Conventions > Product Overview
2. **Newer ADR supersedes older ADR:** Check status and dates
3. **Code is truth when docs are stale:** If doc references non-existent code, trust the code
4. **Platform docs supersede theme docs:** For Shopify platform behavior, defer to official Shopify docs

## Navigation Shortcuts

### Starting Points by Goal

| Goal | Start Here |
|------|------------|
| Understand the codebase | PRODUCT_OVERVIEW.md |
| Find documentation | DOCUMENTATION_INDEX.md |
| Learn a term | DOMAIN_GLOSSARY.md |
| Do a task | docs/directives/ |
| Understand a decision | docs/adr/ |
| Follow platform patterns | PLATFORM_CONVENTIONS.md |

### File Type Quick Reference

| Extension | Type | Schema Location |
|-----------|------|-----------------|
| `.liquid` | Liquid template | Bottom of file in `{% schema %}` |
| `.json` | JSON config/template | N/A |
| `.js` | JavaScript module | N/A |
| `.css` | Stylesheet | N/A |

## Codebase-Specific Patterns

### Pattern: Section with Blocks

**Recognition:** Need to create or modify a page component with configurable content

**Protocol:**
1. Read DIRECTIVE_adding_section.md
2. Find similar section in `sections/` as reference
3. Check section's schema for block types
4. Blocks are rendered via `{% for block in section.blocks %}`

### Pattern: JavaScript Enhancement

**Recognition:** Need client-side interactivity for a Liquid-rendered element

**Protocol:**
1. Read DIRECTIVE_adding_component.md
2. Check `assets/component.js` for base class
3. Check `assets/events.js` for theme events
4. Component wraps server-rendered HTML with `<component-name>` element
5. Use `ref` attributes for DOM access

### Pattern: Theme Setting

**Recognition:** Need merchant-configurable value (color, font, toggle, etc.)

**Protocol:**
1. Read DIRECTIVE_modifying_styles.md for style settings
2. Add setting to `config/settings_schema.json`
3. Generate CSS variable via Liquid snippet if needed
4. Add schema translation to `locales/en.default.schema.json`

### Pattern: Color Scheme Aware

**Recognition:** Element needs to respect section's color scheme

**Protocol:**
1. Use CSS variables: `rgb(var(--color-foreground-rgb))`
2. Ensure parent has `color-scheme-{{ section.settings.color_scheme }}` class
3. Check `snippets/color-schemes.liquid` for available variables

### Pattern: Translation Key

**Recognition:** Adding user-visible text

**Protocol:**
1. Never hardcode text
2. Add key to `locales/en.default.json` (customer-facing)
3. Add key to `locales/en.default.schema.json` (theme editor)
4. Use `{{ 'key.path' | t }}` in Liquid
5. Use `"t:key.path"` in schema JSON

## Validation Signals

### Signs You're On The Right Track

- Found directive for the task
- Code matches patterns in PLATFORM_CONVENTIONS.md
- Using existing CSS variables, not hardcoding values
- Using translation keys, not hardcoded text
- JavaScript extends `Component` base class

### Signs You May Be Off Track

- Can't find any similar code in codebase
- Fighting against platform patterns
- Need to import external dependencies
- Modifying core files when extension would work
- Creating workarounds for platform constraints

## Emergency Reference

### I Need To Quickly...

| Task | Do This |
|------|---------|
| Add text to page | Add block to section, use translation key |
| Change a color | Modify CSS variable or add to color scheme |
| Add button | Use existing `button` block type |
| Add image | Use `image_picker` setting type |
| Make something interactive | Create Web Component, extend `Component` |
| Update cart | Dispatch `CartUpdateEvent`, handle `cart:update` |
| Get product variant | Listen for `variant:update` event |

### Common CSS Variables

```css
--color-background-rgb
--color-foreground-rgb
--color-primary-rgb
--font-body-family
--font-heading-family
--spacing-base
--style-border-radius-buttons
```

### Common Theme Events

```javascript
ThemeEvents.variantSelected   // 'variant:selected'
ThemeEvents.variantUpdate     // 'variant:update'
ThemeEvents.cartUpdate        // 'cart:update'
ThemeEvents.cartError         // 'cart:error'
```
