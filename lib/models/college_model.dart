class College {
  final String id;
  final String name;
  final String city;
  final String state;
  final String type;
  final List<String> branches;
  final double fees;
  final double avgPlacement;
  final double highestPlacement;
  final bool hostel;

  College({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.type,
    required this.branches,
    required this.fees,
    required this.avgPlacement,
    required this.highestPlacement,
    required this.hostel,
  });

  factory College.fromMap(String id, Map<String, dynamic> data) {
    return College(
      id: id,
      name: data['name'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      type: data['type'] ?? '',
      branches: List<String>.from(data['branches'] ?? []),
      fees: (data['fees'] ?? 0).toDouble(),
      avgPlacement: (data['avgPlacement'] ?? 0).toDouble(),
      highestPlacement: (data['highestPlacement'] ?? 0).toDouble(),
      hostel: data['hostel'] ?? false,
    );
  }
}