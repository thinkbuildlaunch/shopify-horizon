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

### Layout Settings to Preserve

| Setting | Dawn Value | Notes |
|---------|------------|-------|
| Page width | 1200px | Standard width |
| Section spacing | 0 | No gaps between sections |
| Grid horizontal | 8px | Tight grid spacing |
| Grid vertical | 8px | Tight grid spacing |
| Button radius | 2px | Nearly square buttons |
| Card style | Standard | No card shadows |
| Badge position | Bottom left | Product badges |

### Logo & Branding

- Logo file: `Dani_Kates_designs_final_logo_new-01.png`
- Logo width: 90px
- Also used as favicon and checkout logo

## Page-by-Page Migration

### Homepage

**Current (Dawn + PageFly):**
- PageFly custom layout with embedded content
- Disabled Dawn banner with "Customopoly Board Games" heading
- Banner image: `new_banner_2.jpg`

**PageFly Content to Recreate:**
1. Hero banner with product imagery
2. Value propositions (3 columns): Customizable, Quality, Great Gift
3. Product showcase (3 tiers: Classic $225, Photo $275, Cartoon $350)
4. Featured packages grid
5. Card games section
6. How It Works (4 steps)
7. Customer testimonials (Lauren, Katherine, Deborah)

**Target (Horizon):**
1. **Hero section** (`image-banner` or `slideshow`)
   - Heading: "Custom Designed Board Games" or "Customopoly Board Games"
   - Subtext: "The most unique personalized gift"
   - CTA: Shop Now → Complete Game Package collection
   - Large product/lifestyle imagery

2. **Value Propositions** (`multicolumn` section)
   - Column 1: "100% Customizable"
   - Column 2: "Quality Materials"
   - Column 3: "Great Gift Idea"

3. **Featured Collection** (`featured-collection`)
   - Collection: Complete Game Package
   - Show 3-4 products with pricing
   - Grid layout

4. **How It Works** (`multicolumn` or `rich-text`)
   - Step 1: Choose your game style
   - Step 2: Upload your photos/content
   - Step 3: Review your design
   - Step 4: Receive your custom game

5. **Card Games** (`featured-collection`)
   - Separate collection for card game products

6. **Testimonials** (`multicolumn` or Judge.me widget)
   - Customer quotes (Lauren, Katherine, Deborah)

7. **Newsletter signup** (`newsletter`)

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

**Current Dawn Configuration:**
| Setting | Value |
|---------|-------|
| Media position | Left |
| Gallery layout | Stacked |
| Media size | Large |
| Sticky product info | Enabled |
| Variant picker | Button style |
| Dynamic checkout | Enabled |
| Product recommendations | 4 products |

**Migration tasks:**
1. Map product form elements to Horizon's product block system
2. Configure media gallery (stacked layout, left position)
3. Set up variant picker (button style to match)
4. Enable sticky product info
5. Enable product recommendations (4 products, square ratio)
6. Integrate Judge.me reviews (app reinstall required)
7. Note: Collapsible tabs were disabled in Dawn - evaluate for Horizon

### Collection Page

**Current Dawn Configuration:**
| Setting | Value |
|---------|-------|
| Products per page | 16 |
| Desktop columns | 4 |
| Mobile columns | 2 |
| Image ratio | Adapt |
| Filtering | Horizontal |
| Sorting | Enabled |

**Migration tasks:**
1. Configure filtering (horizontal facets)
2. Set grid layout (4 columns desktop, 2 mobile)
3. Products per page: 16
4. Image ratio: Adapt to image
5. Enable sorting
6. Evaluate quick-add (was disabled)

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
