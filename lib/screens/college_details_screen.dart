import 'package:flutter/material.dart';

class CollegeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> college;

  const CollegeDetailScreen({super.key, required this.college});

  @override
  State<CollegeDetailScreen> createState() => _CollegeDetailScreenState();
}

class _CollegeDetailScreenState extends State<CollegeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getNaacColor(String naac) {
    switch (naac) {
      case 'A++':
        return const Color(0xFF1B5E20);
      case 'A+':
        return const Color(0xFF2E7D32);
      case 'A':
        return const Color(0xFF388E3C);
      case 'B++':
        return const Color(0xFFF57F17);
      case 'B+':
        return const Color(0xFFFF8F00);
      default:
        return const Color(0xFFBF360C);
    }
  }

  String _formatFees(num fees) {
    if (fees >= 100000) {
      return '₹${(fees / 100000).toStringAsFixed(2)} Lakhs';
    }
    return '₹$fees';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.college;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // Hero App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1565C0), Color(0xFF0288D1)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                (c['name'] ?? '?')[0],
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['name'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${c['city']}, ${c['state']}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickStat('Avg Package', '${c['avgPackage']} LPA', const Color(0xFF2E7D32)),
                  _divider(),
                  _buildQuickStat('Highest', '${c['highestPackage']} LPA', const Color(0xFF1565C0)),
                  _divider(),
                  _buildQuickStat('Rating', '⭐ ${c['rating']}/5', const Color(0xFFF57F17)),
                  _divider(),
                  _buildQuickStat('Placement', c['placement'] ?? 'N/A', const Color(0xFF00897B)),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF1565C0),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF1565C0),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Academics'),
                  Tab(text: 'Placements'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(c),
                _buildAcademicsTab(c),
                _buildPlacementsTab(c),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('General Information'),
          _infoRow(Icons.location_city, 'City', c['city'] ?? ''),
          _infoRow(Icons.map, 'State', c['state'] ?? ''),
          _infoRow(Icons.account_balance, 'Type', c['type'] ?? ''),
          _infoRow(Icons.school, 'University', c['university'] ?? ''),
          _infoRow(Icons.bed, 'Hostel', (c['hostel'] as bool? ?? false) ? 'Available' : 'Not Available'),

          const SizedBox(height: 16),
          _sectionTitle('Ranking & Recognition'),
          _infoRow(Icons.leaderboard, 'Ranking', c['ranking'] ?? ''),
          _infoRow(Icons.score, 'CD Score', '${c['cdScore'] ?? 'N/A'}'),
          _infoRow(Icons.star, 'Rating', '${c['rating']}/5 (${c['reviews']} reviews)'),
          _infoRow(Icons.emoji_events, 'Best Feature', c['bestFeature'] ?? ''),

          const SizedBox(height: 16),
          _sectionTitle('Approvals'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ((c['approval'] as List?) ?? []).map((a) {
              return Chip(
                label: Text(a.toString(), style: const TextStyle(fontSize: 12)),
                backgroundColor: const Color(0xFFE3F2FD),
                labelStyle: const TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w600),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          // NAAC Badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getNaacColor(c['naac'] ?? 'B').withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getNaacColor(c['naac'] ?? 'B').withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, color: _getNaacColor(c['naac'] ?? 'B'), size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NAAC Grade: ${c['naac'] ?? 'N/A'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getNaacColor(c['naac'] ?? 'B'),
                        fontSize: 16,
                      ),
                    ),
                    const Text('National Assessment & Accreditation',
                        style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicsTab(Map<String, dynamic> c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Fee Structure'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0288D1)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Course Fees', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text('(Approx. 4 years)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
                Text(
                  _formatFees(c['fees'] as num),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _sectionTitle('Branches Offered'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ((c['branches'] as List?) ?? []).map((b) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
                ),
                child: Text(
                  b.toString(),
                  style: const TextStyle(
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacementsTab(Map<String, dynamic> c) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Placement Statistics'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _placementCard(
                  'Avg Package',
                  '${c['avgPackage']} LPA',
                  Icons.trending_up,
                  const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _placementCard(
                  'Highest Package',
                  '${c['highestPackage']} LPA',
                  Icons.arrow_upward,
                  const Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _placementCard(
                  'Placement Rate',
                  c['placement'] ?? 'N/A',
                  Icons.people,
                  const Color(0xFF00897B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _placementCard(
                  'Student Reviews',
                  '${c['reviews']} reviews',
                  Icons.reviews,
                  const Color(0xFFF57F17),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          _sectionTitle('Highlights'),
          _infoRow(Icons.emoji_events, 'Best Known For', c['bestFeature'] ?? 'N/A'),
          _infoRow(Icons.leaderboard, 'National Ranking', c['ranking'] ?? 'N/A'),
          _infoRow(Icons.star_rate, 'Student Rating', '${c['rating']}/5'),
        ],
      ),
    );
  }

  Widget _placementCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(title,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF1A237E),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1565C0)),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade200);
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
