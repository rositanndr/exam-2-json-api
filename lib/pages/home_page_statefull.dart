import 'package:exam2/models/user.dart';
import 'package:exam2/services/album.dart';
import 'package:flutter/material.dart';

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  List<Album> users = [];
  bool isLoading = true;

  void fetchUsers() async {
    isLoading = true;
  final result = await AlbumServices.fetchUsers();
  users = result;
  setState(() {
    users = result;
  });
  isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void deleteAlbum(int index) async {
    try {
      await AlbumServices.deleteAlbum(users[index].id);
      setState(() {
        users.removeAt(index);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('failed to delete album: $e')), 
      );
    }
  }

  void editAlbum(int index, String newTitle, String newUrl, String newThumbnailUrl) async {
    Album updateAlbum = Album(
      albumId: users[index].albumId,
      id: users[index].id,
      title: users[index].title,
      url: users[index].url,
      thumbnailUrl: users[index].thumbnailUrl,);

      try {
        await AlbumServices.editAlbum(updateAlbum);
        setState(() {
          users[index] = updateAlbum;
        });
      }catch (e) {
        //
      }
  }

  void addAlbum(int albumId, String title, String url, String thumbnailUrl) async {
    Album newAlbum = Album(
      albumId: albumId,
       id: users.isNotEmpty ? users.last.id + 1 : 1, 
       title: title, 
       url: url, 
       thumbnailUrl: thumbnailUrl,
       );

       try {
        await AlbumServices.addAlbum(newAlbum);
        setState(() {
          users.add(newAlbum);
        });
       } catch (e) {
        //
       }
  }

  void showAddDialog(BuildContext context) {
    TextEditingController albumIdController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController urlController = TextEditingController();
    TextEditingController thumbnailUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Album'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: albumIdController,
                decoration: InputDecoration(labelText: 'Album ID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: thumbnailUrlController,
                decoration: InputDecoration(labelText: 'Thumbnail URL'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(54, 67, 244, 1)), 
                foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)), 
              ),
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(54, 67, 244, 1)), 
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), 
              ),
              child: Text('Tambah'),
              onPressed: () {
                addAlbum(
                  int.parse(albumIdController.text),
                  titleController.text,
                  urlController.text,
                  thumbnailUrlController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(BuildContext context, int index) {
    TextEditingController titleController = TextEditingController(text: users[index].title);
    TextEditingController urlController = TextEditingController(text: users[index].url);
    TextEditingController thumbnailUrlController = TextEditingController(text: users[index].thumbnailUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Album'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: thumbnailUrlController,
                decoration: InputDecoration(labelText: 'Thumbnail URL'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Simpan'),
              onPressed: () {
                editAlbum(index, titleController.text, urlController.text, thumbnailUrlController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Exam JSON & rest API',
        style: TextStyle(
          color: Color.fromRGBO(54, 67, 244, 1),
          fontWeight: FontWeight.w800,
        ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAddDialog(context);
            },
            color: Colors.black,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final albumItem = users[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(albumItem.thumbnailUrl),
              ),
              title: Text('${albumItem.id}. ${albumItem.title}'),
              subtitle: Text(albumItem.url),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit_road_outlined),
                    color: Colors.blue,
                    onPressed: () {
                      showEditDialog(context, index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Color.fromARGB(255, 54, 98, 244),
                    onPressed: () {
                      deleteAlbum(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
   );
  }
}
