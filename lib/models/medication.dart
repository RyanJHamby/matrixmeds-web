class Medication {
  final String id;
  final String name;
  final String? genericName;
  final String? description;
  final List<String> dosageForms;
  final List<String> activeIngredients;
  final List<String> warnings;
  final List<String> sideEffects;
  final String manufacturer;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Medication({
    required this.id,
    required this.name,
    this.genericName,
    this.description,
    required this.dosageForms,
    required this.activeIngredients,
    required this.warnings,
    required this.sideEffects,
    required this.manufacturer,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      genericName: json['generic_name'],
      description: json['description'],
      dosageForms: List<String>.from(json['dosage_forms'] ?? []),
      activeIngredients: List<String>.from(json['active_ingredients'] ?? []),
      warnings: List<String>.from(json['warnings'] ?? []),
      sideEffects: List<String>.from(json['side_effects'] ?? []),
      manufacturer: json['manufacturer'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'generic_name': genericName,
      'description': description,
      'dosage_forms': dosageForms,
      'active_ingredients': activeIngredients,
      'warnings': warnings,
      'side_effects': sideEffects,
      'manufacturer': manufacturer,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class MedicationList {
  final List<Medication> items;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  MedicationList({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory MedicationList.fromJson(Map<String, dynamic> json) {
    return MedicationList(
      items: List<Medication>.from(
        json['items'].map((item) => Medication.fromJson(item)),
      ),
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      hasMore: json['has_more'],
    );
  }
}
