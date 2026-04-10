# وقتك - Waqtak 🕌

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-0078D4)
![Framework](https://img.shields.io/badge/Flutter-3.x-02569B)
![License](https://img.shields.io/badge/license-MIT-green)

**A Windows desktop app for periodic Islamic reminders**  
with beautiful chime sounds, TTS speech in Arabic/English, and notifications.

[Download](#download) • [Features](#features) • [Screenshots](#screenshots) • [How to Use](#how-to-use)

</div>

---

## ✨ Features

### 🕰️ Smart Scheduling
- **Exact Hour/Half-Hour Chimes**: Triggers precisely at :00 and :30
- **Ultra-Low Resource Usage**: Zero CPU between chimes
- **Multiple Intervals**: Every hour, 30 mins, 2 hours, or test mode

### 🗣️ Text-to-Speech
- **3 Language Options**:
  - 🇪🇬 **Egyptian Arabic** (عربي مصري) - "الساعة التلاتة ونص بعد الضهر"
  - 🇸🇦 **Formal Arabic** (عربي فصحى) - "الساعة الثالثة والنصف مساءً"
  - 🇬🇧 **English** - "It's half past 3 PM"
- **No AM/PM in Arabic**: Uses proper Arabic periods (صباحاً، مساءً، الصبح، العصر)
- **70 Dhikr Phrases**: With full Tashkeel (تشكيل) for proper pronunciation

### 🔔 System Tray
- Runs silently in Windows system tray
- Custom icon shows app is running
- Quick menu for settings and testing

### 📱 Features at a Glance
| Feature | Description |
|---------|-------------|
| ⏰ Smart Timer | Exact hour/half-hour scheduling |
| 🔔 Chime Sound | Soft bell sound with volume control |
| 🪟 Notifications | Windows toast notifications |
| 🗣️ Speech | TTS in 3 languages |
| 📝 70 Phrases | Fully customizable Adhkar list |
| 🚀 Auto-Start | Windows startup integration |

---

## 📖 Dhikr Collection (70 Phrases)

The app includes **70 carefully selected phrases** with full Tashkeel:

| Category | Count | Examples |
|----------|-------|----------|
| أذكار | 12 | سُبْحَانَ اللهِ وَبِحَمْدِهِ |
| أدعية | 13 | اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ |
| أحاديث | 20 | إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ |
| حكم | 15 | الصَّبْرُ مِفْتَاحُ الْفَرَجِ |
| قرآن | 10 | إِنَّ مَعَ الْعُسْرِ يُسْرًا |

---

## 🖥️ How to Use

1. **Launch**: App starts minimized to system tray (bottom-right corner)
2. **Open Settings**: Click tray icon → "Open Settings"
3. **Configure**: 
   - Choose interval (hour/half-hour)
   - Select TTS language
   - Adjust chime volume
4. **Test**: Click "اختبر الآن" to hear time + dhikr immediately
5. **Quit**: Right-click tray icon → "Quit"

### Tray Menu
- **Open Settings (الإعدادات)** - Opens configuration window
- **Test Now (اختبر الآن)** - Instant test of all features
- **Quit (إغلاق)** - Exit application

---

## 🛠️ Technical Details

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x |
| Platform | Windows 10/11 64-bit |
| TTS Engine | Windows SAPI |
| Notifications | Windows Toast |
| Build Size | ~25 MB |

### Dependencies
- `window_manager` - Window control
- `system_tray` - System tray integration
- `flutter_tts` - Text-to-speech
- `audioplayers` - Audio playback
- `shared_preferences` - Settings persistence
- `launch_at_startup` - Auto-start

---

## 📦 Building from Source

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/chime-dhikr.git
cd chime-dhikr

# Install dependencies
flutter pub get

# Build release
flutter build windows --release

# Output: build/windows/x64/runner/Release/
```

---

## 🎯 Arabic Voice Setup (Windows)

For best Arabic TTS experience, install Arabic voice pack:

1. Open **Settings** → **Time & Language** → **Speech**
2. Click **Add voices**
3. Search for **Arabic** → Install
4. Restart the app

---

## 📄 License

MIT License - Feel free to use and modify!

---

## 🤝 Contributing

Contributions welcome! Please feel free to:
- Report bugs
- Suggest features
- Submit pull requests

---

<div align="center">

**Made with ❤️ for the Muslim Community**

</div>


## License

MIT License
