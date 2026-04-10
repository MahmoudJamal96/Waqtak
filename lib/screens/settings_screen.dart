import 'package:flutter/material.dart';
import '../models/app_settings.dart';

/// Settings screen for the Waqtak app
class SettingsScreen extends StatefulWidget {
  final AppSettings settings;
  final Function(AppSettings) onSave;
  final VoidCallback onTestNow;
  final bool isArabicTtsAvailable;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onSave,
    required this.onTestNow,
    this.isArabicTtsAvailable = true,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _settings;
  final TextEditingController _phraseController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showAdvancedIntervals = false;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings.copyWith();
    // Show advanced if user already has an advanced interval selected
    _showAdvancedIntervals = !_settings.interval.isPrimary;
  }

  @override
  void dispose() {
    _phraseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    widget.onSave(_settings);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved! ✓'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addPhrase() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Phrase'),
        content: TextField(
          controller: _phraseController,
          decoration: const InputDecoration(
            hintText: 'Enter Arabic phrase...',
            border: OutlineInputBorder(),
          ),
          textDirection: TextDirection.rtl,
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _phraseController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_phraseController.text.trim().isNotEmpty) {
                setState(() {
                  _settings.phrases.add(_phraseController.text.trim());
                });
                _phraseController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editPhrase(int index) {
    _phraseController.text = _settings.phrases[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Phrase'),
        content: TextField(
          controller: _phraseController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          textDirection: TextDirection.rtl,
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _phraseController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_phraseController.text.trim().isNotEmpty) {
                setState(() {
                  _settings.phrases[index] = _phraseController.text.trim();
                });
                _phraseController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deletePhrase(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Phrase?'),
        content: Text(
          _settings.phrases[index],
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _settings.phrases.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _resetPhrases() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Phrases?'),
        content: const Text('This will restore all default phrases and remove any custom ones.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _settings = _settings.copyWith(
                  phrases: List.from(AppSettings.defaultPhrases),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF153457),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              
              // Test Button - Prominent at the top
            _buildTestButton(),
            const SizedBox(height: 24),

            // Interval Section
            _buildSectionCard(
              title: '⏰ Chime Interval',
              child: _buildIntervalSection(),
            ),
            const SizedBox(height: 16),

            // Chime Sound Section
            _buildSectionCard(
              title: '🔔 Chime Sound',
              child: _buildChimeSoundSection(),
            ),
            const SizedBox(height: 16),

            // Notification Section
            _buildSectionCard(
              title: '🪟 Windows Notification',
              child: _buildNotificationSection(),
            ),
            const SizedBox(height: 16),

            // Speech Section
            _buildSectionCard(
              title: '🗣️ Speech (TTS)',
              child: _buildSpeechSection(),
            ),
            const SizedBox(height: 16),

            // Phrases Section
            _buildSectionCard(
              title: '📝 Dhikr Phrases',
              child: _buildPhrasesSection(),
            ),
            const SizedBox(height: 16),

            // Startup Section
            _buildSectionCard(
              title: '🚀 Startup',
              child: _buildStartupSection(),
            ),
            const SizedBox(height: 24),

            // Save Button
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              'assets/images/header.png',
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF153457), Color(0xFF2A5982)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              children: [
                const Text(
                  'وَقْتُكَ ثَمِينٌ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCCA762),
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'يُنَبِّهُكَ بِرَأْسِ السَّاعَةِ.. وَيُذَكِّرُكَ بِذِكْرِ اللهِ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCCA762).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton.icon(
          onPressed: widget.onTestNow,
          icon: const Icon(Icons.play_circle_filled, size: 28),
          label: const Text(
            'اختبر الآن',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCCA762),
            foregroundColor: const Color(0xFF153457),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCA762),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF153457),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalSection() {
    // Primary intervals (always visible)
    final primaryIntervals = ChimeInterval.values.where((i) => i.isPrimary).toList();
    // Advanced intervals (collapsible)
    final advancedIntervals = ChimeInterval.values.where((i) => !i.isPrimary).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary options
        ...primaryIntervals.map((interval) => _buildIntervalTile(interval)),
        
        const SizedBox(height: 8),
        
        // Advanced options expander
        InkWell(
          onTap: () {
            setState(() {
              _showAdvancedIntervals = !_showAdvancedIntervals;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  _showAdvancedIntervals 
                      ? Icons.expand_less 
                      : Icons.expand_more,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  _showAdvancedIntervals ? 'إخفاء خيارات إضافية' : 'خيارات إضافية',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Advanced options (collapsible)
        if (_showAdvancedIntervals)
          ...advancedIntervals.map((interval) => _buildIntervalTile(interval)),
      ],
    );
  }

  Widget _buildIntervalTile(ChimeInterval interval) {
    final isSelected = _settings.interval == interval;
    
    return RadioListTile<ChimeInterval>(
      title: Text(
        interval.labelAr,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: interval.isTestMode
          ? Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'للتجربة فقط - لا تتركه هكذا',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,
      value: interval,
      groupValue: _settings.interval,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _settings = _settings.copyWith(interval: value);
          });
        }
      },
      activeColor: Colors.teal,
      dense: true,
    );
  }

  Widget _buildChimeSoundSection() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Enable Chime Sound'),
          value: _settings.chimeEnabled,
          onChanged: (value) {
            setState(() {
              _settings = _settings.copyWith(chimeEnabled: value);
            });
          },
          activeColor: Colors.teal,
        ),
        if (_settings.chimeEnabled) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.volume_down, color: Colors.grey),
              Expanded(
                child: Slider(
                  value: _settings.chimeVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(_settings.chimeVolume * 100).round()}%',
                  onChanged: (value) {
                    setState(() {
                      _settings = _settings.copyWith(chimeVolume: value);
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ),
              const Icon(Icons.volume_up, color: Colors.grey),
            ],
          ),
          Text(
            'Volume: ${(_settings.chimeVolume * 100).round()}%',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationSection() {
    return SwitchListTile(
      title: const Text('Show Windows Notification'),
      subtitle: const Text('Display notification with current time and phrase'),
      value: _settings.notificationEnabled,
      onChanged: (value) {
        setState(() {
          _settings = _settings.copyWith(notificationEnabled: value);
        });
      },
      activeColor: Colors.teal,
    );
  }

  Widget _buildSpeechSection() {
    return Column(
      children: [
        // Announce Time toggle
        SwitchListTile(
          title: const Text('Announce the Time'),
          subtitle: const Text('Speak current time on each chime'),
          value: _settings.announceTime,
          onChanged: (value) {
            setState(() {
              _settings = _settings.copyWith(announceTime: value);
            });
          },
          activeTrackColor: Colors.teal.shade200,
          activeColor: Colors.teal,
        ),
        const Divider(),
        // Announce Dhikr toggle
        SwitchListTile(
          title: const Text('Announce Dhikr Phrase'),
          subtitle: const Text('Speak a random Islamic phrase'),
          value: _settings.announceDhikr,
          onChanged: (value) {
            setState(() {
              _settings = _settings.copyWith(announceDhikr: value);
            });
          },
          activeTrackColor: Colors.teal.shade200,
          activeColor: Colors.teal,
        ),
        if (_settings.speechEnabled) ...[
          const SizedBox(height: 12),
          if (!widget.isArabicTtsAvailable)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'صوت عربي غير متوفر',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'لتثبيت صوت عربي على Windows:\n'
                    '1. افتح Settings > Time & Language\n'
                    '2. اختر Speech\n'
                    '3. اضغط Add voices\n'
                    '4. ابحث عن Arabic واختر تثبيته',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          DropdownButtonFormField<TtsLanguage>(
            value: _settings.ttsLanguage,
            decoration: const InputDecoration(
              labelText: 'لغة النطق',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.language),
            ),
            items: TtsLanguage.values.map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Text(lang.label),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(ttsLanguage: value);
                });
              }
            },
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'مثال على النطق:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getExampleSpeech(),
                  textDirection: _settings.ttsLanguage == TtsLanguage.english 
                      ? TextDirection.ltr 
                      : TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getExampleSpeech() {
    switch (_settings.ttsLanguage) {
      case TtsLanguage.egyptianArabic:
        return '1. الساعة التلاتة بعد الضهر\n2. سبحان الله وبحمده';
      case TtsLanguage.formalArabic:
        return '1. الساعة الثالثة مساءً\n2. سبحان الله وبحمده';
      case TtsLanguage.english:
        return "1. It's 3 PM\n2. Dhikr phrase";
    }
  }

  Widget _buildPhrasesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_settings.phrases.length} phrases',
              style: const TextStyle(color: Colors.grey),
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _resetPhrases,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reset'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addPhrase,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.separated(
            itemCount: _settings.phrases.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  _settings.phrases[index],
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editPhrase(index),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletePhrase(index),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStartupSection() {
    return SwitchListTile(
      title: const Text('Run at Windows Startup'),
      subtitle: const Text('Start automatically when Windows boots'),
      value: _settings.runAtStartup,
      onChanged: (value) {
        setState(() {
          _settings = _settings.copyWith(runAtStartup: value);
        });
      },
      activeColor: Colors.teal,
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153457).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: _saveSettings,
          icon: const Icon(Icons.save),
          label: const Text(
            'حفظ الإعدادات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF153457),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
