# Image & Asset Specifications for Horizon Theme

> **For:** Dani Kate Designs
> **Theme:** Shopify Horizon 3.3.0
> **Last Updated:** February 2026

This guide provides all image dimensions, aspect ratios, and best practices for preparing visual assets for the Horizon theme. Unlike the older Dawn theme, Horizon uses modern responsive image techniques with more flexibility.

---

## Quick Reference Card

| Asset Type | Recommended Size | Aspect Ratio | Format |
|------------|------------------|--------------|--------|
| **Logo** | 500-1000px wide | Your design | PNG (transparent) or SVG |
| **Hero Banner** | 3840 × 2160px | 16:9 | JPG/WebP |
| **Hero (Mobile)** | 1200 × 1600px | 3:4 | JPG/WebP |
| **Product Photos** | 2000 × 2000px | 1:1 (square) | JPG/WebP |
| **Collection Image** | 1600 × 900px | 16:9 | JPG/WebP |
| **Slideshow Slides** | 3840 × 2160px | 16:9 | JPG/WebP |
| **Favicon** | 32 × 32px | 1:1 | PNG |

---

## Detailed Specifications

### 1. Logo

**Recommended Dimensions:**
- Width: **500-1000px** (Shopify will resize)
- Height: Auto (maintain your aspect ratio)

**Display Sizes:**
- Desktop header: **36px tall** (adjustable 12-100px)
- Mobile header: **28px tall** (adjustable 12-100px)
- Width auto-calculated from your logo's aspect ratio

**File Format:**
- **PNG** with transparent background (preferred)
- **SVG** for unlimited scaling (if your logo supports it)

**Best Practice:**
- Upload at 2-3× the display size for retina screens
- If logo is 36px tall on desktop, upload at least 108px tall
- Keep file size under 100KB

---

### 2. Hero/Banner Images

The hero section is the most prominent visual element. Horizon handles desktop and mobile differently.

#### Desktop Hero

| Spec | Value |
|------|-------|
| **Optimal Width** | 3840px |
| **Minimum Width** | 1920px |
| **Aspect Ratio** | 16:9 recommended (flexible) |
| **Optimal Dimensions** | 3840 × 2160px |

**Served Sizes:** The theme automatically generates:
- 832px, 1200px, 1600px, 1920px, 2560px, 3840px

#### Mobile Hero

| Spec | Value |
|------|-------|
| **Optimal Width** | 1200px |
| **Aspect Ratio** | 3:4 or 4:5 (taller for mobile) |
| **Optimal Dimensions** | 1200 × 1600px |

**Served Sizes:** 416px, 600px, 800px, 1200px, 1600px

#### Mobile Cropping Behavior

**Important:** If you don't provide a separate mobile image:
- Desktop image will be **center-cropped** to fit mobile viewport
- Top and bottom edges may be cut off
- Side edges are preserved

**Safe Zone for Single Image (No Mobile Version):**
```
┌─────────────────────────────────────┐
│         CROP ZONE (top)             │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │     ★ SAFE ZONE ★             │  │
│  │   (Keep important content     │  │
│  │    in center 60% height)      │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│         CROP ZONE (bottom)          │
└─────────────────────────────────────┘
```

**Recommendation:** Always create separate desktop and mobile hero images for best results. The Shopify editor lets you upload different images for each.

---

### 3. Product Photos

Product images are the most important for e-commerce conversion.

#### Primary Product Image

| Spec | Value |
|------|-------|
| **Optimal Size** | 2000 × 2000px |
| **Minimum Size** | 1200 × 1200px |
| **Aspect Ratio** | 1:1 (square) recommended |
| **Max File Size** | 20MB (Shopify limit) |

#### Alternate Aspect Ratios

The theme supports multiple aspect ratios (selectable in editor):

| Ratio | Dimensions | Best For |
|-------|------------|----------|
| **Square (1:1)** | 2000 × 2000px | Standard products, board games |
| **Portrait (4:5)** | 1600 × 2000px | Tall items, lifestyle shots |
| **Landscape (16:9)** | 2000 × 1125px | Wide products, game boards laid flat |
| **Adapt** | Any | Uses your image's natural ratio |

#### Product Image Best Practices

1. **Consistency is key** - Use the same aspect ratio for all products
2. **White/neutral background** - For clean product grids
3. **Multiple angles** - 3-5 images per product recommended
4. **Zoom capability** - High resolution enables zoom feature

#### Product Gallery Behavior

- First image loads immediately (eager)
- Additional images load as needed (lazy)
- Hover shows second image (if available)
- Carousel displays up to 5 images

---

### 4. Collection Images

Collection images appear on collection pages and in collection lists.

| Spec | Value |
|------|-------|
| **Optimal Width** | 1600px |
| **Aspect Ratio** | Adapts to setting (16:9, 4:5, 1:1, or native) |
| **Recommended** | 1600 × 900px (16:9) |

**Display Options:**
- Landscape: 16:9 ratio
- Portrait: 4:5 ratio
- Square: 1:1 ratio
- Adapt: Uses your uploaded image's ratio

**Note:** Collection images use `object-fit: cover` - edges may be cropped to fit the container. Keep important elements centered.

---

### 5. Slideshow/Carousel Images

For homepage slideshows or promotional carousels.

| Spec | Value |
|------|-------|
| **Optimal Width** | 3840px |
| **Minimum Width** | 1920px |
| **Aspect Ratio** | 16:9 or match hero |
| **Optimal Dimensions** | 3840 × 2160px |

**Height Options Available in Editor:**
- Auto (content-driven)
- Small
- Medium
- Large (nearly full-screen)

---

### 6. Media-with-Content Sections

These sections combine an image with text content side-by-side.

| Spec | Value |
|------|-------|
| **Optimal Width** | 2560px |
| **Aspect Ratio** | Flexible |

**Desktop:** Image appears beside content (50% width typically)
**Mobile:** Image stacks above content (100% width)

**Height Options:**
| Setting | Desktop | Mobile |
|---------|---------|--------|
| Small | 50vh | 30vh |
| Medium | 60vh | 50vh |
| Large | 80vh | 70vh |
| Full | 100vh | 100vh |

---

### 7. Favicon & Social Sharing

#### Favicon
| Spec | Value |
|------|-------|
| **Size** | 32 × 32px |
| **Format** | PNG |

#### Social Sharing Image (og:image)
| Spec | Value |
|------|-------|
| **Size** | 1200 × 630px |
| **Aspect Ratio** | 1.91:1 |
| **Format** | JPG/PNG |

This appears when your site is shared on Facebook, LinkedIn, etc.

---

## Horizon vs Dawn: Key Differences

| Feature | Dawn (Old Theme) | Horizon (New Theme) |
|---------|------------------|---------------------|
| **Max Image Width** | 1920px | 3840px (4K support) |
| **Responsive Method** | Fixed breakpoints | Container queries + viewport |
| **Mobile Images** | Same as desktop (cropped) | Separate mobile option |
| **Aspect Ratios** | Limited options | More flexible (4 presets + adapt) |
| **Lazy Loading** | Basic | Advanced with priority hints |
| **Image Format** | JPG/PNG | JPG/PNG/WebP (auto-converted) |

**Key Improvement:** Horizon supports 4K displays and has better mobile handling. Your existing Dawn images will work but may appear less sharp on high-res displays.

---

## File Format Recommendations

### Best Formats by Use Case

| Content Type | Recommended | Alternative |
|--------------|-------------|-------------|
| **Photos** | WebP | JPG (90% quality) |
| **Graphics with transparency** | PNG | WebP |
| **Logos** | SVG | PNG (transparent) |
| **Icons** | SVG | PNG |

### Shopify Auto-Conversion
Shopify automatically converts images to WebP format for browsers that support it. You can upload JPG/PNG and Shopify handles optimization.

### File Size Guidelines

| Image Type | Target Size | Max Size |
|------------|-------------|----------|
| Hero/Banner | 200-500KB | 1MB |
| Product Photos | 100-300KB | 500KB |
| Collection Images | 100-200KB | 500KB |
| Logo | 20-50KB | 100KB |

**Tip:** Use TinyPNG or Squoosh to compress images before upload.

---

## Color & Brand Consistency

### Your Brand Colors (Configured in Theme)

| Element | Color | Hex |
|---------|-------|-----|
| Primary Text | Dark Gray | `#121212` |
| Blue Accent | Blue | `#334fb4` |
| Background | White | `#ffffff` |
| Secondary BG | Light Gray | `#f3f3f3` |
| Button Hover | Blue | `#334fb4` |

### Image Background Recommendations

- **Product photos:** White (`#ffffff`) or light gray (`#f3f3f3`)
- **Lifestyle shots:** Natural settings that complement brand colors
- **Hero banners:** Can use brand colors as overlays

---

## Checklist for Image Preparation

### Before You Start
- [ ] Decide on consistent aspect ratio for products (1:1 recommended)
- [ ] Plan hero images for both desktop AND mobile
- [ ] Gather all product photos in highest resolution available

### For Each Product
- [ ] Main image: 2000 × 2000px minimum
- [ ] 3-5 additional angles
- [ ] Consistent background across products
- [ ] File size under 500KB each

### For Homepage
- [ ] Hero desktop: 3840 × 2160px
- [ ] Hero mobile: 1200 × 1600px (or separate image)
- [ ] Consider safe zones for text overlay areas

### For Collections
- [ ] Collection image: 1600 × 900px (or match your chosen ratio)
- [ ] Keep subject centered (edges may crop)

### Final Steps
- [ ] Compress all images (TinyPNG, Squoosh)
- [ ] Use descriptive file names (e.g., `customopoly-photo-package-front.jpg`)
- [ ] Test on mobile device after uploading

---

## Shopify Theme Editor: What You Can Adjust

These settings are adjustable in the Shopify theme editor (no code needed):

### Image Settings
- Aspect ratio selection (square, portrait, landscape, adapt)
- Image position/alignment
- Mobile-specific images (where supported)
- Lazy loading behavior

### Cannot Change Without Code
- Maximum image widths served
- Breakpoint at 750px (mobile/desktop threshold)
- Object-fit behavior (cover vs contain)

---

## Quick Tips for Custom Board Game Photography

Since Dani Kate Designs sells custom board games:

1. **Flat Lay Shots** - 16:9 landscape works great for showing the full board
2. **Box Shots** - Square (1:1) for consistent product grid appearance
3. **Detail Shots** - Any ratio, show custom elements close up
4. **Lifestyle/Family Shots** - Portrait (4:5) or landscape (16:9)
5. **Component Shots** - Square for game pieces, money, cards

**Recommended Product Image Set:**
1. Box front (square)
2. Board flat lay (can use adapt ratio)
3. Box with board
4. Detail of personalization
5. Lifestyle shot (people playing)

---

## Need Help?

- **Shopify Help Docs:** https://help.shopify.com/en/manual/online-store/images
- **Image Compression:** https://tinypng.com or https://squoosh.app
- **Free Stock Photos:** https://unsplash.com (for lifestyle backgrounds)

---

*This guide was created based on analysis of the Horizon 3.3.0 theme codebase.*
