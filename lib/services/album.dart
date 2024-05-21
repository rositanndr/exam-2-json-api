import 'dart:convert';
import 'package:exam2/models/user.dart';
import 'package:http/http.dart' as http;

class AlbumServices {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/albums/1/photos';

  static Future<List<Album>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl'));
      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);

        List<Album> albums = 
        result.map((albumjson) => Album.fromJson(albumjson)).toList();
        return albums;
      } else {
        throw Exception('failed to load albums');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> addAlbum(Album album) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type' : 'application/json'},
        body: jsonEncode({
          'albumId' : album.albumId,
          'title': album.title,
          'url' : album.url,
          'thumbnailUrl' : album.thumbnailUrl,
        })
      );
      if  (response.statusCode != 201) {
        throw Exception('failed to add album');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> editAlbum(Album album) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${album.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId' : album.albumId,
          'title': album.title,
          'url' : album.url,
          'thumbnailUrl' : album.thumbnailUrl,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('failed to update album');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> deleteAlbum(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('failed to delete album');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}