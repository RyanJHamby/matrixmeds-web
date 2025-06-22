class Interaction {
  final String id;
  final String medication1;
  final String medication2;
  final String severity;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Interaction({
    required this.id,
    required this.medication1,
    required this.medication2,
    required this.severity,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
      id: json['id'],
      medication1: json['medication1'],
      medication2: json['medication2'],
      severity: json['severity'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication1': medication1,
      'medication2': medication2,
      'severity': severity,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class InteractionCheckResponse {
  final List<Interaction> interactions;
  final bool hasInteractions;

  InteractionCheckResponse({
    required this.interactions,
    required this.hasInteractions,
  });

  factory InteractionCheckResponse.fromJson(Map<String, dynamic> json) {
    return InteractionCheckResponse(
      interactions: List<Interaction>.from(
        json['interactions'].map((interaction) => Interaction.fromJson(interaction)),
      ),
      hasInteractions: json['has_interactions'],
    );
  }
}
