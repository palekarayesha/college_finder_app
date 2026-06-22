import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'search_screen.dart';

class CompareScreen extends StatefulWidget {
  final List<Map<String, dynamic>> colleges;
  final bool fromHome;

  const CompareScreen({super.key, required this.colleges, this.fromHome = false});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  late List<Map<String, dynamic>> compareList;

  @override
  void initState() {
    super.initState();
    compareList = List.from(widget.colleges);
  }

  Color _getNaacColor(String naac) {
    switch (naac) {
      case 'A++': return const Color(0xFF1B5E20);
      case 'A+': return const Color(0xFF2E7D32);
      case 'A': return const Color(0xFF388E3C);
      case 'B++': return const Color(0xFFF57F17);
      default: return const Color(0xFFBF360C);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromHome && compareList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Compare Colleges'),
          backgroundColor: const Color(0xFF1565C0),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.compare_arrows, size: 60, color: Color(0xFF1565C0)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Compare Colleges',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Go to Search, select colleges using the checkboxes, then tap Compare.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Go to Search'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final features = [
      {'label': 'City', 'key': 'city', 'icon': Icons.location_on},
      {'label': 'Type', 'key': 'type', 'icon': Icons.account_balance},
      {'label': 'University', 'key': 'university', 'icon': Icons.school},
      {'label': 'Fees', 'key': 'fees', 'icon': Icons.currency_rupee},
      {'label': 'Avg Package', 'key': 'avgPackage', 'icon': Icons.trending_up},
      {'label': 'Highest Package', 'key': 'highestPackage', 'icon': Icons.arrow_upward},
      {'label': 'Placement', 'key': 'placement', 'icon': Icons.people},
      {'label': 'NAAC', 'key': 'naac', 'icon': Icons.verified},
      {'label': 'Rating', 'key': 'rating', 'icon': Icons.star},
      {'label': 'Ranking', 'key': 'ranking', 'icon': Icons.leaderboard},
      {'label': 'Reviews', 'key': 'reviews', 'icon': Icons.reviews},
      {'label': 'Best Feature', 'key': 'bestFeature', 'icon': Icons.emoji_events},
      {'label': 'Hostel', 'key': 'hostel', 'icon': Icons.bed},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Colleges'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: compareList.isEmpty
          ? const Center(child: Text('No colleges selected'))
          : Column(
              children: [
                // Colleges header
                Container(
                  color: const Color(0xFFE3F2FD),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const SizedBox(width: 110),
                      ...compareList.map((c) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1565C0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    (c['name'] ?? '?')[0],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    c['name'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                // Table
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: features.asMap().entries.map((entry) {
                        final i = entry.key;
                        final f = entry.value;
                        final key = f['key'] as String;
                        final label = f['label'] as String;
                        final icon = f['icon'] as IconData;

                        return Container(
                          color: i % 2 == 0 ? Colors.white : const Color(0xFFF5F7FA),
                          child: Row(
                            children: [
                              // Feature label
                              SizedBox(
                                width: 110,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Icon(icon, size: 14, color: const Color(0xFF1565C0)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          label,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            color: Color(0xFF1A237E),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // College values
                              ...compareList.map((c) {
                                String display = '';
                                final val = c[key];

                                if (val == null) {
                                  display = 'N/A';
                                } else if (key == 'fees') {
                                  final f = (val as num).toDouble();
                                  display = f >= 100000
                                      ? '₹${(f / 100000).toStringAsFixed(1)}L'
                                      : '₹${f.toInt()}';
                                } else if (key == 'avgPackage' || key == 'highestPackage') {
                                  display = '$val LPA';
                                } else if (key == 'hostel') {
                                  display = (val as bool) ? '✅ Yes' : '❌ No';
                                } else if (key == 'rating') {
                                  display = '⭐ $val';
                                } else {
                                  display = val.toString();
                                }

                                Color? textColor;
                                if (key == 'naac') {
                                  textColor = _getNaacColor(val?.toString() ?? 'B');
                                }

                                return Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      display,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textColor ?? Colors.black87,
                                        fontWeight: textColor != null
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
