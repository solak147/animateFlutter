import 'package:animate/firebase/firestore_database.dart';
import 'package:animate/firebase/user_repository.dart';
import 'package:animate/home/trailer_widget.dart';
import 'package:animate/youtube/bloc/youtube_bloc.dart';
import 'package:animate/youtube/bloc/youtube_event.dart';
import 'package:animate/youtube/bloc/youtube_state.dart';
import 'package:animate/youtube/youtube_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  final posterPath;
  final overview;
  final releaseDate;
  final title;
  final voteAverage;
  final movieId;

  MovieDetailPage(
      {Key key,
        this.posterPath,
        this.overview,
        this.releaseDate,
        this.title,
        this.voteAverage,
        this.movieId})
      : super(key: key);
  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  String get posterPath => widget.posterPath;
  String get overview => widget.overview;
  String get releaseDate => widget.releaseDate;
  String get title => widget.title;
  String get voteAverage => widget.voteAverage.toString();
  String get movieId => widget.movieId.toString();

  bool isOverviewSelected = false;
  bool isSubmitEnable = false;
  YoutubeBloc _youtubeBloc;
  YoutubeRepository _youtubeRepository;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    _youtubeRepository = YoutubeRepository();
    _youtubeBloc = YoutubeBloc(youtubeRepository: _youtubeRepository);
    _youtubeBloc.dispatch(SearchYoutubeEvent("$title 預告片"));
    _inputController.addListener(_onInputChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: false,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    "https://image.tmdb.org/t/p/w500${posterPath}",
                    fit: BoxFit.cover,
                  )),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(margin: EdgeInsets.only(top: 5.0)),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 1.0, right: 1.0),
                      ),
                      Text(
                        voteAverage,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.0, right: 50.0),
                      ),
                      Text(
                        "上映日期：${releaseDate}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                  isOverviewSelected
                      ? GestureDetector(
                    onTap: () => setState(() {
                      isOverviewSelected = !isOverviewSelected;
                    }),
                    child: Text(overview),
                  )
                      : GestureDetector(
                    onTap: () => setState(() {
                      isOverviewSelected = !isOverviewSelected;
                    }),
                    child: Column(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 200),
                          child: Text(
                            overview,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_drop_down),
                            Text('閱讀全文'),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                  Text(
                    "Trailer",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                  BlocBuilder(
                    bloc: _youtubeBloc,
                    builder: (context, state) {
                      if (state is YoutubeSuccessState) {
                        return trailerWidget(state.ytResult);
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },
                  ),
                  Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                  Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    title: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.comment), labelText: '留言'),
                    ),
                    trailing: IconButton(
                        onPressed: isSubmitEnable
                            ? () async {
                          String email =
                          await new UserRepository().getUser();
                          createRecord(
                              movieId, email, _inputController.text);
                          _inputController.clear();
                        }
                            : null,
                        icon: Icon(Icons.subdirectory_arrow_left)),
                  ),
                  Container(
                    child: getComments(movieId),
                  )
                ],
              ),
            )
          ])),
    );
  }

  void _onInputChanged() {
    if (_inputController.text.isNotEmpty) {
      setState(() {
        isSubmitEnable = true;
      });
    } else {
      setState(() {
        isSubmitEnable = false;
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

}