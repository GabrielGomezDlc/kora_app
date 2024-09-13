class RecommendedTechnique {
  final int recommendedTechniqueId;

  RecommendedTechnique({required this.recommendedTechniqueId});

  // Método para convertir un JSON en un objeto RecommendationPrediction
  factory RecommendedTechnique.fromJson(Map<String, dynamic> json) {
    return RecommendedTechnique(
      recommendedTechniqueId: json['Tecnica_Recomendada_ID'],
    );
  }
}
