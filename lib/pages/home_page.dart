import 'package:flutter/material.dart';
import 'package:moti_assignment/data/app_repository.dart';
import 'package:moti_assignment/model/photo.dart';
import 'package:provider/provider.dart';
class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder(
          future: Provider.of<AppRepository>(context).fetchPhotos(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data is List<Photo>){
                print("${snapshot.data}");
                List<Photo> photos = snapshot.data;
                return ListView.builder(
                    itemCount: photos.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                        leading: Image.network(photos[index].thumbnailUrl),
                        title: Text(photos[index].title))
                );
              }
            }

            if(snapshot.error != null){
              print("Something went wrong: ${snapshot.error.toString()}");
              return Center(
                child: Text("Something went wrong.."),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          } ,

        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
