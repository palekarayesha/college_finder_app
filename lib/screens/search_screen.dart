import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'college_details_screen.dart';
import 'compare_screen.dart';

class SearchScreen extends StatefulWidget {
  final bool openRecommend;
  const SearchScreen({super.key, this.openRecommend = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> colleges = [];
  List<Map<String, dynamic>> filtered = [];
  List<Map<String, dynamic>> selected = [];

  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  String selectedCity = 'All';
  String selectedType = 'All';
  String selectedBranch = 'All';
  String selectedNAAC = 'All';
  double maxFees = 2200000;
  String sortBy = 'Name';
  bool isLoading = true;
  bool showFilters = false;

  final List<String> cities = ['All', 'Pune', 'Kolhapur', 'Sangli', 'Yadrav'];
  final List<String> types = ['All', 'Government', 'Private'];
  final List<String> branches = ['All', 'CSE', 'IT', 'AI', 'Mechanical', 'Civil', 'ENTC'];
  final List<String> naacOptions = ['All', 'A++', 'A+', 'A', 'B++', 'B+', 'B'];
  final List<String> sortOptions = ['Name', 'Fees (Low-High)', 'Fees (High-Low)', 'Avg Package', 'Rating', 'Ranking'];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await DataService.loadColleges();
    setState(() {
      colleges = data;
      filtered = data;
      isLoading = false;
    });
    applyFilter();
    if (widget.openRecommend) {
      Future.delayed(const Duration(milliseconds: 300), showRecommendations);
    }
  }

  void applyFilter() {
    List<Map<String, dynamic>> temp = colleges.where((c) {
      final name = (c['name'] ?? '').toString().toLowerCase();
      final bool searchMatch = name.contains(searchText.toLowerCase());
      final bool cityMatch = selectedCity == 'All' || c['city'] == selectedCity;
      final bool typeMatch = selectedType == 'All' || c['type'] == selectedType;
      final bool feeMatch = (c['fees'] as num).toDouble() <= maxFees;
      final bool naacMatch = selectedNAAC == 'All' || c['naac'] == selectedNAAC;
      final bool branchMatch = selectedBranch == 'All' ||
          (c['branches'] != null &&
              (c['branches'] as List).contains(selectedBranch));

      return searchMatch && cityMatch && typeMatch && feeMatch && naacMatch && branchMatch;
    }).toList();

    // Sort
    switch (sortBy) {
      case 'Fees (Low-High)':
        temp.sort((a, b) => (a['fees'] as num).compareTo(b['fees'] as num));
        break;
      case 'Fees (High-Low)':
        temp.sort((a, b) => (b['fees'] as num).compareTo(a['fees'] as num));
        break;
      case 'Avg Package':
        temp.sort((a, b) => (b['avgPackage'] as num).compareTo(a['avgPackage'] as num));
        break;
      case 'Rating':
        temp.sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
        break;
      case 'Ranking':
        temp.sort((a, b) {
          final aRank = int.tryParse((a['ranking'] ?? '999/500').split('/')[0]) ?? 999;
          final bRank = int.tryParse((b['ranking'] ?? '999/500').split('/')[0]) ?? 999;
          return aRank.compareTo(bRank);
        });
        break;
      default:
        temp.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
    }

    setState(() => filtered = temp);
  }

  List<Map<String, dynamic>> getRecommendations() {
    List<Map<String, dynamic>> temp = List.from(filtered);
    temp.sort((a, b) {
      final double scoreA = (a['avgPackage'] as num).toDouble() * 2 +
          (a['rating'] as num).toDouble() * 10 -
          (a['fees'] as num).toDouble() / 100000;
      final double scoreB = (b['avgPackage'] as num).toDouble() * 2 +
          (b['rating'] as num).toDouble() * 10 -
          (b['fees'] as num).toDouble() / 100000;
      return scoreB.compareTo(scoreA);
    });
    return temp.take(5).toList();
  }

  void showRecommendations() {
    final top = getRecommendations();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: Color(0xFFE65100), size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Top Recommendations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Based on packages, ratings & fees:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...top.asMap().entries.map((entry) {
              final i = entry.key;
              final c = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: i == 0 ? const Color(0xFFFFF8E1) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: i == 0
                      ? Border.all(color: const Color(0xFFFFB300), width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    Text('${i + 1}.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: i == 0 ? const Color(0xFFE65100) : Colors.grey,
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['name'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text(
                            '₹${(c['fees'] as num).toInt()} • ${c['avgPackage']} LPA • ⭐${c['rating']}',
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatFees(double fees) {
    if (fees >= 100000) {
      return '₹${(fees / 100000).toStringAsFixed(1)}L';
    }
    return '₹${fees.toInt()}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text('Search Colleges', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (selected.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: selected.length < 2
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CompareScreen(colleges: selected),
                          ),
                        );
                      },
                icon: const Icon(Icons.compare_arrows, color: Colors.white, size: 18),
                label: Text(
                  'Compare (${selected.length})',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search + Filter bar
          Container(
            color: const Color(0xFF1565C0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search Box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) {
                      searchText = val;
                      applyFilter();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search colleges...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                searchController.clear();
                                searchText = '';
                                applyFilter();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Filter Toggle
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => showFilters = !showFilters),
                        icon: Icon(
                          showFilters ? Icons.filter_list_off : Icons.filter_list,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          showFilters ? 'Hide Filters' : 'Show Filters',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: showRecommendations,
                        icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                        label: const Text('Recommend', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          backgroundColor: Colors.white24,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filters Panel
          if (showFilters)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildDropdown('City', selectedCity, cities, (v) { selectedCity = v!; applyFilter(); })),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdown('Type', selectedType, types, (v) { selectedType = v!; applyFilter(); })),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildDropdown('Branch', selectedBranch, branches, (v) { selectedBranch = v!; applyFilter(); })),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdown('NAAC', selectedNAAC, naacOptions, (v) { selectedNAAC = v!; applyFilter(); })),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Max Fees: ', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(_formatFees(maxFees),
                          style: const TextStyle(
                              color: Color(0xFF1565C0), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: maxFees,
                    min: 50000,
                    max: 2200000,
                    divisions: 20,
                    activeColor: const Color(0xFF1565C0),
                    onChanged: (val) {
                      setState(() => maxFees = val);
                      applyFilter();
                    },
                  ),
                  Row(
                    children: [
                      const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: sortBy,
                          isExpanded: true,
                          items: sortOptions
                              .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
                              .toList(),
                          onChanged: (v) {
                            sortBy = v!;
                            applyFilter();
                          },
                        ),
                      ),
                    ],
                  ),
                  if (selected.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton.icon(
                        onPressed: selected.length < 2 ? null : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CompareScreen(colleges: selected),
                            ),
                          );
                        },
                        icon: const Icon(Icons.compare_arrows),
                        label: Text('Compare ${selected.length} Selected'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          minimumSize: const Size(double.infinity, 44),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filtered.length} colleges found',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                if (selected.isNotEmpty) ...[
                  const Spacer(),
                  Text(
                    '${selected.length} selected for compare',
                    style: const TextStyle(color: Color(0xFF00897B), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            ),
          ),

          // List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off, size: 60, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('No colleges match your filters',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final c = filtered[i];
                          final isSelected = selected.contains(c);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(color: const Color(0xFF00897B), width: 2)
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CollegeDetailScreen(college: c),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // College Icon
                                        Container(
                                          width: 46,
                                          height: 46,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE3F2FD),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              (c['name'] ?? '?')[0],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1565C0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                c['name'] ?? '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on,
                                                      size: 13, color: Colors.grey),
                                                  Text(
                                                    ' ${c['city']} • ${c['type']}',
                                                    style: const TextStyle(
                                                        color: Colors.grey, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Compare checkbox
                                        Checkbox(
                                          value: isSelected,
                                          activeColor: const Color(0xFF00897B),
                                          onChanged: (val) {
                                            setState(() {
                                              if (val == true) {
                                                if (selected.length < 4) {
                                                  selected.add(c);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Max 4 colleges for comparison'),
                                                      duration: Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                selected.remove(c);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Stats Row
                                    Row(
                                      children: [
                                        _buildStatChip(
                                          Icons.currency_rupee,
                                          _formatFees((c['fees'] as num).toDouble()),
                                          const Color(0xFF1565C0),
                                        ),
                                        const SizedBox(width: 8),
                                        _buildStatChip(
                                          Icons.trending_up,
                                          '${c['avgPackage']} LPA',
                                          const Color(0xFF2E7D32),
                                        ),
                                        const SizedBox(width: 8),
                                        _buildStatChip(
                                          Icons.star,
                                          '${c['rating']}',
                                          const Color(0xFFF57F17),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // NAAC + Branches
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: _getNaacColor(c['naac'] ?? 'B')
                                                .withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'NAAC ${c['naac']}',
                                            style: TextStyle(
                                              color: _getNaacColor(c['naac'] ?? 'B'),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            (c['branches'] as List?)?.take(3).join(', ') ?? '',
                                            style: const TextStyle(
                                                color: Colors.grey, fontSize: 11),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '🏆 ${c['ranking']}',
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, String value, List<String> items, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        isDense: true,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
