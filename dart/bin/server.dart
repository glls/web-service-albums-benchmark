import 'dart:convert';
import 'dart:io';

class Album {
  String id;
  String title;
  String artist;
  double price;

  Album(this.id, this.title, this.artist, this.price);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'price': price,
    };
  }
}

List<Album> albums = [];
String albumsJson = '';

void main() async {
  // Read the albums data from the file at the beginning
  final albumsFilePath = '../albums.json';
  final albumsFile = File(albumsFilePath);
  final albumsContent = await albumsFile.readAsString();
  final decodedAlbums = jsonDecode(albumsContent) as List<dynamic>;
  albums = decodedAlbums
      .map((json) => Album(
          json['ID'], json['Title'], json['Artist'], json['Price'].toDouble()))
      .toList();
  albumsJson = jsonEncode(albums.map((album) => album.toJson()).toList());

  // Start the HTTP server
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8000);
  print('Server running on ${server.address.host}:${server.port}');

  // Listen for incoming requests
  await for (final request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  if (request.method == 'GET') {
    if (request.uri.path == '/albums') {
      handleGetAlbums(request);
    } else if (request.uri.path.startsWith('/albums/')) {
      handleGetAlbumById(request);
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not found')
        ..close();
    }
  } else {
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..write('Method not allowed')
      ..close();
  }
}

void handleGetAlbums(HttpRequest request) {
  request.response
    ..headers.contentType = ContentType.json
    ..write(albumsJson)
    ..close();
}

void handleGetAlbumById(HttpRequest request) {
  final albumId = request.uri.pathSegments.last;
  final album = albums.firstWhere((album) => album.id == albumId);

  request.response
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(album.toJson()))
    ..close();
}
