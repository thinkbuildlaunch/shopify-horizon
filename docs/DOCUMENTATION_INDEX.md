# Documentation Index

> Quick reference for navigating Horizon theme documentation

## Document Map

```
shopify-horizon/
├── PRODUCT_OVERVIEW.md              ← Start here: what this theme does
├── README.md                        ← Installation and quick start
├── release-notes.md                 ← Version history and changes
│
├── docs/
│   ├── DOCUMENTATION_INDEX.md       ← You are here
│   ├── PLATFORM_CONVENTIONS.md      ← How this follows Shopify patterns
│   ├── DOMAIN_GLOSSARY.md           ← Terminology definitions
│   ├── RETRIEVAL_DIRECTIVE.md       ← AI agent navigation protocol
│   ├── MIGRATION_PLAN.md            ← Dawn → Horizon migration plan
│   │
│   ├── adr/                         ← Architecture Decision Records
│   │   ├── ADR_001_web_components_over_frameworks.md
│   │   ├── ADR_002_css_variables_over_preprocessors.md
│   │   ├── ADR_003_server_rendered_progressive_enhancement.md
│   │   └── ADR_004_event_driven_component_communication.md
│   │
│   └── directives/                  ← How-to guides
│       ├── DIRECTIVE_adding_section.md
│       ├── DIRECTIVE_adding_block.md
│       ├── DIRECTIVE_adding_component.md
│       ├── DIRECTIVE_modifying_styles.md
│       └── DIRECTIVE_adding_translations.md
│
└── reference/
    └── legacy-dawn-theme/           ← Original Dani Kate Designs theme
        ├── README.md                ← Legacy theme documentation
        ├── config/settings_data.json ← Brand settings to migrate
        └── [Dawn 7.x theme files]
```

## Quick Reference by Question Type

### "What is this / What does it do?"

| Question | Document |
|----------|----------|
| What is this theme? | [PRODUCT_OVERVIEW.md](../PRODUCT_OVERVIEW.md) |
| What features does it have? | [PRODUCT_OVERVIEW.md](../PRODUCT_OVERVIEW.md#what-this-does) |
| What's the tech stack? | [PRODUCT_OVERVIEW.md](../PRODUCT_OVERVIEW.md#technology-stack) |
| What version is this? | [release-notes.md](../release-notes.md) |

### "What does [term] mean?"

| Question | Document |
|----------|----------|
| What is a section? | [DOMAIN_GLOSSARY.md](DOMAIN_GLOSSARY.md#section) |
| What is a block? | [DOMAIN_GLOSSARY.md](DOMAIN_GLOSSARY.md#block) |
| What is a component? | [DOMAIN_GLOSSARY.md](DOMAIN_GLOSSARY.md#component-javascript) |
| What are theme events? | [DOMAIN_GLOSSARY.md](DOMAIN_GLOSSARY.md#theme-events) |
| Platform/Shopify terms | [DOMAIN_GLOSSARY.md](DOMAIN_GLOSSARY.md) |

### "How do I [task]?"

| Task | Document |
|------|----------|
| Add a new section | [DIRECTIVE_adding_section.md](directives/DIRECTIVE_adding_section.md) |
| Add a new block type | [DIRECTIVE_adding_block.md](directives/DIRECTIVE_adding_block.md) |
| Add a JavaScript component | [DIRECTIVE_adding_component.md](directives/DIRECTIVE_adding_component.md) |
| Modify theme styles | [DIRECTIVE_modifying_styles.md](directives/DIRECTIVE_modifying_styles.md) |
| Add translation strings | [DIRECTIVE_adding_translations.md](directives/DIRECTIVE_adding_translations.md) |
| Set up development | [README.md](../README.md) |

### "How does [thing] work?"

| Topic | Document |
|-------|----------|
| Section/block architecture | [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md#section-architecture) |
| JavaScript components | [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md#javascript-component-pattern) |
| CSS/styling system | [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md#css-architecture) |
| Event communication | [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md#event-communication) |
| Localization | [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md#localization-pattern) |

### "Why is [thing] this way?"

| Decision | Document |
|----------|----------|
| Why Web Components? | [ADR_001](adr/ADR_001_web_components_over_frameworks.md) |
| Why CSS variables? | [ADR_002](adr/ADR_002_css_variables_over_preprocessors.md) |
| Why server-rendered? | [ADR_003](adr/ADR_003_server_rendered_progressive_enhancement.md) |
| Why custom events? | [ADR_004](adr/ADR_004_event_driven_component_communication.md) |

### Migration (Dani Kate Designs)

| Question | Document |
|----------|----------|
| Migration overview | [MIGRATION_PLAN.md](MIGRATION_PLAN.md) |
| Legacy theme colors/settings | [reference/legacy-dawn-theme/README.md](../reference/legacy-dawn-theme/README.md) |
| Original homepage structure | [reference/legacy-dawn-theme/templates/index.json](../reference/legacy-dawn-theme/templates/index.json) |
| Original theme settings | [reference/legacy-dawn-theme/config/settings_data.json](../reference/legacy-dawn-theme/config/settings_data.json) |

## Document Layers

### Layer 1: Orientation
*"What is this and where do I start?"*

- [PRODUCT_OVERVIEW.md](../PRODUCT_OVERVIEW.md) — Theme overview and quick start
- [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) — This file
- [RETRIEVAL_DIRECTIVE.md](RETRIEVAL_DIRECTIVE.md) — AI navigation protocol

### Layer 2: Semantic
*"What do terms mean in this codebase?"*

- [DOMAIN_GLOSSARY.md](DOMAIN_GLOSSARY.md) — Terminology definitions

### Layer 3: Procedural
*"How do I do [specific task]?"*

- [DIRECTIVE_adding_section.md](directives/DIRECTIVE_adding_section.md)
- [DIRECTIVE_adding_block.md](directives/DIRECTIVE_adding_block.md)
- [DIRECTIVE_adding_component.md](directives/DIRECTIVE_adding_component.md)
- [DIRECTIVE_modifying_styles.md](directives/DIRECTIVE_modifying_styles.md)
- [DIRECTIVE_adding_translations.md](directives/DIRECTIVE_adding_translations.md)
- [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md) — Platform patterns

### Layer 4: Rationale
*"Why was [decision] made?"*

- [ADR_001_web_components_over_frameworks.md](adr/ADR_001_web_components_over_frameworks.md)
- [ADR_002_css_variables_over_preprocessors.md](adr/ADR_002_css_variables_over_preprocessors.md)
- [ADR_003_server_rendered_progressive_enhancement.md](adr/ADR_003_server_rendered_progressive_enhancement.md)
- [ADR_004_event_driven_component_communication.md](adr/ADR_004_event_driven_component_communication.md)

### Layer 5: Operational
*"How does the system behave at runtime?"*

- [PLATFORM_CONVENTIONS.md](PLATFORM_CONVENTIONS.md#section-rendering-api) — Section Rendering API
- [DOMAIN_GLOSSARY.md](DOMAIN_GLOSSARY.md#morph) — DOM morphing

## Key Code Locations

| Concern | Primary Location | Notes |
|---------|------------------|-------|
| Sections | `sections/*.liquid` | 41 files |
| Blocks | `blocks/*.liquid` | 94 files (prefixed with `_`) |
| Snippets | `snippets/*.liquid` | 94 files |
| Templates | `templates/*.json` | 13 files |
| JavaScript | `assets/*.js` | ~60 files |
| Styles | `assets/base.css` | Main stylesheet |
| Settings | `config/settings_schema.json` | Theme configuration |
| Translations | `locales/*.json` | 27+ languages |

## Document Statistics

| Category | Count | Total Lines |
|----------|-------|-------------|
| Orientation docs | 3 | ~400 |
| Glossary | 1 | ~320 |
| Directives | 5 | ~1,200 |
| ADRs | 4 | ~600 |
| Platform docs | 1 | ~320 |
| **Total** | **14** | **~2,840** |

## Maintenance

### Adding New Documentation

1. Determine document type (ADR, directive, glossary entry, etc.)
2. Follow templates in respective directories
3. Update this index
4. Update RETRIEVAL_DIRECTIVE.md if navigation patterns change

### Documentation Limits

Per the Adaptive Documentation Protocol:
- Maximum 40 documents in `/docs`
- Maximum 20 active directives
- Maximum 30 active ADRs
- Maximum 50 glossary terms

Current status: Well within limits.
