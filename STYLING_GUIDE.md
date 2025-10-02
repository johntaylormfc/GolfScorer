# Styling Guide - The Legs Open Golf App

## Overview
This document explains the CSS styling system used in the golf app and how to customize colors, fonts, and layouts.

## File Structure
- **styles.css** - Contains all CSS styling, organized by component
- **app.js** - Uses CSS classes defined in styles.css

## Color Theme

All colors are defined as CSS variables in `:root` for easy customization:

### Primary Colors
```css
--color-primary: #047857;         /* Main green */
--color-primary-light: #10b981;   /* Light green */
--color-primary-dark: #065f46;    /* Dark green */
```

### Winner Banners
```css
--color-medal-from: #fbbf24;      /* Medal winner gradient start (yellow) */
--color-medal-to: #f59e0b;        /* Medal winner gradient end (orange) */
--color-stableford-from: #10b981; /* Stableford winner gradient start (green) */
--color-stableford-to: #059669;   /* Stableford winner gradient end (dark green) */
```

### Score Colors (based on par)
```css
--color-eagle: #fef3c7;           /* Eagle or better (yellow) */
--color-birdie: #dcfce7;          /* Birdie (light green) */
--color-par: #ffffff;             /* Par (white) */
--color-bogey: #fed7aa;           /* Bogey (light orange) */
--color-double-bogey: #fecaca;    /* Double bogey or worse (light red) */
```

### Leaderboard Colors
```css
--color-leaderboard-header: #047857;    /* Table header background */
--color-leaderboard-row-hover: #f9fafb; /* Row hover background */
--color-leaderboard-expanded: #f3f4f6;  /* Expanded row background */
--color-leaderboard-border: #e5e7eb;    /* Border color */
```

### Scorecard Colors
```css
--color-scorecard-hole-header: #111827;   /* Hole numbers color */
--color-scorecard-par-bg: #e5e7eb;        /* Par row background */
--color-scorecard-score-bg: #dbeafe;      /* Score label background */
--color-scorecard-subtotal-bg: #d1fae5;   /* Subtotal column background */
--color-scorecard-total-bg: #047857;      /* Total badge background */
--color-scorecard-total-text: #ffffff;    /* Total badge text */
```

## How to Customize Colors

### Example 1: Change the primary green to blue
```css
:root {
  --color-primary: #1e40af;         /* Change to blue */
  --color-primary-light: #3b82f6;   /* Light blue */
  --color-primary-dark: #1e3a8a;    /* Dark blue */
}
```

### Example 2: Change the medal winner banner color
```css
:root {
  --color-medal-from: #dc2626;  /* Red gradient start */
  --color-medal-to: #991b1b;    /* Red gradient end */
}
```

### Example 3: Adjust score colors
```css
:root {
  --color-birdie: #86efac;      /* Brighter green for birdie */
  --color-bogey: #fbbf24;       /* Yellow for bogey */
}
```

## CSS Classes

### Leaderboard Components

#### Winner Banners
- `.winner-medal` - Medal play winner banner
- `.winner-stableford` - Stableford winner banner

#### Table Styling
- `.leaderboard-header` - Table header row
- `.leaderboard-row` - Individual player rows
- `.leaderboard-row:hover` - Row hover effect
- `.leaderboard-expanded-row` - Expanded scorecard row
- `.accordion-icon` - Expand/collapse arrow icon

### Scorecard Components

#### Container and Layout
- `.scorecard-container` - Main container with padding
- `.scorecard-title` - "Scorecard" heading
- `.scorecard-grid` - Grid layout (11 columns)
- `.scorecard-section` - Each 9-hole section

#### Row Labels
- `.scorecard-label` - Generic label (e.g., "Hole")
- `.scorecard-hole-number` - Hole numbers (1-18)
- `.scorecard-subtotal-header` - "Out" / "In" headers

#### Par Row
- `.scorecard-par-label` - "Par" label
- `.scorecard-par-cell` - Individual par values
- `.scorecard-par-subtotal` - Front/back 9 par totals

#### Score Row
- `.scorecard-score-label` - "Score" label
- `.scorecard-score-cell` - Individual score cells
- `.scorecard-score-subtotal` - Front/back 9 score totals

#### Score Colors (applied automatically)
- `.score-eagle` - Eagle or better
- `.score-birdie` - Birdie
- `.score-par` - Par
- `.score-bogey` - Bogey
- `.score-double-bogey` - Double bogey or worse

#### Total Display
- `.scorecard-total` - Total container
- `.scorecard-total-badge` - Total score badge

## Customization Examples

### Change Leaderboard Header Color
```css
.leaderboard-header {
  background-color: #1e40af; /* Blue instead of green */
}
```

### Adjust Scorecard Grid Spacing
```css
.scorecard-grid {
  gap: 0.5rem; /* Increase gap from 0.25rem */
}
```

### Change Total Badge Styling
```css
.scorecard-total-badge {
  background-color: #dc2626; /* Red background */
  border-radius: 0.5rem;     /* More rounded corners */
  font-size: 1.125rem;       /* Larger text */
}
```

### Modify Score Cell Font Size
```css
.scorecard-score-cell {
  font-size: 1rem;           /* Larger font */
  font-weight: 600;          /* Less bold */
}
```

## Typography

Fonts are defined at the top of styles.css:

```css
body {
  font-family: 'Open Sans', sans-serif;
}

h1, h2, h3, h4, h5, h6 {
  font-family: 'Merriweather', serif;
}
```

### Change Fonts
To use different fonts, replace the import and font families:

```css
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap');

body {
  font-family: 'Roboto', sans-serif;
}
```

## Effects and Utilities

- `.classic-shadow` - Standard box shadow
- `.hover-lift` - Lift effect on hover
- `.hero-pattern` - Green gradient background pattern
- `.trophy-gold` - Gold gradient for trophies

## Best Practices

1. **Use CSS Variables** - Always modify colors in `:root` first
2. **Maintain Consistency** - Keep similar components styled similarly
3. **Test Contrast** - Ensure text is readable on all backgrounds
4. **Mobile Responsive** - The grid system automatically adapts to screen size
5. **Browser Testing** - Test changes in multiple browsers

## Common Customizations

### Make the app darker (dark mode concept)
```css
:root {
  --color-primary: #065f46;
  --color-leaderboard-header: #1f2937;
  --color-leaderboard-expanded: #374151;
  --color-scorecard-par-bg: #4b5563;
  --color-scorecard-total-bg: #1f2937;
}
```

### Increase font sizes for better readability
```css
.scorecard-grid {
  font-size: 1rem; /* Default is 0.875rem */
}

.scorecard-label {
  font-size: 0.875rem; /* Default is 0.75rem */
}
```

### Add animations
```css
.leaderboard-row {
  transition: all 0.3s ease;
}

.leaderboard-row:hover {
  transform: translateX(4px);
}
```

## Support

For questions or custom styling needs, refer to the Tailwind CSS documentation for additional utility classes that can be used alongside these custom styles.
