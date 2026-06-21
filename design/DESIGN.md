---
name: Kinetic Bright
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#5a4136'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
  outline: '#8e7164'
  outline-variant: '#e3bfb1'
  surface-tint: '#a33e00'
  primary: '#a33e00'
  on-primary: '#ffffff'
  primary-container: '#ff6600'
  on-primary-container: '#561d00'
  inverse-primary: '#ffb596'
  secondary: '#5f5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e2dfde'
  on-secondary-container: '#636262'
  tertiary: '#5e5e5e'
  on-tertiary: '#ffffff'
  tertiary-container: '#979696'
  on-tertiary-container: '#2e2f2f'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbcd'
  primary-fixed-dim: '#ffb596'
  on-primary-fixed: '#360f00'
  on-primary-fixed-variant: '#7c2e00'
  secondary-fixed: '#e5e2e1'
  secondary-fixed-dim: '#c8c6c5'
  on-secondary-fixed: '#1c1b1b'
  on-secondary-fixed-variant: '#474746'
  tertiary-fixed: '#e4e2e2'
  tertiary-fixed-dim: '#c7c6c6'
  on-tertiary-fixed: '#1b1c1c'
  on-tertiary-fixed-variant: '#464747'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Space Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Space Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Space Grotesk
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
    letterSpacing: '0'
  body-md:
    fontFamily: Space Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
    letterSpacing: '0'
  label-sm:
    fontFamily: Space Grotesk
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1'
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 48px
  gutter: 20px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style
This design system shifts the high-energy athletic aesthetic into a high-clarity, light-mode environment. It targets active users who require immediate information density and visual motivation. The style is **Modern Corporate with a Kinetic Edge**, blending the precision of technical typography with the vibrance of performance sports. 

The UI should feel breathable, fast, and engineered. By utilizing heavy whitespace and crisp structural lines, the design system emphasizes movement and action without the visual weight of dark-themed interfaces.

## Colors
The palette is anchored by the signature brand orange, used strategically for high-intent actions and progress indicators. 

- **Surface:** The primary background is `#FFFFFF`, with `#F8F8F8` used for secondary containers and background sections to provide subtle contrast.
- **Brand Primary:** `#FF6600` is the energy source. It is used for primary buttons, active states, and critical data visualizations.
- **Typography:** Deep grays (`#1A1A1A`) ensure maximum legibility for body text, while a secondary gray (`#666666`) is reserved for meta-data and captions.
- **Accents:** Success, warning, and error states should utilize highly saturated tones to maintain the "Kinetic" energy.

## Typography
This design system uses **Space Grotesk** across all tiers to maintain a technical, futuristic, and athletic character. 

- **Display & Headlines:** Use tight letter-spacing and bold weights to evoke a sense of urgency and strength. 
- **Body Text:** Standard weights are used for readability, maintaining a slightly wider line height to balance the geometric nature of the typeface.
- **Labels:** Small labels use uppercase styling with increased letter spacing to emulate the "technical spec" look found in high-performance gear.

## Layout & Spacing
The layout follows a **Fluid Grid** model with high-density margins. 

- **Rhythm:** Use a 4px baseline grid. Components should generally use 16px (md) or 24px (lg) padding to maintain an airy feel.
- **Desktop:** 12-column grid with 20px gutters. Outer margins are generous (64px) to center-focus the content.
- **Mobile:** 4-column grid with 16px margins.
- **Logic:** Vertical rhythm is driven by the 4px unit, ensuring all components align to a consistent mathematical scale.

## Elevation & Depth
In this light-mode variant, depth is achieved through **Soft Ambient Shadows** and **Tonal Layering**.

- **Level 0 (Base):** `#FFFFFF` surface.
- **Level 1 (Cards):** `#FFFFFF` surface with a very soft, diffused shadow (0px 4px 20px rgba(0,0,0,0.04)) and a thin 1px border in `#EEEEEE`.
- **Level 2 (Dropdowns/Modals):** High-diffusion shadow (0px 10px 30px rgba(0,0,0,0.08)) to lift elements significantly off the base.
- **Interactive States:** When a card is hovered, the shadow should deepen slightly and the border color should shift toward the primary orange.

## Shapes
The shape language is consistently **Rounded**. This softens the technical edges of the Space Grotesk font and makes the UI feel approachable.

- **Standard Elements:** 0.5rem (8px) radius for buttons and small inputs.
- **Large Containers:** 1rem (16px) radius for cards and hero sections.
- **Pill Elements:** Use full rounding for tags, chips, and toggle switches to differentiate them from structural containers.

## Components
- **Buttons:** Primary buttons use a solid `#FF6600` background with white text. Secondary buttons use a transparent background with a `#1A1A1A` border and text. All buttons have a bold weight.
- **Cards:** White backgrounds with the Level 1 shadow. Headers within cards should use the secondary gray for sub-titles to maintain hierarchy.
- **Input Fields:** Use a `#F8F8F8` fill with a subtle bottom border. Upon focus, the border transitions to a 2px solid `#FF6600`.
- **Chips/Tags:** Small, pill-shaped elements with light gray backgrounds (`#EEEEEE`) and `#1A1A1A` text. Active chips utilize a light orange tint background with primary orange text.
- **Lists:** Clean dividers using 1px `#F0F0F0`. Icons in lists should be monochromatic (`#1A1A1A`) unless indicating a specific status.
- **Progress Bars:** Use a high-contrast track (`#EEEEEE`) with a `#FF6600` indicator to show movement and achievement.