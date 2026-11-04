# Design System & UI Specifications

**App:** MathQuest (Ages 4–10)  
**Target Platforms:** iOS & Android (Phones & Tablets)  
**Primary Font Family:** `Nunito` (Rounded, highly legible for young readers and numbers)

---

## 1. Color Palette & Semantic Tokens

All colors are extracted and standardized from the UI proposal to ensure high contrast, accessibility, and playful aesthetics.

### 1.1 Brand & Character Colors
| Token Name | Hex Code | Visual Sample | Usage |
| :--- | :--- | :--- | :--- |
| `primaryBlue` | `#1CB0F6` | 🟦 Sky Blue | Active indicators, selection states, progress bars |
| `primaryDarkBlue` | `#0288D1` | 🟦 Deep Cyan | Selected text, highlighted borders |
| `secondaryOrange` | `#FF9600` | 🟧 Star Gold | Mascot accents, stars, rewards, streaks |
| `accentPurple` | `#8B5CF6` | 🟪 Cosmic Purple | Multi-operation badges, XP labels |
| `backgroundLight` | `#F7F9FC` | ⬜ Soft Off-White | Scaffold background across all screens |
| `surfaceWhite` | `#FFFFFF` | ⬜ Pure White | Card containers, interactive buttons, sheets |

### 1.2 Mathematical Operation Accents (From Screens 3 & 6)
| Operation | Token Name | Hex Code | Usage |
| :--- | :--- | :--- | :--- |
| **Addition (+)** | `opAddition` | `#0EA5E9` | Light Blue background & icons |
| **Subtraction (-)** | `opSubtraction` | `#F43F5E` | Soft Rose/Coral background & icons |
| **Multiplication (×)** | `opMultiplication` | `#8B5CF6` | Soft Violet background & icons |
| **Division (÷)** | `opDivision` | `#F59E0B` | Soft Amber background & icons |

### 1.3 Feedback & Validation Colors
| Token Name | Hex Code | Usage |
| :--- | :--- | :--- |
| `successGreen` | `#00C853` | "Check Answer!" button, correct modals, accuracy chips |
| `successBg` | `#E8F5E9` | Background for success bottom sheet |
| `errorRed` | `#FF4B4B` | Mistake alerts, retry badges |
| `errorBg` | `#FFEBEE` | Background for mistake/hint sheet |

### 1.4 Neutral & Typography Tokens
| Token Name | Hex Code | Usage |
| :--- | :--- | :--- |
| `textPrimary` | `#1E293B` | Large math problems, headlines, titles |
| `textSecondary` | `#64748B` | Subheadings, section titles, timer countdown |
| `textMuted` | `#94A3B8` | Helper labels, inactive icons, question ratios |
| `borderLight` | `#E2E8F0` | Default card borders and button outlines |

---

## 2. Typography Scale

Use **`Nunito`** (from [Google Fonts](https://fonts.google.com/specimen/Nunito)) for its rounded terminals, which make reading numbers easy for young children.

| Style Name | Font Size | Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| `displayProblem` | 44 px | 900 (Black) | 52 px | Active math problem (`24 + 18 = ?`) |
| `displayStat` | 32 px | 800 (Bold) | 38 px | Large statistics numbers (`1,248`) |
| `titleLarge` | 24 px | 800 (Bold) | 30 px | Screen headers, "Quest Complete!" |
| `titleMedium` | 20 px | 700 (Bold) | 26 px | Section titles, card headers |
| `optionText` | 26 px | 700 (Bold) | 32 px | Numbers inside the 4 multiple-choice cards |
| `bodyMedium` | 16 px | 600 (Semi-Bold) | 22 px | Descriptive body copy, tips, hints |
| `buttonText` | 18 px | 800 (Bold) | 24 px | Action buttons ("Check Answer!", "Continue") |
| `caption` | 13 px | 600 (Semi-Bold) | 16 px | Badges, small metadata, timer tags |

---

## 3. Spacing, Radii & Elevation

### 3.1 Spacing (8pt Base Grid)
* `xs`: 4 px (Tight margins between dots)
* `sm`: 8 px (Pill padding, small gaps)
* `md`: 16 px (Default element spacing)
* `lg`: 24 px (Card padding, screen horizontal margin)
* `xl`: 32 px (Vertical section separation)

### 3.2 Border Radii
* **Pills / Chips:** `BorderRadius.circular(12)`
* **Buttons & Choice Cards:** `BorderRadius.circular(20)`
* **Main Surfaces / Problem Card:** `BorderRadius.circular(24)`
* **Bottom Sheets / Modals:** `BorderRadius.vertical(top: Radius.circular(32))`

### 3.3 Tactile Shadows & Elevation
Kids respond well to buttons that look "pressable".
* **Soft Card Shadow:**
  ```dart
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E293B).withOpacity(0.05),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ]
  ```
* **Pressable 3D Button Style:**
  Cards and primary buttons feature a 2px colored bottom edge to feel tactile and playful.

---

## 4. Responsive Layout & Tablet Strategy

Educational apps are heavily used on iPads and Android tablets. We use a **Constrained Max-Width Center Architecture**:

```
 ┌─────────────────────────────────────────────────────────┐
 │ Tablet / iPad Screen                                    │
 │                                                         │
 │              ┌───────────────────────────┐              │
 │              │ Constrained Viewport      │              │
 │              │ (Max Width: 520px)        │              │
 │              │                           │              │
 │              │  • Problem Card           │              │
 │              │  • Counting Aids          │              │
 │              │  • Answer Options Grid    │              │
 │              │  • Action CTA             │              │
 │              │                           │              │
 │              └───────────────────────────┘              │
 └─────────────────────────────────────────────────────────┘
```

* **Phone Rule:** Width takes 100% of viewport with `padding: EdgeInsets.symmetric(horizontal: 20)`.
* **Tablet Rule:** Content is wrapped in a `Center` widget with `ConstrainedBox(constraints: BoxConstraints(maxWidth: 520))` to prevent options and cards from stretching awkwardly.

---

## 5. Ready-to-Use Flutter Theme Implementation

Save this file as `lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color primaryBlue = Color(0xFF1CB0F6);
  static const Color primaryDarkBlue = Color(0xFF0288D1);
  static const Color secondaryOrange = Color(0xFFFF9600);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Operations
  static const Color opAddition = Color(0xFF0EA5E9);
  static const Color opSubtraction = Color(0xFFF43F5E);
  static const Color opMultiplication = Color(0xFF8B5CF6);
  static const Color opDivision = Color(0xFFF59E0B);

  // Feedback
  static const Color successGreen = Color(0xFF00C853);
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color errorRed = Color(0xFFFF4B4B);
  static const Color errorBg = Color(0xFFFFEBEE);

  // Neutrals
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
}

class AppTypography {
  static const String fontFamily = 'Nunito';

  static const TextStyle displayProblem = TextStyle(
    fontFamily: fontFamily,
    fontSize: 44,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayStat = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle optionText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.secondaryOrange,
        surface: AppColors.surfaceWhite,
        error: AppColors.errorRed,
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successGreen,
          foregroundColor: Colors.white,
          textStyle: AppTypography.buttonText,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
```

---

## 6. Reusable Core Component Blueprints

### 6.1 Responsive Wrapper Widget (`responsive_container.dart`)
```dart
import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 520.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: child,
        ),
      ),
    );
  }
}
```

### 6.2 Option Card Widget Specification
* **Dimensions:** Aspect ratio of `2.2` in a 2-column grid.
* **Unselected State:** `surfaceWhite` fill, `borderLight` border (1.5px), `textPrimary` font.
* **Selected State:** Light blue fill (`#E1F5FE`), `primaryBlue` border (2.5px), `primaryDarkBlue` font.
* **Animation:** Scale / Border transition duration of `150ms easeInOut`.
