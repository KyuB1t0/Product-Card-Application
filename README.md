# product_card_application

# Product Manager Assessment - Flutter

## Overview
This Flutter app implements the technical assessment: a product management UI with 4 pages (Home, Electronics, Clothing, Food). Each product card shows name, price (currency), category badge and stock status, and a conditional 3-dot menu whose options depend on product data.

## Features
- Home page shows ALL products mixed, sorted alphabetically.
- Category pages show only relevant products.
- Responsive grid (2 cols on small, 3+ on larger screens).
- Category badges: blue (electronics), purple (clothing), green (food).
- Stock indicator colors: green (inStock), yellow (lowStock), red (outOfStock).
- Electronics show warranty badge. Clothing shows available sizes. Food shows "Expires in X days" when < 30 days.
- Dropdown menu options are shown according to the exact conditional rules in the assessment.
- Apply/Remove Discount toggles `hasDiscount` state and is persisted while app runs (via Provider).
- Simple actions implemented for demonstration (snackbars, dialogs).

## Packages used
- `provider` — simple state management to manage product state and keep example small and clear.
- `intl` — currency formatting.

## How to run
1. Create a new Flutter project or copy these files into an existing project.
2. Ensure `pubspec.yaml` includes the dependencies and `assets/test_data.json` (as provided).
3. Run:
   ```bash
   flutter pub get
   flutter run