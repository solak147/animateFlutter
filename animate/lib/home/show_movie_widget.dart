import '../movie/movie.dart';
import 'package:flutter/material.dart';
import 'card_scroll_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'movie_detail_page.dart';

class ShowMovieWidget extends StatefulWidget {
  final MovieList _movieList;
  final String _category;
  ShowMovieWidget(
      {Key key, @required MovieList movieList, @override String category})
      : _movieList = movieList,
        _category = category,
        super(key: key);

  @override
  _ShowMovieWidgetState createState() => _ShowMovieWidgetState();
}

class _ShowMovieWidgetState extends State<ShowMovieWidget> {
  var currentPage;
  MovieList get movieList => widget._movieList;
  String get category => widget._category;

  @override
  void initState() {
    currentPage = movieList.results.length - 1.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller =
    PageController(initialPage: movieList.results.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 0.0, right: 0.0, top: 30.0, bottom: 0.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  child: TypewriterAnimatedTextKit(
                      text: [category,],
                      isRepeatingAnimation: false,
                      textStyle: TextStyle(
                          fontSize: 34.0,
                          fontFamily: "Calibre-Semibold",
                          color: Colors.white),
                      textAlign: TextAlign.start,
                      alignment: AlignmentDirectional.topStart
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/TMDb.png',
                    height: 40,
                  ),
                )
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              CardScrollWidget(
                currentPage: currentPage,
                movieList: movieList,
              ),
              Positioned.fill(
                child: PageView.builder(
                  itemCount: movieList.results.length,
                  controller: controller,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return Container();
                  },
                ),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FittedBox(
                    child: Text(movieList.results[currentPage.round()].title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontFamily: "SF-Pro-Text-Bold")),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () =>Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                posterPath: movieList.results[currentPage.round()].backdropPath,
                                overview: movieList.results[currentPage.round()].overview,
                                title: movieList.results[currentPage.round()].title,
                                releaseDate: movieList.results[currentPage.round()].releaseDate,
                                voteAverage: movieList.results[currentPage.round()].voteAverage,
                                movieId: movieList.results[currentPage.round()].id,
                              ))),
                      child: Padding(padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          '?????????????????????????????????',
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),)
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

// GestureDetector ????????????