class SoilAnalysisResult {
  final String soilType;
  final double confidence;

  SoilAnalysisResult({
    required this.soilType,
    required this.confidence,
  });

  factory SoilAnalysisResult.fromJson(Map<String, dynamic> json) {
    final prediction = json['predictions'][0];
    return SoilAnalysisResult(
      soilType: prediction['class'],
      confidence: prediction['confidence'],
    );
  }
} 