# وقتك - Waqtak 🕌 | The macOS Talking Clock for Windows

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-0078D4)
![Framework](https://img.shields.io/badge/Flutter-3.x-02569B)
![License](https://img.shields.io/badge/license-MIT-green)

**Bringing the macOS "Announce the Time" experience to Windows with a spiritual twist.**  
Waqtak keeps you aware of time and connected to your Dhikr throughout your productive day.

[Download](#download) • [Features](#features) • [Screenshots](#screenshots) • [Technical Details](#technical-details)

</div>

---

## ✨ Why Waqtak?

Inspired by the iconic macOS "Announce the time" feature, **Waqtak** is a premium Windows desktop app built with Flutter. It combines a high-quality talking clock with periodic Islamic reminders (Adhkar) wrapped in a beautiful, modern UI.

## 🚀 Key Features

### 🗣️ macOS Style Talking Clock
- **High-Quality Announcements**: Triggers precisely at :00 and :30 (or custom intervals).
- **3 Language/Dialect Options**:
  - 🇪🇬 **Egyptian Arabic** (عربي مصري) - "الساعة التلاتة ونص بعد الضهر"
  - 🇸🇦 **Formal Arabic** (عربي فصحى) - "الساعة الثالثة والنصف مساءً"
  - 🇬🇧 **English** - "It's half past 3 PM"
- **Natural Phrasing**: No robotic AM/PM; uses proper Arabic periods (صباحاً، مساءً، الصبح، العصر).

### 🕌 Smart Islamic Reminders
- **70+ Authentic Phrases**: Carefully selected Adhkar with full Tashkeel (تشكيل) for proper pronunciation.
- **Ultra-Low Resource Usage**: Zero CPU impact between reminders.
- **Customizable Experience**: Adjust chime volume and announcement frequency.

### 💎 Premium Desktop Experience
- **Modern Windows UI**: A stunning Navy & Gold theme designed with Material 3 and Fluent principles.
- **System Tray Integration**: Runs silently in the background; access everything from the bottom-right corner.
- **Windows Startup**: Automatically launches with your PC so you never miss a reminder.

---

## 📱 Features at a Glance

| Feature | Description |
|---------|-------------|
| ⏰ Smart Timer | Exact hour/half-hour scheduling |
| 🔔 Premium Chime | Soft, non-disturbing bell sound |
| 🪟 Toast Notifications | Native Windows notifications |
| 🎙️ Windows SAPI | Uses native hardware-level Text-to-Speech |
| 🚀 MSIX Ready | Optimized for Microsoft Store distribution |

---

## 📖 Dhikr Collection (70 Phrases)

The app includes **70 carefully selected phrases** categorized for your daily inspiration:

| Category | Count | Examples |
|----------|-------|----------|
| Adhkar | 12 | سُبْحَانَ اللهِ وَبِحَمْدِهِ |
| Duaa | 13 | اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ |
| Hadith | 20 | إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ |
| Wisdom | 15 | الصَّبْرُ مِفْتَاحُ الْفَرَجِ |
| Quran | 10 | إِنَّ مَعَ الْعُسْرِ يُسْرًا |

---

## 🛠️ Technical Details

| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x |
| Platform | Windows 10/11 64-bit |
| TTS Engine | Windows SAPI (Native) |
| UI Design | Material 3 / Custom Navy-Gold Theme |
| Build Size | ~25 MB |

### Key Dependencies
- `window_manager` - Advanced window control.
- `system_tray` - Modern tray integration.
- `flutter_tts` - Native speech synthesis.
- `audioplayers` - High-fidelity chime playback.
- `launch_at_startup` - Seamless boot integration.

---

## 📦 Building from Source

```bash
# Clone repository
git clone https://github.com/MahmoudJamal96/Waqtak.git
cd Waqtak

# Install dependencies
flutter pub get

# Build release
flutter build windows --release
```

---

## 🎯 Arabic Voice Setup (Windows)

For the best experience, ensure you have the Arabic voice pack installed:
1. Open **Settings** → **Time & Language** → **Speech**.
2. Click **Add voices** and search for **Arabic**.
3. Install and restart the app.

---

## 📄 License

MIT License - Feel free to use and modify for the benefit of the community!

---

<div align="center">

**Made with ❤️ for the Muslim Community**  
If you find this project useful, please consider giving it a ⭐!

</div>
