import 'dart:convert';

/// Interval options for chime timing
enum ChimeInterval {
  oneMinute(1, 'وضع التجربة (كل دقيقة)', 'Test Mode (1 min)'),
  thirtyMinutes(30, 'كل نص ساعة', 'Every 30 minutes'),
  oneHour(60, 'كل ساعة', 'Every hour'),
  twoHours(120, 'كل ساعتين', 'Every 2 hours');

  final int minutes;
  final String labelAr;
  final String labelEn;

  const ChimeInterval(this.minutes, this.labelAr, this.labelEn);

  String get label => labelAr; // Default to Arabic

  Duration get duration => Duration(minutes: minutes);

  static ChimeInterval fromMinutes(int minutes) {
    return ChimeInterval.values.firstWhere(
      (e) => e.minutes == minutes,
      orElse: () => ChimeInterval.oneHour,
    );
  }
  
  /// Check if this is a primary option (shown by default)
  bool get isPrimary => this == oneHour || this == thirtyMinutes;
  
  /// Check if this is test mode
  bool get isTestMode => this == oneMinute;
}

/// TTS Language options
enum TtsLanguage {
  egyptianArabic('ar-EG', 'عربي مصري'),
  formalArabic('ar-SA', 'عربي فصحى'),
  english('en-US', 'English');

  final String code;
  final String label;

  const TtsLanguage(this.code, this.label);

  static TtsLanguage fromCode(String code) {
    return TtsLanguage.values.firstWhere(
      (e) => e.code == code,
      orElse: () => TtsLanguage.egyptianArabic,
    );
  }
  
  /// Check if this is an Arabic variant
  bool get isArabic => this == egyptianArabic || this == formalArabic;
}

/// Application settings model
class AppSettings {
  ChimeInterval interval;
  bool chimeEnabled;
  double chimeVolume;
  bool notificationEnabled;
  bool announceTime;      // Announce the time
  bool announceDhikr;     // Announce dhikr phrase
  TtsLanguage ttsLanguage;
  List<String> phrases;
  bool runAtStartup;

  AppSettings({
    this.interval = ChimeInterval.oneHour,  // Default: every hour
    this.chimeEnabled = true,
    this.chimeVolume = 0.7,
    this.notificationEnabled = true,
    this.announceTime = true,
    this.announceDhikr = true,
    this.ttsLanguage = TtsLanguage.egyptianArabic,  // Default: Egyptian Arabic
    List<String>? phrases,
    this.runAtStartup = false,
  }) : phrases = phrases ?? defaultPhrases;

  /// Check if any speech is enabled
  bool get speechEnabled => announceTime || announceDhikr;

  /// Default Arabic phrases with full Tashkeel (70 phrases)
  static List<String> get defaultPhrases => [
        // الأذكار والتسبيح
        'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
        'سُبْحَانَ اللهِ الْعَظِيمِ',
        'الْحَمْدُ للهِ عَلَى كُلِّ حَالٍ',
        'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        'اللهُ أَكْبَرُ كَبِيرًا وَالْحَمْدُ للهِ كَثِيرًا',
        'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
        'حَسْبِيَ اللهُ وَنِعْمَ الْوَكِيلُ',
        'أَسْتَغْفِرُ اللهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ',
        'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
        'بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ',
        'سُبْحَانَ اللهِ وَبِحَمْدِهِ سُبْحَانَ اللهِ الْعَظِيمِ',
        'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَعَافِنِي',
        // الأدعية المأثورة
        'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
        'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
        'اللَّهُمَّ اجْعَلْ خَيْرَ عَمَلِي خَوَاتِيمَهُ',
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
        'اللَّهُمَّ آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً',
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى',
        'اللَّهُمَّ أَصْلِحْ لِي دِينِيَ الَّذِي هُوَ عِصْمَةُ أَمْرِي',
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ حُبَّكَ وَحُبَّ مَنْ يُحِبُّكَ',
        'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ',
        'رَبِّ زِدْنِي عِلْمًا وَارْزُقْنِي فَهْمًا',
        'اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا',
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ رِضَاكَ وَالْجَنَّةَ',
        // أحاديث نبوية قصيرة
        'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
        'الطُّهُورُ شَطْرُ الْإِيمَانِ',
        'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ',
        'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
        'مَنْ كَانَ يُؤْمِنُ بِاللهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
        'خَيْرُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ',
        'الدِّينُ النَّصِيحَةُ',
        'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ صَدَقَةٌ',
        'مَنْ لَا يَشْكُرُ النَّاسَ لَا يَشْكُرُ اللهَ',
        'اتَّقِ اللهَ حَيْثُمَا كُنْتَ',
        'إِنَّ اللهَ يُحِبُّ إِذَا عَمِلَ أَحَدُكُمْ عَمَلًا أَنْ يُتْقِنَهُ',
        'الْيَدُ الْعُلْيَا خَيْرٌ مِنَ الْيَدِ السُّفْلَى',
        'كُنْ فِي الدُّنْيَا كَأَنَّكَ غَرِيبٌ أَوْ عَابِرُ سَبِيلٍ',
        'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
        'لَا ضَرَرَ وَلَا ضِرَارَ',
        'إِنَّ مِنْ أَكْمَلِ الْمُؤْمِنِينَ إِيمَانًا أَحْسَنُهُمْ خُلُقًا',
        'بَادِرُوا بِالْأَعْمَالِ قَبْلَ أَنْ تُشْغَلُوا',
        'احْرِصْ عَلَى مَا يَنْفَعُكَ وَاسْتَعِنْ بِاللهِ وَلَا تَعْجَزْ',
        'طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ',
        'نِعْمَتَانِ مَغْبُونٌ فِيهِمَا كَثِيرٌ مِنَ النَّاسِ الصِّحَّةُ وَالْفَرَاغُ',
        // حكم وأقوال مأثورة
        'الْوَقْتُ كَالسَّيْفِ إِنْ لَمْ تَقْطَعْهُ قَطَعَكَ',
        'الْعِلْمُ فِي الصِّغَرِ كَالنَّقْشِ عَلَى الْحَجَرِ',
        'لِسَانُكَ حِصَانُكَ إِنْ صُنْتَهُ صَانَكَ',
        'مَنْ جَدَّ وَجَدَ وَمَنْ زَرَعَ حَصَدَ',
        'الصَّبْرُ مِفْتَاحُ الْفَرَجِ',
        'الْقَنَاعَةُ كَنْزٌ لَا يَفْنَى',
        'خَيْرُ الْأُمُورِ أَوْسَاطُهَا',
        'أَصْلُ كُلِّ خَيْرٍ فِي الدُّنْيَا وَالْآخِرَةِ التَّقْوَى',
        'مَا قَلَّ وَكَفَى خَيْرٌ مِمَّا كَثُرَ وَأَلْهَى',
        'التَّوَاضُعُ لَا يَزِيدُ الْعَبْدَ إِلَّا رِفْعَةً',
        'رَأْسُ الْحِكْمَةِ مَخَافَةُ اللهِ',
        'كَفَى بِالْمَرْءِ عِلْمًا أَنْ يَخْشَى اللهَ',
        'اغْتَنِمْ خَمْسًا قَبْلَ خَمْسٍ شَبَابَكَ قَبْلَ هَرَمِكَ',
        'مَنْ عَرَفَ نَفْسَهُ أَشْغَلَهُ ذَلِكَ عَنْ عَيْبِ غَيْرِهِ',
        'إِذَا أَرَدْتَ أَنْ تُعْرَفَ فَاعْمَلْ فِي السِّرِّ',
        // آيات قرآنية قصيرة
        'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
        'وَبَشِّرِ الصَّابِرِينَ',
        'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
        'وَتَوَكَّلْ عَلَى اللهِ وَكَفَى بِاللهِ وَكِيلًا',
        'إِنَّ اللهَ مَعَ الصَّابِرِينَ',
        'وَمَنْ يَتَّقِ اللهَ يَجْعَلْ لَهُ مَخْرَجًا',
        'وَقُلْ رَبِّ زِدْنِي عِلْمًا',
        'أَلَا بِذِكْرِ اللهِ تَطْمَئِنُّ الْقُلُوبُ',
        'وَمَا تَوْفِيقِي إِلَّا بِاللهِ عَلَيْهِ تَوَكَّلْتُ',
      ];

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'interval': interval.minutes,
      'chimeEnabled': chimeEnabled,
      'chimeVolume': chimeVolume,
      'notificationEnabled': notificationEnabled,
      'announceTime': announceTime,
      'announceDhikr': announceDhikr,
      'ttsLanguage': ttsLanguage.code,
      'phrases': phrases,
      'runAtStartup': runAtStartup,
    };
  }

  /// Create from JSON map
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      interval: ChimeInterval.fromMinutes(json['interval'] ?? 60),
      chimeEnabled: json['chimeEnabled'] ?? true,
      chimeVolume: (json['chimeVolume'] ?? 0.7).toDouble(),
      notificationEnabled: json['notificationEnabled'] ?? true,
      announceTime: json['announceTime'] ?? json['speechEnabled'] ?? true,
      announceDhikr: json['announceDhikr'] ?? json['speechEnabled'] ?? true,
      ttsLanguage: TtsLanguage.fromCode(json['ttsLanguage'] ?? 'ar-EG'),
      phrases: json['phrases'] != null
          ? List<String>.from(json['phrases'])
          : defaultPhrases,
      runAtStartup: json['runAtStartup'] ?? false,
    );
  }

  /// Serialize to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Deserialize from JSON string
  factory AppSettings.fromJsonString(String jsonString) {
    return AppSettings.fromJson(jsonDecode(jsonString));
  }

  /// Create a copy with optional changes
  AppSettings copyWith({
    ChimeInterval? interval,
    bool? chimeEnabled,
    double? chimeVolume,
    bool? notificationEnabled,
    bool? announceTime,
    bool? announceDhikr,
    TtsLanguage? ttsLanguage,
    List<String>? phrases,
    bool? runAtStartup,
  }) {
    return AppSettings(
      interval: interval ?? this.interval,
      chimeEnabled: chimeEnabled ?? this.chimeEnabled,
      chimeVolume: chimeVolume ?? this.chimeVolume,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      announceTime: announceTime ?? this.announceTime,
      announceDhikr: announceDhikr ?? this.announceDhikr,
      ttsLanguage: ttsLanguage ?? this.ttsLanguage,
      phrases: phrases ?? List.from(this.phrases),
      runAtStartup: runAtStartup ?? this.runAtStartup,
    );
  }
}
