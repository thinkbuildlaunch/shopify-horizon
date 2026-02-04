# Legacy Dawn Theme Reference

> **Source:** Dani Kate Designs Shopify store
> **Theme:** Dawn 7.x (customized)
> **Purpose:** Reference for migrating to Horizon theme

## Business Context

**Store:** Dani Kate Designs
**Product:** Customopoly - personalized/custom board games
**Tagline:** "The most unique personalized gift"

### Contact Information
- Phone: 516-987-8704
- Facebook: [facebook.com/danikatesdesigns](https://facebook.com/danikatesdesigns)
- Instagram: [instagram.com/danikatesdesigns](https://instagram.com/danikatesdesigns)

### Key Collections
- Complete Game Package (Standard)
- (Additional collections to be identified from store data)

## Theme Configuration

### Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Text | `#121212` | Body text, headings |
| Accent 1 | `#121212` | Dark/black accent |
| Accent 2 | `#334fb4` | Blue accent |
| Background 1 | `#ffffff` | Primary background |
| Background 2 | `#f3f3f3` | Secondary background |
| Button Labels | `#ffffff` | White text on buttons |

### Typography

| Element | Font | Weight |
|---------|------|--------|
| Headings | Assistant | Normal (400) |
| Body | Assistant | Normal (400) |

### Layout Settings

- Page width: 1200px
- Section spacing: 0
- Grid horizontal spacing: 8px
- Grid vertical spacing: 8px
- Button border radius: 2px
- Card style: Standard
- Badge position: Bottom left

## Third-Party Integrations

### Apps Installed

| App | Purpose | Notes |
|-----|---------|-------|
| **PageFly Page Builder** | Custom page layouts | Homepage uses PageFly |
| **Email Popups / Opt-in Pop-ups** | Email capture | Active |
| **Judge.me Reviews** | Product reviews | Active |

### PageFly Usage

The homepage (`templates/index.json`) primarily uses PageFly for content:
- Default Dawn sections are disabled
- `pagefly-home` section is the main content
- Custom layouts in `sections/pagefly-home.liquid` and `sections/pagefly-section.liquid`

## File Structure

```
legacy-dawn-theme/
├── assets/           # 85 files (CSS, JS)
│   ├── base.css      # Main stylesheet
│   ├── pagefly-*.css # PageFly styles
│   └── component-*.css # Component styles
├── config/
│   ├── settings_data.json  # Current configuration
│   └── settings_schema.json # Settings definitions
├── layout/
│   ├── theme.liquid         # Main layout
│   ├── theme.pagefly.liquid # PageFly layout
│   └── password.liquid      # Password page layout
├── locales/          # 40 language files
├── sections/         # 52 sections
│   ├── pagefly-home.liquid    # PageFly homepage
│   ├── pagefly-section.liquid # PageFly section
│   └── [standard Dawn sections]
├── snippets/         # 66 snippets
│   ├── pagefly-*.liquid  # PageFly snippets
│   └── [standard Dawn snippets]
└── templates/        # 21 templates
    └── index.json    # Homepage (uses PageFly)
```

## Current Homepage Structure

The homepage has these sections (most disabled):

1. **Image Banner** (disabled)
   - Heading: "Customopoly Board Games"
   - Subtext: "The most unique personalized gift"
   - CTA: "Shop Now" → Complete Game Package collection

2. **Rich Text** (disabled)
3. **Featured Collection** (disabled)
4. **Collage** (disabled)
5. **Video** (disabled)
6. **Multicolumn** (disabled)
7. **PageFly Home** (active) - Main content

## Header Configuration

- Logo position: Middle-left
- Logo width: 90px
- Menu: main-menu
- Menu type: Dropdown
- Sticky header: Disabled
- Line separator: Enabled

## Footer Configuration

- Newsletter signup: Enabled
- Social links: Facebook, Instagram
- Payment icons: Enabled
- Blocks:
  1. Quick links (footer menu)
  2. Info (footer menu)
  3. Contact info with phone number

## Announcement Bar

- Text: "We Ship Worldwide!"
- Color scheme: Inverse (dark background)

## Migration Considerations

### Features to Preserve
1. Brand colors and typography (Assistant font)
2. Social media links
3. Announcement bar messaging
4. Contact information in footer
5. Review system (Judge.me) - may need app reinstall
6. Email popup functionality - may need app reinstall

### Features to Rebuild
1. Homepage layout (currently PageFly) → Horizon sections
2. Product page customizations
3. Collection page layout

### Potential Improvements
1. Sticky header (was disabled)
2. Modern section designs from Horizon
3. Improved mobile experience
4. Better performance (Horizon's Web Components vs Dawn's approach)

## Notes

- PageFly content cannot be directly migrated - will need to recreate using Horizon's native sections
- Logo and other media assets are stored in Shopify's CDN, not in theme files
- Custom CSS may need review and adaptation for Horizon's CSS variable system
