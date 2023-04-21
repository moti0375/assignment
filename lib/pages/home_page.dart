import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moti_assignment/bloc/base_state/base_bloc_state.dart';
import 'package:moti_assignment/data/app_repository.dart';
import 'package:moti_assignment/model/photo.dart';
import 'package:moti_assignment/pages/home_bloc_state/home_bloc_state.dart';
import 'package:moti_assignment/pages/home_page_cubit.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomePageCubit>().fetchPhotos(refresh: false);
          return;
        },
        child: Center(
          child: BlocBuilder<HomePageCubit, BaseBlocState<HomeBlocState>>(
            builder: (context, baseState) {
              print("BlocBuilder: state: $baseState");
              return baseState.when(
                init: () {
                  context.read<HomePageCubit>().fetchPhotos(refresh: false);
                  return SizedBox.shrink();
                },
                loading: () => Center(child: CircularProgressIndicator()),
                next: (pageState) => _processPageState(pageState),
                error: (error) => Center(
                  child: Text("Something went wrong: ${error.toString()}"),
                ),
              );
            },
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _processPageState(HomeBlocState pageState) {
    return pageState.when(
      photosLoaded: (photos) => ListView.builder(
        itemCount: photos.length,
        itemBuilder: (BuildContext context, int index) => Dismissible(
          onDismissed: (direction) => context.read<HomePageCubit>().deletePhoto(photos[index]),
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
        ),
      ),
    );
  }

  void _showEditDialog(Photo photo, BuildContext buildContext) async {
    TextEditingController controller = TextEditingController(text: photo.title);
    showDialog(
        context: buildContext,
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
                      Photo p = photo.copyWith(title: controller.text);
                      buildContext.read<HomePageCubit>().updatePhoto(p);
                      Navigator.of(context).pop();
                      print("New photo: ${p.title}");
                    },
                    child: Text("SUBMIT")),
              ],
            ));
    print("About to edit photo: $photo");
  }

  void _share(Photo photo) async {
    Share.share("${photo.title}\n${photo.url}");
  }

  static Widget create(String title) {
    return Consumer<AppRepository>(
      builder: (_, repository, __) => BlocProvider<HomePageCubit>(
        create: (_) => HomePageCubit(repository),
        child: MyHomePage(title: title),
      ),
    );
  }
}
