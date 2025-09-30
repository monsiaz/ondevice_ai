# Release Notes - Version 1.4

## 🎙️ New Features

### Voice Input & Output
- **Voice Dictation**: Tap the microphone button to speak your questions
  - On-device speech recognition for privacy
  - Supports multiple languages (English, French, Spanish, German, and more)
  - Real-time transcription directly into the input field

- **Text-to-Speech**: Listen to AI responses
  - Tap "Listen" button under any assistant reply
  - Uses your selected language for natural pronunciation
  - Stop playback anytime with the Stop button

### Conversation Management
- **New Conversation Button**: Quickly start fresh conversations
  - Automatically saves current chat to history
  - Access via the circular arrow icon in the header

- **Conversation History**: Browse and restore past conversations
  - Limited to 10 most recent conversations for optimal performance
  - Quick search functionality

### Quick Actions
- **Context Menu**: Long-press any response to:
  - Copy text to clipboard
  - Share via iOS share sheet (Notes, Mail, Messages, etc.)

### Customization & Settings
- **Visual Effects Control**:
  - Toggle bubble entrance animations
  - Adjust scroll behavior
  - Customize message spacing (80-250px slider)
  - Perfect your preferred chat layout

- **Advanced Settings**:
  - Organized settings with clear categories
  - Language selector controls app UI, voice input, and TTS
  - Developer tools: Logs, Memory monitoring, Cache management

### Siri & Shortcuts
- **"Ask OnDeviceAI" Intent**: Use Siri or Shortcuts app to send questions
- **Share Extension**: Analyze text from Safari, Mail, and other apps (requires manual setup)

## 🔧 Improvements

### Performance
- Extended generation timeout for better responses
- Optimized scroll behavior with smooth animations
- Reduced memory usage with smart conversation trimming

### Stability
- Fixed model switching logic - selected model stays active
- Prevented automatic model changes during chat
- Improved keyboard handling and positioning

### User Experience
- Input bar properly positioned at screen bottom
- Messages display with optimal spacing above input
- Smooth scrolling to show full responses
- Dark mode visual improvements

### Internationalization
- Complete French translations
- Spanish and German support
- Language-aware voice recognition and TTS

## 🐛 Bug Fixes
- Fixed crash when clearing conversations
- Corrected scroll position after message generation
- Fixed dark mode input bar appearance
- Resolved model auto-switching issues
- Fixed keyboard not closing after sending

## 🔐 Privacy & Security
- All voice processing happens on-device
- No data sent to external servers
- Complete user control over features via Settings

---

## 📝 What's New in This Version (App Store Description)

**Version 1.4 brings powerful voice features and enhanced customization!**

🎙️ **Voice Input**: Speak your questions with on-device dictation
🔊 **Audio Playback**: Listen to AI responses in your language
💬 **Better Conversations**: New conversation management and history
⚙️ **Full Customization**: Control animations, spacing, and visual effects
📋 **Quick Actions**: Copy and share responses with one tap
🌍 **Multilingual**: Complete support for French, Spanish, German

All processing remains 100% on-device. Your data never leaves your iPhone.

---

## 🚀 Next Steps for Submission

1. **Archive the app** in Xcode:
   - Product > Archive
   - Wait for completion

2. **Distribute to App Store Connect**:
   - Upload build
   - Wait for processing (15-60 min)

3. **Create new version 1.4** in App Store Connect:
   - Add release notes (use the description above)
   - Select build 1.4 (2)
   - Submit for review

4. **Respond to any review questions** if needed

Expected review time: 24-48 hours
