class FlashCard {
  final String id;
  final String titulo;
  final String definicion;
  final String ejemplo;

  FlashCard({
    required this.id,
    required this.titulo,
    required this.definicion,
    required this.ejemplo,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      id: json['id'],
      titulo: json['titulo'],
      definicion: json['definicion'],
      ejemplo: json['ejemplo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'definicion': definicion,
      'ejemplo': ejemplo,
    };
  }
}
