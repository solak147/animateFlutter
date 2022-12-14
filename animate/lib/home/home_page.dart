import 'package:animate/movie/bloc/movie_bloc.dart';
import 'package:animate/movie/bloc/movie_event.dart';
import 'package:animate/movie/bloc/movie_state.dart';
import 'package:animate/movie/movie_repository.dart';
import 'package:flutter/material.dart';
import '../authentication_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'show_movie_widget.dart';
import '../firebase/upload_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../firebase/firestore_database.dart';

class HomePage extends StatefulWidget {
  final String email;
  HomePage({Key key, this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieBloc _movieBloc;
  final MovieRepository _movieRepository = MovieRepository();
  int _selectIndex = 0;

  @override
  void initState() {
    _movieBloc = MovieBloc(movieRepository: _movieRepository);
    _movieBloc.dispatch(FetchTopRated(region: 'TW'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onTap(int index) {
      setState(() {
        _selectIndex = index;
      });

      switch (index) {
        case 0:
          _movieBloc.dispatch(FetchPopular(region: 'TW'));
          break;
        case 1:
          _movieBloc.dispatch(FetchNowPlaying(region: 'TW'));
          break;
        case 2:
          _movieBloc.dispatch(FetchTopRated(region: 'TW'));
          break;
      }
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF1b1e44),
                Color(0xFF2d3447),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        drawer: SideDrawer(
          email: widget.email,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.star), title: Text('Popular')),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_filled),
                title: Text('Now Playing')),
            BottomNavigationBarItem(
                icon: Icon(Icons.thumb_up), title: Text('Top Rated')),
          ],
          backgroundColor: Colors.amberAccent,
          onTap: _onTap,
          currentIndex: _selectIndex,
        ),
        backgroundColor: Colors.transparent,
        body: BlocBuilder(
          bloc: _movieBloc,
          builder: (context, state) {
            if (state is LoadingMovie) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is InitMovieState) {
              return Center(
                child: Text('Init Movie'),
              );
            } else if (state is PopularMovieState) {
              return ShowMovieWidget(
                movieList: state.movieList,
                category: 'Popular',
              );
            } else if (state is NowPlayingMovieState) {
              return ShowMovieWidget(
                movieList: state.movieList,
                category: 'Now Playing',
              );
            } else if (state is TopRatedMovieState) {
              return ShowMovieWidget(
                movieList: state.movieList,
                category: 'Top Rated',
              );
            }
            return Center(
              child: Text('Failed'),
            );
          },
        ),
      ),
    );
  }
}

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  MovieBloc _movieBloc;
  final MovieRepository _movieRepository = MovieRepository();

  @override
  void initState() {
    _movieBloc = MovieBloc(movieRepository: _movieRepository);
    _movieBloc.dispatch(FetchPopular(region: 'TW'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _movieBloc,
      builder: (context, state) {
        if (state is LoadingMovie) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FailedFetchData) {
          return Center(
            child: Text('Failed'),
          );
        } else if (state is InitMovieState) {
          return Center(
            child: Text('Init Movie'),
          );
        }
        return buildList(state.movieList);
      },
    );
  }
}

Widget buildList(movieList) {
  return GridView.builder(
      itemCount: movieList.results.length,
      gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
            child: InkResponse(
              enableFeedback: true,
              child: Image.network(
                'https://image.tmdb.org/t/p/w185${movieList.results[index].posterPath}',
                fit: BoxFit.cover,
              ),
            ));
      });
}

class SideDrawer extends StatefulWidget {
  final String email;
  SideDrawer({Key key, this.email}) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

  String imagePath;
  String get email => widget.email;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: FutureBuilder<String>(
                future: getProfilePictureUrl(email),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                      break;
                    case ConnectionState.done:
                      if(snapshot.data != null)
                        return Image.network(snapshot.data);
                      return Container();
                  }
                  return null;
                },
              ),
              accountEmail: Text(email),
              decoration: BoxDecoration(color: Colors.brown),
            ),
            ListTile(
              leading: Icon(Icons.file_upload),
              title: Text('Profile picture'),
              onTap: () async {

                File image =
                await ImagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  var uploadTask = uploadImage(image, email);
                  await uploadTask.onComplete;
                  String url = await uploadTask.lastSnapshot.ref.getDownloadURL();
                  await updateProfilePictureUrl(email, url);
                }

                setState(() { });

              },
            ),
            ListTile(
              leading: Icon(Icons.sentiment_satisfied),
              title: Text('Rate Our App'),
              onTap: () {
                Navigator.of(context).pop();
                _asyncScoreDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log out"),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .dispatch(LoggedOut());
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About"),
              onTap: () {
                SnackBar snackbar = SnackBar(
                  content: Text('????????????????????????????????????\n??????????????????????????????TMDb?????????'),
                  duration: Duration(seconds: 5),
                );
                Scaffold.of(context).showSnackBar(snackbar);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _asyncScoreDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('??????FlutTube????'),
        content: const Text('???????????????FlutTube??????????????????????????????????????????!'),
        actions: <Widget>[
          FlatButton(
            child: const Text('??????'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: const Text('???!'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}


