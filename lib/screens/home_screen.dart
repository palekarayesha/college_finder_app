import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'compare_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF0288D1), Color(0xFF26C6DA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CollegeFinder',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'SPPU & Shivaji University Colleges',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Find Your\nDream College',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Search, filter and compare top engineering\ncolleges in Pune & Kolhapur',
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),

              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _buildStat('42+', 'Colleges'),
                    const SizedBox(width: 16),
                    _buildStat('10+', 'Branches'),
                    const SizedBox(width: 16),
                    _buildStat('100%', 'Free'),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Main Content Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'What would you like to do?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildActionCard(
                          context,
                          icon: Icons.search,
                          title: 'Search & Filter Colleges',
                          subtitle: 'Filter by branch, fees, NAAC, type & more',
                          color: const Color(0xFF1565C0),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SearchScreen()),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildActionCard(
                          context,
                          icon: Icons.compare_arrows,
                          title: 'Compare Colleges',
                          subtitle: 'Select colleges and compare side by side',
                          color: const Color(0xFF00897B),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CompareScreen(colleges: [], fromHome: true),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildActionCard(
                          context,
                          icon: Icons.auto_awesome,
                          title: 'Get Recommendations',
                          subtitle: 'Smart suggestions based on your preferences',
                          color: const Color(0xFFE65100),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchScreen(openRecommend: true),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline, color: Color(0xFF1565C0), size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Decision-support system. Not for admission booking.',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF1565C0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}