import 'package:get/get.dart';
import '../model/model.dart';

class MusicaApi extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'http://10.0.2.2:8000';

    httpClient.defaultDecoder = (map) {
      if (map is List) {
        return map.map((item) => Musica.fromJson(item)).toList();
      }

      if (map is Map<String, dynamic>) {
        return Musica.fromJson(map);
      }

      return map;
    };

    super.onInit();
  }

  // GET /musicas
  Future<Response<List<Musica>>> listarMusicas() async {
    return await get<List<Musica>>('/musicas');
  }

  // GET /musicas/{id}
  Future<Response<Musica>> buscarMusica(int id) async {
    return await get<Musica>('/musicas/$id');
  }

  // POST /musicas
  Future<Response<Musica>> cadastrarMusica(Musica musica) async {
    return await post('/musicas', musica.toJson());
  }

  // PUT /musicas/{id}
  Future<Response<Musica>> atualizarMusica(Musica musica) async {
    return await put('/musicas/${musica.id}', musica.toJson());
  }

  // DELETE /musicas/{id}
  Future<Response> excluirMusica(int id) async {
    return await delete('/musicas/$id');
  }
}
