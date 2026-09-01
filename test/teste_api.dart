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

  // 10 - TESTE: LISTAR MÚSICAS

  test('GET /musicas - deve listar músicas', () async {
    final response = await api.listarMusicas();

    // Verifica se a requisição foi realizada com sucesso
    expect(response.isOk, true);

    // Verifica se o status HTTP é 200
    expect(response.statusCode, 200);

    // Verifica se a resposta é uma lista
    expect(response.body, isA<List<Musica>>());

    // Verifica se os elementos são Musica
    if (response.body != null) {
      for (final musica in response.body!) {
        expect(musica, isA<Musica>());
      }
    }
  });

  // TESTE: BUSCAR MÚSICA POR ID

  test('GET /musicas/{id} - deve buscar música por ID', () async {
    const id = 1;

    final response = await api.buscarMusica(id);

    // Verifica se a requisição foi realizada com sucesso
    expect(response.isOk, true);

    // Verifica status HTTP 200
    expect(response.statusCode, 200);

    // Verifica se retornou uma Musica
    expect(response.body, isA<Musica>());

    // Verifica se o ID retornado é o mesmo solicitado
    expect(response.body!.id, id);
  });

  // TESTE: ID INEXISTENTE

  test('GET /musicas/{id} - deve retornar 404 para ID inexistente', () async {
    const idInexistente = 999999;

    final response = await api.buscarMusica(idInexistente);

    // Verifica se a API retornou 404
    expect(response.statusCode, 404);
  });

  // 12 - TESTE: CADASTRAR MÚSICA

  test('POST /musicas - deve cadastrar uma música', () async {
    final musica = Musica(
      id: 0,
      titulo: 'Música de teste',
      artista: 'Artista de teste',
      album: 'Álbum de teste',
      ano: 2026,
    );

    final response = await api.cadastrarMusica(musica);

    // Verifica se a requisição foi realizada com sucesso
    expect(response.isOk, true);

    // POST deve retornar 201
    expect(response.statusCode, 201);

    // Verifica se retornou uma Musica
    expect(response.body, isA<Musica>());

    // Verifica se a música recebeu um ID
    expect(response.body!.id, isNot(0));
  });

  // 13 - TESTE: ATUALIZAR MÚSICA

  test('PUT /musicas/{id} - deve atualizar uma música', () async {
    const id = 1;

    final musicaAtualizada = Musica(
      id: id,
      titulo: 'Título atualizado',
      artista: 'Artista atualizado',
      album: 'Álbum atualizado',
      ano: 2026,
    );

    final response = await api.atualizarMusica(musicaAtualizada);

    // Verifica se a requisição foi realizada com sucesso
    expect(response.isOk, true);

    // PUT deve retornar 200
    expect(response.statusCode, 200);

    // Verifica se retornou uma Musica
    expect(response.body, isA<Musica>());

    // Verifica se os dados foram atualizados
    expect(response.body!.id, id);
    expect(response.body!.titulo, 'Título atualizado');
    expect(response.body!.artista, 'Artista atualizado');
    expect(response.body!.album, 'Álbum atualizado');
    expect(response.body!.ano, 2026);
  });

  // 14 - TESTE: EXCLUIR MÚSICA

  test('DELETE /musicas/{id} - deve excluir uma música', () async {
    // Primeiro cadastramos uma música para não apagar
    // uma música importante do banco.
    final musica = Musica(
      id: 0,
      titulo: 'Música para excluir',
      artista: 'Artista teste',
      album: 'Álbum teste',
      ano: 2026,
    );

    final cadastro = await api.cadastrarMusica(musica);

    expect(cadastro.isOk, true);
    expect(cadastro.statusCode, 201);
    expect(cadastro.body, isA<Musica>());

    final id = cadastro.body!.id;

    // Agora excluímos a música
    final response = await api.excluirMusica(id);

    // DELETE pode retornar 200 ou 204
    expect(response.statusCode == 200 || response.statusCode == 204, true);

    // Faz uma nova consulta
    final consulta = await api.buscarMusica(id);

    // A música não deve mais existir
    expect(consulta.statusCode, 404);
  });

  // TESTES DE ERRO

  // Música inexistente
  test(
    'GET /musicas/{id} - deve retornar 404 para música inexistente',
    () async {
      const idInexistente = 999999;

      final response = await api.buscarMusica(idInexistente);

      expect(response.statusCode, 404);
    },
  );

  // Exclusão de música inexistente
  test(
    'DELETE /musicas/{id} - deve retornar erro para música inexistente',
    () async {
      const idInexistente = 999999;

      final response = await api.excluirMusica(idInexistente);

      // A API deve retornar um código de erro.
      // Normalmente será 404.
      expect(response.statusCode, 404);
    },
  );

  // Dados inválidos
  test('POST /musicas - deve rejeitar dados inválidos', () async {
    final musicaInvalida = Musica(
      id: 0,
      titulo: '',
      artista: '',
      album: '',
      ano: 0,
    );

    final response = await api.cadastrarMusica(musicaInvalida);

    // A API deve rejeitar os dados.
    // Pode ser 400, 422 ou outro código de erro
    // dependendo de como sua API Python foi implementada.
    expect(response.isOk, false);
    expect(response.statusCode, isNot(200));
    expect(response.statusCode, isNot(201));
  });
}
