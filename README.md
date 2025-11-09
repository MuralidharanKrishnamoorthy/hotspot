# 🎯 Hotspot Onboarding – Flutter Assignment

A polished two-screen onboarding flow for Hotspot Hosts, built with Flutter using BLoC state management, Dio networking, and a custom design system aligned to Figma specifications.

---

## 📱 Features Implemented

### Screen 1: Experience Type Selection
✅ **Core Requirements:**
- [x] Fetch experiences from API with proper error handling
- [x] Multi-select experience cards with visual feedback
- [x] Grayscale filter for unselected cards
- [x] 250-character multi-line text input
- [x] Dynamic layout with proper spacing
- [x] State management using BLoC
- [x] State logging on navigation

✅ **Enhanced Features:**
- [x] **Input Validation:** Ensures at least one experience is selected
- [x] **Error Handling:** Retry mechanism with user-friendly error states
- [x] **Haptic Feedback:** Tactile response on card selection
- [x] **Animated Scroll:** Selected cards smoothly animate into view
- [x] **Progress Indicator:** Wave progress based on horizontal scroll position
- [x] **Clear All:** Option to reset selections

### Screen 2: Onboarding Question
✅ **Core Requirements:**
- [x] 600-character multi-line text input
- [x] Audio recording with live waveform visualization
- [x] Video recording support
- [x] Cancel recording mid-session
- [x] Delete recorded audio/video
- [x] Dynamic UI (hide record buttons when content exists)
- [x] Responsive keyboard handling

✅ **Bonus Features (Implemented):**
- [x] **Audio Playback:** Full playback controls with play/stop
- [x] **Video Preview:** Popup dialog to preview recorded videos
- [x] **Dynamic Video Duration:** Extracts actual video duration
- [x] **Smooth Animations:** Animated button width transitions

---

## 🎨 Brownie Points Achieved

### UI/UX Excellence
- ✅ **Pixel-Perfect Design:** Spacing, fonts, and colors match Figma specifications
- ✅ **Responsive Layout:** Handles keyboard open/close gracefully with `SingleChildScrollView`
- ✅ **Accessibility:** Haptic feedback for user actions

### State Management
- ✅ **BLoC Pattern:** Clean separation of business logic and UI
- ✅ **Dio Integration:** Configured HTTP client with proper timeouts
- ✅ **Equatable:** Efficient state comparison for rebuilds

### Animations
- ✅ **Card Selection Animation:** Smooth size and border color transitions
- ✅ **Scroll Animation:** Tapped cards scroll into view
- ✅ **Next Button Width Animation:** Expands when record buttons hide
- ✅ **AnimatedSize:** Seamless layout transitions

### Code Quality
- ✅ **Clean Architecture:** Organized by features (experiences, onboarding)
- ✅ **Separation of Concerns:** Presentation, BLoC, Data layers
- ✅ **Constants File:** Centralized magic numbers
- ✅ **Documentation:** Comprehensive code comments
- ✅ **No Dead Code:** Removed legacy/unused code

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # App-wide constants
│   ├── network/
│   │   └── dio_client.dart          # HTTP client wrapper
│   └── theme/
│       └── app_theme.dart           # Dark theme configuration
├── design_system/
│   ├── color_tokens.dart            # Figma color mappings
│   └── widgets/
│       ├── frosted_button.dart      # Custom button widget
│       └── wave_progress.dart       # Animated progress indicator
├── features/
│   ├── experiences/
│   │   ├── bloc/                    # BLoC for experience selection
│   │   ├── data/                    # Experience model & repository
│   │   └── presentation/
│   │       ├── experience_selection_screen.dart
│   │       └── widgets/
│   │           └── experience_card.dart
│   └── onboarding/
│       ├── bloc/                    # BLoC for onboarding question
│       └── presentation/
│           └── onboarding_question_screen.dart
└── main.dart                        # App entry point
```

---

## 🚀 Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.x (Dart 3.9.2) |
| **State Management** | `flutter_bloc` 9.0.0 |
| **Networking** | `dio` 5.7.0 |
| **Image Caching** | `cached_network_image` 3.4.1 |
| **Audio** | `audio_waveforms` 1.0.5 |
| **Video** | `video_player` 2.9.2, `image_picker` 1.1.2 |
| **Permissions** | `permission_handler` 11.3.1 |
| **Storage** | `path_provider` 2.1.4 |
| **Equality** | `equatable` 2.0.5 |

---

## 📦 Installation & Setup

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart 3.9.2 or higher
- iOS Simulator / Android Emulator or Physical Device

### Steps

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd hotspot_onboarding
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify permissions (already configured):**
   - **Android:** `android/app/src/main/AndroidManifest.xml`
     - Camera, Microphone, Storage permissions
   - **iOS:** `ios/Runner/Info.plist`
     - NSCameraUsageDescription, NSMicrophoneUsageDescription

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 🎮 How to Use

### Experience Selection Screen
1. Browse horizontal list of experience types
2. Tap cards to select/deselect (haptic feedback confirms)
3. Selected cards show color; unselected are grayscale
4. Optionally add description in text field (max 250 chars)
5. Tap **Next** to proceed (validates at least 1 selection)

### Onboarding Question Screen
1. Answer "Why do you want to host?" via:
   - **Text:** Up to 600 characters
   - **Audio:** Tap mic icon → record with waveform → stop
   - **Video:** Tap camera icon → record video → auto-saves
2. **Preview Recorded Content:**
   - Audio: Tap play/stop button
   - Video: Tap video card to open preview popup
3. **Delete:** Tap trash icon on audio/video cards
4. Tap **Next** when ready (validation pending implementation)

---

## 🎯 API Integration

**Endpoint:** `GET https://staging.chamberofsecrets.8club.co/v1/experiences?active=true`

**Response Structure:**
```json
{
  "message": "string",
  "data": {
    "experiences": [
      {
        "id": 0,
        "name": "string",
        "image_url": "string",
        ...
      }
    ]
  }
}
```

**Error Handling:**
- Network failures show retry button
- Timeout configured at 15 seconds
- User-friendly error messages

---

## 🌟 Additional Enhancements Implemented

Beyond the base requirements, this implementation includes:

1. **Input Validation**
   - Snackbar notification if no experience selected
   - Prevents navigation on invalid state

2. **Better Error UX**
   - Retry button for failed API calls
   - Clear error messages with icons

3. **Haptic Feedback**
   - Selection clicks for card taps
   - Improves tactile user experience

4. **Video Duration Extraction**
   - Dynamically reads actual video duration using `VideoPlayerController`
   - No more hardcoded "59 seconds" placeholder

5. **Video Preview**
   - Fullscreen popup dialog
   - Play/pause controls
   - Auto-loops for seamless preview

6. **Clean Code**
   - Removed legacy/dead code
   - Added doc comments
   - Centralized constants
   - Proper code organization

---



## 🎓 What I Learned

- Advanced BLoC pattern with complex state management
- Integrating audio waveforms in Flutter
- Video player implementation with dynamic duration extraction
- Responsive UI design with keyboard handling
- Clean architecture principles in Flutter
- API integration with proper error handling
- Creating reusable design system components

---

## 🔮 Future Enhancements

If time permits, these could be added:
- [ ] Local draft auto-save using `shared_preferences`
- [ ] Video thumbnail generation
- [ ] Shimmer loading states
- [ ] Page transition animations
- [ ] Unit/widget tests
- [ ] Analytics event tracking structure

---

## 👨‍💻 Author

Built with ❤️ for the 8club Hotspot Onboarding Assignment

---

## 📄 License

This project is created for assignment purposes.
