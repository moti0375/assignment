import 'package:flutter/material.dart';
import 'package:moti_assignment/data/app_repository.dart';
import 'package:moti_assignment/model/photo.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<AppRepository>(context, listen: false).fetchPhotos(force: true).then((value) {
            setState(() {});
          });
          return;
        },
        child: Center(
          child: FutureBuilder(
            future: Provider.of<AppRepository>(context).fetchPhotos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data is List<Photo>) {
                  print("${snapshot.data}");
                  List<Photo> photos = snapshot.data ?? [];
                  return ListView.builder(
                      itemCount: photos.length ?? 0,
                      itemBuilder: (BuildContext context, int index) => Dismissible(
                            onDismissed: (direction) {
                              Provider.of<AppRepository>(context, listen: false)
                                  .deletePhoto(photos[index])
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            key: UniqueKey(),
                            child: InkWell(
                              onTap: () => _showEditDialog(photos[index], context),
                              child: ListTile(
                                leading: Image.network(photos[index].thumbnailUrl),
                                title: Text(photos[index].title),
                                trailing: InkWell(
                                  onTap: () => _share(photos[index]),
                                  child: Icon(Icons.share),
                                ),
                              ),
                            ),
                          ));
                }
              }

              if (snapshot.error != null) {
                print("Something went wrong: ${snapshot.error.toString()}");
                return Center(
                  child: Text("Something went wrong.."),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showEditDialog(Photo photo, BuildContext context) async {
    TextEditingController controller = TextEditingController(text: photo.title);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Edit Photo"),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: "Set new content"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("CANCEL")),
                TextButton(
                    onPressed: () {
                      Photo p = photo.cloneWithTitle(title: controller.text);
                      Provider.of<AppRepository>(context, listen: false).updatePhoto(p).then((value) {
                        setState(() {});
                      });
                      Navigator.of(context).pop();
                      print("New photo: ${p.title}");
                    },
                    child: Text("SUBMIT")),
              ],
            ));
    print("About to edit photo: $photo");
  }

  void _share(Photo photo) async {
    await WhatsappShare.isInstalled().then((value) async =>
        WhatsappShare.share(
            text: photo.title,
            linkUrl: photo.thumbnailUrl,
            phone: '*1234'
        )
    );
  }
}
