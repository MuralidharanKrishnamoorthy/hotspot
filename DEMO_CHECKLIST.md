# 🎬 Demo Recording Checklist

Use this checklist to record a comprehensive demo video showcasing all implemented features.

## 📹 Recording Setup
- [ ] Use screen recording software (iOS: built-in, Android: ADB screenrecord, Desktop: OBS)
- [ ] Ensure good lighting if showing device
- [ ] Test audio if narrating (optional)
- [ ] Clear app data before recording for fresh demo
- [ ] Target duration: 2-3 minutes

---

## 🎯 Demo Script (Screen 1: Experience Selection)

### 1. App Launch (5 seconds)
- [ ] Show app loading
- [ ] Display experience selection screen with API loading

### 2. Error Handling Demo (10 seconds) - OPTIONAL
- [ ] Toggle airplane mode OR force API failure
- [ ] Show retry button
- [ ] Tap retry and show successful load

### 3. Experience Cards (20 seconds)
- [ ] Show horizontal scroll of experience cards
- [ ] Demonstrate grayscale (unselected) vs colored (selected)
- [ ] Tap to select 2-3 cards
   - [ ] Show haptic feedback (subtle highlight)
   - [ ] Show selected card animation (size increase, border glow)
   - [ ] Show auto-scroll to selected card
- [ ] Tap again to deselect one card
- [ ] Show wave progress indicator at top updating as you scroll

### 4. Clear All Feature (5 seconds)
- [ ] Tap X button to clear all selections
- [ ] Show cards return to grayscale

### 5. Text Input (10 seconds)
- [ ] Re-select 1-2 cards
- [ ] Tap text field
- [ ] Type: "I want to create memorable experiences..."
- [ ] Show character counter (if visible)
- [ ] Dismiss keyboard

### 6. Validation Demo (8 seconds)
- [ ] Clear all selections (tap X)
- [ ] Tap "Next" button
- [ ] Show snackbar: "Please select at least one experience type"
- [ ] Re-select one card

### 7. Navigation (3 seconds)
- [ ] Tap "Next"
- [ ] Transition to onboarding question screen

---

## 🎯 Demo Script (Screen 2: Onboarding Question)

### 8. Question Screen Layout (5 seconds)
- [ ] Show question text
- [ ] Show text field
- [ ] Show mic and video buttons at bottom

### 9. Text Input (10 seconds)
- [ ] Tap text field
- [ ] Type: "I'm passionate about bringing people together..."
- [ ] Show keyboard handling (screen scrolls properly)
- [ ] Dismiss keyboard

### 10. Audio Recording (25 seconds)
- [ ] Tap microphone icon
- [ ] Show recording card appear
   - [ ] Show waveform animating
   - [ ] Show timer counting up (e.g., 00:05)
- [ ] Let it record for 5-8 seconds
- [ ] Tap stop button
- [ ] Show recorded audio card
   - [ ] Shows duration (e.g., "• 00:05")
   - [ ] Shows play button
   - [ ] Mic button is now hidden

### 11. Audio Playback (10 seconds)
- [ ] Tap play button on audio card
- [ ] Show play icon changes to stop
- [ ] Wait 2-3 seconds
- [ ] Tap stop button

### 12. Audio Deletion (5 seconds)
- [ ] Tap trash icon on audio card
- [ ] Show audio card disappears
- [ ] Show mic button reappears

### 13. Video Recording (20 seconds)
- [ ] Tap camera icon
- [ ] System camera opens (show briefly)
- [ ] Record 3-5 seconds of video
- [ ] Stop recording
- [ ] Show video recorded card
   - [ ] Shows actual duration (e.g., "• 00:04")
   - [ ] Shows video thumbnail
   - [ ] Camera button is now hidden

### 14. Video Preview (15 seconds) ⭐ HIGHLIGHT
- [ ] Tap on video card
- [ ] Show popup dialog opens
- [ ] Show video playing
- [ ] Tap play/pause button
- [ ] Tap X to close dialog

### 15. Video Deletion (5 seconds)
- [ ] Tap trash icon on video card
- [ ] Show video card disappears
- [ ] Show camera button reappears

### 16. Next Button Animation (8 seconds)
- [ ] Record new audio (quick)
- [ ] Show mic button disappears
- [ ] Show "Next" button width expands (AnimatedSize)
- [ ] Record video (quick)
- [ ] Show camera button disappears
- [ ] Show "Next" button now full width

### 17. Final State (5 seconds)
- [ ] Show complete screen with:
   - [ ] Text filled
   - [ ] Audio recorded
   - [ ] Video recorded
   - [ ] Full-width Next button
- [ ] Tap "Next" (show debug logs if possible)

---

## 🎁 Bonus Features to Highlight

Make sure to emphasize these in your demo:

1. **Haptic Feedback** - Mention "Notice the tactile feedback on selection"
2. **Wave Progress** - "Progress indicator updates as you scroll"
3. **Input Validation** - "The app validates input before proceeding"
4. **Error Handling** - "Network errors are handled gracefully with retry"
5. **Dynamic Duration** - "Video duration is extracted automatically"
6. **Video Preview** - "You can preview your video before submitting"
7. **Smooth Animations** - "All transitions are smooth and polished"

---

## 📝 Narration Script (Optional)

**Opening:**
"This is the Hotspot Onboarding app, a two-screen flow for prospective hosts. It's built with Flutter using BLoC state management and follows the provided Figma design."

**Screen 1:**
"On the first screen, hosts select their experience types from an API-driven list. Notice the haptic feedback and smooth animations when selecting cards. The app validates that at least one experience is selected before proceeding."

**Screen 2:**
"The second screen allows hosts to answer 'Why do you want to host?' through text, audio, or video. The audio recording shows a live waveform, and videos can be previewed in a popup dialog. The dynamic duration is extracted automatically from recorded media."

**Closing:**
"All brownie points have been implemented including pixel-perfect design, BLoC state management, smooth animations, and comprehensive error handling. Thank you!"

---

## ✅ Final Checks Before Recording

- [ ] App compiles without errors
- [ ] App runs smoothly on device
- [ ] All features working as expected
- [ ] Background/lighting looks professional
- [ ] Device is charged/plugged in
- [ ] Notifications are silenced (Do Not Disturb mode)
- [ ] Clean up any test data

---

## 📤 After Recording

1. **Edit Video (if needed):**
   - [ ] Trim dead space at start/end
   - [ ] Add intro title card (optional)
   - [ ] Add outro with GitHub link (optional)

2. **Export Settings:**
   - [ ] Format: MP4 or MOV
   - [ ] Resolution: 1080p (1920x1080) or device native
   - [ ] Max file size: <100MB (most email limits)

3. **Upload:**
   - [ ] Upload to Google Drive / Dropbox / WeTransfer
   - [ ] Set sharing permissions to "Anyone with link"
   - [ ] Test the link works

4. **Submission Email:**
   - [ ] To: jatin@8club.co
   - [ ] Subject: "Hotspot Onboarding Assignment - [Your Name]"
   - [ ] Body:
     - [ ] GitHub repository link
     - [ ] Demo video link
     - [ ] Brief summary of features implemented
     - [ ] List of brownie points achieved

---

## 🎬 Ready to Record!

Good luck! Showcase your hard work! 🚀
