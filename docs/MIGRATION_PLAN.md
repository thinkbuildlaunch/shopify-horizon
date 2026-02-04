# Theme Migration Plan: Dawn → Horizon

> **Client:** Dani Kate Designs
> **Product:** Customopoly (personalized board games)
> **Source Theme:** Dawn 7.x (customized with PageFly)
> **Target Theme:** Horizon 3.3.0

## Migration Overview

### Business Context

Dani Kate Designs sells personalized "Customopoly" board games - custom Monopoly-style games that make unique personalized gifts. The current store runs on Dawn 7.x with heavy reliance on PageFly for custom layouts.

### Migration Goals

1. **Modernize storefront** with Horizon's enhanced design system
2. **Improve performance** via Horizon's Web Components architecture
3. **Maintain brand identity** (colors, typography, messaging)
4. **Eliminate PageFly dependency** using Horizon's native sections
5. **Preserve SEO** and customer experience continuity

## Brand Assets to Migrate

### Colors

| Dawn Setting | Value | Horizon Mapping |
|--------------|-------|-----------------|
| `colors_text` | `#121212` | `--color-foreground` |
| `colors_accent_1` | `#121212` | Scheme accent |
| `colors_accent_2` | `#334fb4` | Scheme primary |
| `colors_background_1` | `#ffffff` | `--color-background` |
| `colors_background_2` | `#f3f3f3` | Secondary scheme |
| `colors_solid_button_labels` | `#ffffff` | Button text |

### Typography

| Element | Dawn | Horizon Mapping |
|---------|------|-----------------|
| Heading font | Assistant | Font heading family |
| Body font | Assistant | Font body family |

### Social Links

- Facebook: `https://facebook.com/danikatesdesigns`
- Instagram: `http://instagram.com/danikatesdesigns`

## Page-by-Page Migration

### Homepage

**Current (Dawn + PageFly):**
- PageFly custom layout (content in PageFly, not theme)
- Disabled banner with "Customopoly Board Games" heading

**Target (Horizon):**
1. **Hero section** - Main banner with product imagery
   - Heading: "Customopoly Board Games"
   - Subtext: "The most unique personalized gift"
   - CTA: Shop Now → Collections

2. **Featured Collection** - Product showcase
   - Collection: Complete Game Package
   - Grid or carousel layout

3. **How It Works** (multicolumn or custom section)
   - Step 1: Customize
   - Step 2: Order
   - Step 3: Receive

4. **Testimonials/Reviews** - Judge.me integration

5. **Newsletter signup** - Email capture

### Header

| Feature | Dawn | Horizon |
|---------|------|---------|
| Logo position | Middle-left | Configurable |
| Logo width | 90px | Match or adjust |
| Menu style | Dropdown | Mega menu available |
| Sticky | Disabled | Enable for better UX |
| Announcement | "We Ship Worldwide!" | Preserve |

### Footer

| Block | Dawn Content | Horizon Mapping |
|-------|--------------|-----------------|
| Links 1 | Quick links | Footer menu |
| Links 2 | Info | Footer menu |
| Text | Contact info (phone) | Footer text block |
| Newsletter | Enabled | Enable |
| Social | FB, Instagram | Social links |

### Product Page

**Migration tasks:**
1. Map product form elements
2. Configure media gallery
3. Set up variant picker (Horizon uses swatch/button system)
4. Enable product recommendations
5. Integrate Judge.me reviews (app reinstall required)

### Collection Page

**Migration tasks:**
1. Configure filtering (facets)
2. Set grid layout
3. Enable quick-add if desired

## App Reinstallation

These apps will need to be reinstalled and configured after theme migration:

| App | Purpose | Priority |
|-----|---------|----------|
| Judge.me Reviews | Product reviews | High |
| Email Popups | Email capture | Medium |
| PageFly | Page builder | Remove (using native sections) |

## Migration Phases

### Phase 1: Configuration
- [ ] Set up Horizon color scheme matching Dawn colors
- [ ] Configure typography (Assistant font family)
- [ ] Set up header with logo, menu, announcement bar
- [ ] Configure footer with links, contact, newsletter

### Phase 2: Homepage
- [ ] Create hero section with main messaging
- [ ] Add featured collection section
- [ ] Create "How It Works" section
- [ ] Add newsletter section

### Phase 3: Product Pages
- [ ] Configure product template
- [ ] Set up media gallery
- [ ] Configure variant picker
- [ ] Add product recommendations

### Phase 4: Collection Pages
- [ ] Configure collection template
- [ ] Set up filtering
- [ ] Configure product grid

### Phase 5: Supporting Pages
- [ ] Contact page
- [ ] About page (if exists)
- [ ] FAQ/Help pages

### Phase 6: Testing & Launch
- [ ] Cross-browser testing
- [ ] Mobile responsiveness check
- [ ] Performance testing
- [ ] SEO verification
- [ ] App reinstallation
- [ ] Go-live

## Reference Files

| What | Location |
|------|----------|
| Legacy theme files | `reference/legacy-dawn-theme/` |
| Legacy settings | `reference/legacy-dawn-theme/config/settings_data.json` |
| Legacy homepage | `reference/legacy-dawn-theme/templates/index.json` |
| Horizon docs | `docs/` |
| Horizon sections | `sections/` |

## Notes

- PageFly content is NOT in the theme files - it's stored in PageFly's app storage
- Will need to recreate homepage design using Horizon's native sections
- Logo image (`Dani_Kates_designs_final_logo_new-01.png`) is in Shopify's CDN
- Consider enabling features Dawn had disabled (sticky header)
