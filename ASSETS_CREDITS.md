# Asset Credits & Licenses

This file documents the sources and licenses of all assets used in Waqtak (وقتك).

---

## 🎨 App Icon & Images

### app_icon.png / app_icon.ico
- **Source**: [SPECIFY YOUR SOURCE]
- **License**: [SPECIFY LICENSE]
- **Notes**: Replace this entry with your actual icon source

**Options for legal compliance:**
1. Create your own using Canva, Figma, or similar tools
2. Purchase from a designer (keep receipt as proof)
3. Use DALL-E (OpenAI) - they grant commercial rights
4. Use licensed stock icons with proper attribution

---

## 🔊 Audio Files

### Time Announcement Audio (assets/audio/time/*.mp3)
- **Voice**: Microsoft Edge Neural TTS (ar-EG-SalmaNeural)
- **Generated with**: edge-tts Python package
- **License**: Microsoft Azure Cognitive Services TOS allows commercial use
- **Content**: Arabic numbers, time words, periods (public domain text)
- **Generation script**: regenerate_audio.py

**Files:**
| File | Content (Arabic) | Translation |
|------|------------------|-------------|
| alsaa.mp3 | الساعة | "The hour is" |
| h1.mp3 - h12.mp3 | واحدة - اتناشر | Hours 1-12 |
| p_morning.mp3 | صباحاً | Morning |
| p_noon.mp3 | الظُهر | Noon |
| p_afternoon.mp3 | بعد الضُهر | Afternoon |
| p_asr.mp3 | العصر | Asr time |
| p_night.mp3 | مساءً | Evening/Night |
| e_half.mp3 | ونص | And half |
| e_quarter.mp3 | وربع | And quarter |
| e_quarter_to.mp3 | إلا ربع | Quarter to |

### Dhikr Audio (assets/audio/dhikr/*.mp3)
- **Voice**: Microsoft Edge Neural TTS (ar-EG-SalmaNeural)
- **Generated with**: edge-tts Python package
- **License**: Microsoft Azure Cognitive Services TOS allows commercial use
- **Content**: Islamic dhikr phrases (public domain religious text)

**Files:**
| File | Content (Arabic with Tashkeel) | Translation |
|------|--------------------------------|-------------|
| d1.mp3 | سُبْحَانَ اللهِ | Glory be to Allah |
| d2.mp3 | الحَمْدُ للهِ | Praise be to Allah |
| d3.mp3 | اللهُ أَكْبَر | Allah is the Greatest |
| d4.mp3 | لَا إِلَهَ إِلَّا الله | There is no god but Allah |
| d5.mp3 | أَسْتَغْفِرُ الله | I seek Allah's forgiveness |
| d6.mp3 | لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِالله | There is no power except with Allah |
| d7.mp3 | سُبْحَانَ اللهِ وَبِحَمْدِهِ | Glory and praise to Allah |
| d8.mp3 | سُبْحَانَ اللهِ العَظِيم | Glory to Allah the Magnificent |
| d9.mp3 | اللَّهُمَّ صَلِّ عَلَى مُحَمَّد | O Allah, bless Muhammad |
| d10.mp3 | رَبِّ اغْفِرْ لِي | My Lord, forgive me |
| d11.mp3 | حَسْبُنَا اللهُ وَنِعْمَ الوَكِيل | Allah is sufficient for us |
| d12.mp3 | بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيم | In the name of Allah |
| d13.mp3 | لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ | There is no god but You, glory to You |
| d14.mp3 | رَضِيتُ بِاللهِ رَبًّا | I am pleased with Allah as Lord |
| d15.mp3 | يَا حَيُّ يَا قَيُّوم | O Ever-Living, O Sustainer |
| d16.mp3 | اللَّهُمَّ إِنِّي أَسْأَلُكَ العَافِيَة | O Allah, I ask You for well-being |
| d17.mp3 | سُبُّوحٌ قُدُّوس | Most Glorious, Most Holy |
| d18.mp3 | تَوَكَّلْتُ عَلَى الله | I put my trust in Allah |
| d19.mp3 | اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ | O Allah, help me remember You |
| d20.mp3 | رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَة | Our Lord, grant us good in this world |

### Chime Sound (assets/sounds/chime.wav or chime.mp3)
- **Source**: [SPECIFY YOUR SOURCE - e.g., Freesound.org, Pixabay, self-recorded]
- **License**: [SPECIFY - e.g., CC0, Royalty-free]
- **Notes**: [Any additional notes]

---

## 📝 Text Content

### Dhikr Phrases (assets/phrases.json)
- **Source**: Traditional Islamic dhikr and supplications
- **License**: Public domain (religious text)
- **Notes**: These are commonly recited Islamic phrases from Quran and Hadith

---

## 🔤 Fonts

### System Font (Segoe UI)
- **Type**: Windows system font
- **License**: Included with Windows OS
- **Notes**: Used for Arabic and English text display

---

## 📦 Third-Party Packages

See pubspec.yaml for the full list. Key packages:

| Package | License | Link |
|---------|---------|------|
| flutter | BSD-3-Clause | flutter.dev |
| window_manager | MIT | pub.dev/packages/window_manager |
| system_tray | MIT | pub.dev/packages/system_tray |
| flutter_tts | MIT | pub.dev/packages/flutter_tts |
| audioplayers | MIT | pub.dev/packages/audioplayers |
| shared_preferences | BSD-3-Clause | pub.dev/packages/shared_preferences |
| launch_at_startup | MIT | pub.dev/packages/launch_at_startup |

---

## ✅ Compliance Checklist

- [ ] App icon is properly licensed
- [ ] All audio files are properly licensed
- [ ] Chime sound has proper license
- [ ] Third-party licenses acknowledged

---

**Last Updated**: [DATE]
**Maintained by**: [YOUR NAME]
