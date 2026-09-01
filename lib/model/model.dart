class Musica {
  final int? id;
  final String titulo;
  final String artista;
  final String? album;
  final int? ano;

  Musica({
    this.id,
    required this.titulo,
    required this.artista,
    this.album,
    this.ano,
  });

  /// Converte um JSON (Map<String, dynamic>) em uma instância da classe Musica
  factory Musica.fromJson(Map<String, dynamic> json) {
    return Musica(
      id: json['id'] as int?,
      titulo: json['titulo'] as String? ?? '',
      artista: json['artista'] as String? ?? '',
      album: json['album'] as String?,
      ano: json['ano'] as int?,
    );
  }

  /// Converte a instância de Musica em um Map JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'titulo': titulo,
      'artista': artista,
    };

    if (id != null) {
      data['id'] = id;
    }
    if (album != null) {
      data['album'] = album;
    }
    if (ano != null) {
      data['ano'] = ano;
    }

    return data;
  }
}
