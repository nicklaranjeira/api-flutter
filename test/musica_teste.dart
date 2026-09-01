import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:camada_service/model/model.dart';
import 'package:camada_service/service/service.dart';

void main() {
  late MusicaApi api;

  setUp(() {
    api = MusicaApi();
    api.onInit();
  });

  test('Listar músicas', () async {
    final response = await api.listarMusicas();

    expect(response.isOk, true);
    expect(response.body, isA<List<Musica>>());
  });

  test('Buscar música por ID', () async {
    final response = await api.buscarMusica(1);

    expect(response.isOk, true);
    expect(response.body, isA<Musica>());
  });

  test('Cadastrar música', () async {
    final musica = Musica(
      id: 0,
      titulo: 'Música de teste',
      artista: 'Artista de teste',
    );

    final response = await api.cadastrarMusica(musica);

    expect(response.isOk, true);
  });

  test('Atualizar música', () async {
    final musica = Musica(
      id: 1,
      titulo: 'Música atualizada',
      artista: 'Artista atualizado',
    );

    final response = await api.atualizarMusica(musica);

    expect(response.isOk, true);
  });

  test('Excluir música', () async {
    final response = await api.excluirMusica(1);

    expect(response.isOk, true);
  });

  test('fromJson deve converter JSON para Musica', () {
    final json = {
      'id': 1,
      'titulo': 'Blinding Lights',
      'artista': 'The Weeknd',
      'album': 'After Hours',
      'ano': 2020,
    };

    final musica = Musica.fromJson(json);

    expect(musica.id, 1);
    expect(musica.titulo, 'Blinding Lights');
    expect(musica.artista, 'The Weeknd');
    expect(musica.album, 'After Hours');
    expect(musica.ano, 2020);
  });

  test('toJson deve converter Musica para JSON', () {
    final musica = Musica(
      id: 1,
      titulo: 'Blinding Lights',
      artista: 'The Weeknd',
      album: 'After Hours',
      ano: 2020,
    );

    final json = musica.toJson();

    expect(json['id'], 1);
    expect(json['titulo'], 'Blinding Lights');
    expect(json['artista'], 'The Weeknd');
    expect(json['album'], 'After Hours');
    expect(json['ano'], 2020);
  });

  test('JSON -> Musica -> JSON deve manter os dados', () {
    final jsonOriginal = {
      'id': 1,
      'titulo': 'Blinding Lights',
      'artista': 'The Weeknd',
      'album': 'After Hours',
      'ano': 2020,
    };

    // JSON -> Musica
    final musica = Musica.fromJson(jsonOriginal);

    // Musica -> JSON
    final jsonFinal = musica.toJson();

    expect(jsonFinal, equals(jsonOriginal));
  });
}
