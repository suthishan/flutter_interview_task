# CRM Pocket Feed — Japfa Comfeed India
### Flutter Developer Interview Task · Mid-Level (2–4 Years)

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure)
4. [Setup Instructions](#setup-instructions)
5. [Implemented Screens](#implemented-screens)
6. [State Management Rationale](#state-management-rationale)
7. [Design System](#design-system)
8. [Figma Design Reference](#figma-design-reference)
9. [Known Limitations & Deviations](#known-limitations--deviations)
10. [Screen Recording](#screen-recording)
11. [Submission Details](#submission-details)

---

## Project Overview

**CRM Pocket Feed** is a field sales management application built for Japfa Comfeed India's Sales Officers who operate in rural environments on Android smartphones. This submission implements all **4 mandatory tasks** plus the **bonus Task 5 (Manager Lead Dashboard)** as specified in the interview brief.

The application covers the complete field sales workflow:

- Daily visit planning and scheduling
- GPS-based geofenced check-in at customer locations
- Lead creation with dynamic segment-specific forms
- KYC document upload with file validation
- Manager dashboard with lead filtering and remark timelines

---

## Tech Stack

| Area | Choice | Notes |
|---|---|---|
| Framework | Flutter (stable channel) | Dart null-safe throughout |
| Language | Dart 3.x (null-safe) | No `dynamic` types in production code |
| State Management | **Riverpod 2.x** (`flutter_riverpod`) | `StateNotifierProvider`, `Provider`, `StateProvider` |
| Navigation | **GoRouter 17.x** | Named routes, `extra` for model passing |
| UI Baseline | **Material Design 3** | `useMaterial3: true` in `ThemeData` |
| Mock Data | Local Dart models | No Firebase, no REST calls |
| Maps (Task 2) | Placeholder widget | API key not available — documented below |
| File Pick (Task 4) | `file_picker` | Real package usage, actual file selection |
| Date Formatting | `intl` | Centralised via `AppDateUtils` |

---

## Project Structure

```
lib/
├── core/
│   ├── constant/
│   │   └── app_constant.dart         # Layout, geofence, file upload constants
│   ├── mock/
│   │   ├── visit_mock_data.dart      # 9 visits across 3 dates
│   │   └── dashboard_mock_data.dart  # 10 leads, 3 officers, remarks timeline
│   ├── models/
│   │   ├── enums.dart                # All enums (VisitStatus, FeedSegment, etc.)
│   │   ├── visit_model.dart
│   │   ├── lead_model.dart
│   │   ├── dashboard_lead_model.dart
│   │   ├── remark_model.dart
│   │   ├── kyc_model.dart
│   │   └── check_in_model.dart       # CheckInConstants (geofence radius)
│   ├── theme/
│   │   └── app_theme.dart            # All color tokens, typography, ThemeData
│   └── utils/
│       └── date_utils.dart           # Centralised date/time formatting
│
├── features/
│   ├── visit_plan/                   # Task 1
│   │   ├── screen/
│   │   │   ├── visit_plan_screen.dart
│   │   │   ├── visit_detail_screen.dart
│   │   │   └── add_visit_screen.dart
│   │   ├── providers/
│   │   │   └── visit_provider.dart
│   │   └── widgets/
│   │       ├── visit_card.dart
│   │       ├── date_selector.dart
│   │       ├── summary_chip.dart
│   │       ├── segment_badge.dart
│   │       └── notification_badge.dart
│   │
│   ├── check_in/                     # Task 2
│   │   ├── screen/
│   │   │   └── check_in_screen.dart
│   │   ├── providers/
│   │   │   └── check_in_providers.dart
│   │   └── widgets/
│   │       ├── check_in_header.dart
│   │       ├── check_in_button.dart
│   │       ├── distance_card.dart
│   │       ├── map_placeholder.dart
│   │       ├── out_of_range_banner.dart
│   │       ├── gps_error_view.dart
│   │       ├── cancellation_dialog.dart
│   │       └── state_toggle.dart
│   │
│   ├── lead/                         # Task 3
│   │   ├── screen/
│   │   │   └── lead_form_screen.dart
│   │   ├── providers/
│   │   │   └── lead_provider.dart
│   │   └── widgets/
│   │       ├── lead_classification_selector.dart
│   │       ├── segment_field_widget.dart
│   │       └── custom_text_field.dart
│   │
│   ├── kyc/                          # Task 4
│   │   ├── screen/
│   │   │   ├── kyc_screen.dart
│   │   │   └── submission_status_screen.dart
│   │   ├── providers/
│   │   │   └── kyc_provider.dart
│   │   └── widgets/
│   │       ├── customer_header.dart
│   │       ├── mandatory_counter.dart
│   │       ├── submit_bar.dart
│   │       ├── pulsing_status_icon.dart
│   │       ├── reference_card.dart
│   │       ├── step_card.dart
│   │       └── ref_row.dart
│   │
│   └── dashboard/                    # Task 5 (Bonus)
│       ├── screen/
│       │   ├── dashboard_screen.dart
│       │   └── dashboard_lead_detail_screen.dart
│       ├── providers/
│       │   └── dashboard_providers.dart
│       └── widgets/
│           ├── dashboard_header.dart
│           ├── dashboard_lead_card.dart
│           ├── filter_bar.dart
│           ├── lead_summary_chip.dart
│           └── timeline_tile.dart
│
├── shared/
│   └── widgets/
│       ├── status_chip.dart          # Reusable — evaluator checks this explicitly
│       ├── section_header.dart       # Reusable — used across all forms
│       ├── upload_tile.dart          # Reusable — 4 states (Task 4)
│       ├── lead_classification_badge.dart  # Reusable — Task 3 & Task 5
│       ├── empty_state_widget.dart   # Reusable — Task 1 & Task 5
│       └── shimmer_loading.dart      # Skeleton loading for Task 1
│
├── router/
│   └── app_router.dart               # Named GoRouter routes
│
└── main.dart                         # ProviderScope → MaterialApp.router
```

---

## Setup Instructions

### Prerequisites

- Flutter SDK: **stable channel** (3.x or later)
- Dart SDK: **3.x** (null-safe)
- Android Studio / VS Code with Flutter plugin
- An Android emulator or physical device (Android 6.0+)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/suthishan/flutter_interview_task.git
cd flutter_interview_task

# 2. Checkout the submission branch
git checkout <your-branch-name>

# 3. Install dependencies
flutter pub get

# 4. Run static analysis (must pass with zero errors/warnings)
flutter analyze

# 5. Run the app
flutter run
```

### Android Setup

No additional configuration is required for Android. The app runs entirely on mock data with no API keys needed.

### iOS Setup

```bash
cd ios && pod install && cd ..
flutter run
```

> **Note:** `file_picker` requires iOS 11+ and the following entry in `Info.plist` if testing on a real iOS device:
> ```xml
> <key>NSPhotoLibraryUsageDescription</key>
> <string>Required to select documents for KYC upload.</string>
> ```

---

## Implemented Screens

### Task 1 — Daily Visit Plan Screen ✅

**Key implementation decisions:**

- `DateSelector` uses a `ScrollController` disposed in `State.dispose()` — no memory leak. The controller auto-scrolls to centre today's date using `WidgetsBinding.addPostFrameCallback`.
- Visit filtering is fully reactive: `visitListProvider` re-derives whenever `selectedDateProvider` changes — no manual `setState`.
- A 3-second shimmer skeleton (`ShimmerVisitList`) simulates a loading state on first render, then transitions via `AnimatedSwitcher`.
- `StatusChip` and `SegmentBadge` are extracted to `shared/widgets/` and `visit_plan/widgets/` respectively as required.

**Mock data:** 9 visits spread across 3 dates (today, yesterday, day-after-tomorrow). Tomorrow has zero visits — triggers the `EmptyStateWidget`.

---

### Task 2 — Geo-fenced Check-In Screen ✅

**Key implementation decisions:**

- The GPS state simulator (`StateToggle`) uses a `SegmentedButton` at the bottom of the screen, allowing the evaluator to switch between `withinRange`, `outOfRange`, and `gpsUnavailable` states.
- `GpsErrorView` is a plain widget (not a `Scaffold`) placed inside an `AnimatedSwitcher`. This prevents it from being pushed onto the navigation stack — the "Back to Check-In" button resets `checkInStateProvider` to `withinRange` rather than calling `Navigator.pop()`.
- `CancellationDialog` is fully custom — it does not use the raw `AlertDialog` default. It includes 2 predefined `CancelReason` options plus an "Other" free-text field with `AnimatedCrossFade`.
- All check-in logic (distance, canCheckIn) is derived via Riverpod `Provider` — no `setState` for business logic.

**Google Maps:** API key is not available for this submission. A styled `MapPlaceholder` widget is rendered instead, featuring a pseudo street-grid `CustomPaint`, a geofence circle overlay, a customer pin, a simulated user position marker, and coordinate text. This is documented in accordance with the task spec.

**Mock distances:** `withinRange` → 45 m | `outOfRange` → 320 m | `gpsUnavailable` → N/A

---

### Task 3 — Lead Creation Form ✅

**Key implementation decisions:**

- `LeadClassificationSelector` renders HOT/WARM/COLD as full `AnimatedContainer` cards with distinct background colors, icons, and descriptions — not a `DropdownButton` or plain radio list.
- Segment field sets (Poultry / Aqua / Cattle / Pig) are wrapped in `AnimatedSwitcher` with a combined `FadeTransition + SizeTransition` for smooth animated transitions on segment change.
- `leadFormProvider` is `autoDispose` — the form resets automatically when navigating away.
- `isValid` is a computed getter on `LeadFormState` that checks all mandatory fields including segment-specific keys. The submit button's `onPressed` is conditionally `null` (truly un-tappable) when invalid — not just visually grey.
- `LeadClassificationBadge` is in `shared/widgets/` and reused in Task 5.

---

### Task 4 — KYC Document Upload Screen ✅

**Key implementation decisions:**

- `UploadTile` (in `shared/widgets/`) is a state-machine widget with 4 visually distinct states: `empty` (dashed border via `CustomPaint`), `loading` (animated `LinearProgressIndicator`), `uploaded` (success green border, file type icon, remove button), and `error` (red border, error message, retry).
- `file_picker` is used directly — no fake `setState(() => uploaded = true)`. The `KycNotifier._pickFile()` helper validates file size (max 5 MB) and extension (`jpg`, `jpeg`, `png`, `pdf`) before transitioning state.
- A debug `IconButton` in the `AppBar` simulates an upload error on the Aadhaar tile — evaluators can trigger the error state without needing an oversized file.
- `MandatoryCounter` renders a live `LinearProgressIndicator` and `'X of 3 mandatory documents uploaded'` text. The submit button is disabled (`onPressed: null`) until all 3 mandatory documents are uploaded.
- `SubmissionStatusScreen` features staggered entrance animations (`AnimationController` with `Interval` curves) and a pulsing status icon (`PulsingStatusIcon`).

---

### Task 5 — Manager Lead Dashboard (Bonus) ✅

**Key implementation decisions:**

- `DashboardState.filteredLeads` implements a priority queue: HOT leads always sort first, then WARM, then COLD, newest-first within each group. This is enforced in the `Provider` layer, not the UI.
- `DashboardFilters` supports multiple simultaneous active filters (classification chips OR-combined, date filter AND-combined). The `AnimatedSwitcher` in `DashboardScreen` plays a `FadeTransition + SlideTransition` whenever the filter key hash changes.
- `TimelineTile` uses a custom `IntrinsicHeight + Row` layout with a gradient connector line and role-colored avatars (Manager → `AppTheme.primary`, Sales Officer → `AppTheme.secondary`).
- Adding a remark via `DashboardNotifier.addRemark()` updates the timeline immediately in local state — no screen reload, no API call. A "Sales Officer Notified" `SnackBar` confirms submission.
- `LeadClassificationBadge` is reused from `shared/widgets/` — not reimplemented.

---

## State Management Rationale

**Choice: Riverpod 2.x (`flutter_riverpod`)**

Riverpod was chosen over Provider for the following reasons:

1. **Compile-time safety** — Providers are globally scoped and type-checked at compile time. There are no `context.read<T>()` calls that can throw at runtime from the wrong widget tree position.

2. **No `BuildContext` dependency for providers** — Providers can be read and combined outside the widget tree, which keeps business logic in `StateNotifier` classes completely decoupled from Flutter widgets.

3. **`autoDispose` scope control** — `leadFormProvider` and `kycProvider` are `autoDispose`, ensuring form state resets when navigating away. `dashboardProvider` is not `autoDispose`, preserving filter state across navigation within the session.

4. **Derived state with `Provider`** — `distanceProvider`, `canCheckInProvider`, `filteredLeadsProvider`, and `visitSummaryProvider` are all derived `Provider` instances. They recompute reactively whenever their watched dependencies change, eliminating manual synchronisation code.

5. **`StateNotifier` for complex mutations** — `DashboardNotifier`, `LeadFormNotifier`, and `KycNotifier` encapsulate all business logic. Widgets only call named methods (`addRemark`, `uploadAadhaar`, `toggleClassification`) — no raw state mutation from the UI layer.

**`setState` policy:** `setState` is used only for ephemeral, widget-local UI state — specifically `_submitAttempted` (inline error visibility) in `LeadFormScreen`, `_charCount` (character counter) in `_AddRemarkSectionState`, and `_isSubmitting` in dialog/form widgets. All business state lives in providers.

---

## Design System

All colors, typography, and spacing are defined in `lib/core/theme/app_theme.dart`. No hardcoded hex values or inline `TextStyle(fontSize: ...)` exist in any widget.

### Color Tokens

| Token | Value | Usage |
|---|---|---|
| `primary` | `#1A3C6E` | AppBar, CTAs, active nav |
| `secondary` | `#E87722` | Accent, badges, FAB |
| `error` | `#C62828` | Validation errors, cancellation |
| `success` | `#2E7D32` | Completed states, uploads |
| `warning` | `#F9A825` | Pending states, GPS unavailable |
| `leadHot` | `#B71C1C` | HOT lead classification |
| `leadWarm` | `#E65100` | WARM lead classification |
| `leadCold` | `#1565C0` | COLD lead classification |
| `segmentPoultry` | `#6A1B9A` | Poultry segment badge |
| `segmentAqua` | `#0277BD` | Aqua segment badge |
| `segmentCattle` | `#558B2F` | Cattle segment badge |
| `segmentPig` | `#AD1457` | Pig segment badge |

### Reusable Shared Widgets

| Widget | Location | Used In |
|---|---|---|
| `StatusChip` | `shared/widgets/` | Task 1, Task 2 |
| `SectionHeader` | `shared/widgets/` | Task 3, Task 4, Task 5 |
| `UploadTile` | `shared/widgets/` | Task 4 |
| `LeadClassificationBadge` | `shared/widgets/` | Task 3, Task 5 |
| `EmptyStateWidget` | `shared/widgets/` | Task 1, Task 5 |

---

## Figma Design Reference

The UI design and component layout for this submission were designed in Figma before implementation.

🎨 **Figma File:** [Japfa Assignment Design](https://www.figma.com/design/WoZTwWzU8Q0nurWm5RG4cE/Japfa_addignment?node-id=0-1&t=BaXyG5qAsibYmgiF-1)

The Figma file covers screen layouts, color token definitions, component states (upload tile states, check-in button states), and the overall visual system aligned with the Material Design 3 specification used in the codebase.

---

## Known Limitations & Deviations

### Google Maps (Task 2)
**Limitation:** `google_maps_flutter` requires a valid Google Maps API key configured in `AndroidManifest.xml` and `AppDelegate.swift`. As this was not available for the submission, the map area renders as a **styled placeholder widget** (`MapPlaceholder`) that satisfies all visual requirements:
- Pseudo street-grid painted via `CustomPaint`
- Semi-transparent geofence circle overlay (spec: "Circle overlay representing geofence radius")
- Customer location pin (spec: "Marker for customer location")
- User position marker that shifts position based on GPS state toggle (spec: "Marker for current user position")
- Coordinate text badge (spec: "render a styled Container placeholder with coordinates displayed as text")

To enable real maps, replace `MapPlaceholder` in `check_in_screen.dart` with a `GoogleMap` widget and add your API key to:
- `android/app/src/main/AndroidManifest.xml` → `com.google.android.geo.API_KEY`
- `ios/Runner/AppDelegate.swift` → `GMSServices.provideAPIKey("YOUR_KEY")`

### GPS Permissions (Task 2)
No actual device GPS permission logic is implemented. The "Enable GPS" button in `GpsErrorView` shows a `SnackBar` stub as per the task spec ("no actual permission logic needed — just the UI state").

### Navigation Flow — Add Visit (Task 1)
`AddVisitScreen` is a styled placeholder. The full visit creation form is out of scope per the task specification ("Tap → navigate to a stub detail screen (just a placeholder screen is fine)").

### KYC Customer Data (Task 4)
The `CustomerHeader` widget in the KYC screen uses hardcoded mock values (`'Ramesh Poultry Farm'`, `'LEAD-2024-00142'`). In a production implementation, this data would be passed via GoRouter `extra` from the lead creation flow.

### File Upload — Actual Upload (Task 4)
Files are selected via `file_picker` and their metadata (name, size) is captured and displayed in the uploaded state. No actual upload to a server occurs — this is by design as per the task spec ("file need not actually upload — capture the File object and transition to UPLOADED state").

### flutter analyze
The project passes `flutter analyze` with **zero errors and zero warnings** prior to submission.

---

## Screen Recording

> 📹 **Screen Walkthrough:** *(Link to be added upon submission — Loom / screen recording, max 5 minutes)*

The walkthrough covers all 5 screens with one key implementation decision highlighted per task:
1. **Task 1:** Reactive date filtering via Riverpod derived providers
2. **Task 2:** GPS state simulation and `GpsErrorView` as a non-Scaffold widget
3. **Task 3:** `LeadClassificationSelector` card design and animated segment field transitions
4. **Task 4:** Real `file_picker` integration and the 4-state `UploadTile` state machine
5. **Task 5:** Priority queue logic in `DashboardState.filteredLeads` and `TimelineTile` custom widget

---

## Submission Details

| Detail | Information |
|---|---|
| Repository | [https://github.com/suthishan/flutter_interview_task](https://github.com/suthishan/flutter_interview_task) |
| Figma | [Japfa Assignment Design](https://www.figma.com/design/WoZTwWzU8Q0nurWm5RG4cE/Japfa_addignment?node-id=0-1&t=BaXyG5qAsibYmgiF-1) |
| Hiring Contact | Suthishan Murali — Manager, Digital Platforms |
| Department | IT Digital Platforms, Japfa Comfeed India Pvt. Ltd. |
| Email Subject | Flutter Dev Task – [Your Name] |

---

*Built for a Sales Officer in a poultry farm with a dusty screen and 4G connectivity.*
