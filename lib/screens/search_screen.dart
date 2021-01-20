import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movieinfo/bloc/search_bloc.dart';
import 'package:movieinfo/modal/movie.dart';
import 'package:movieinfo/modal/movie_response.dart';
import 'package:movieinfo/screens/detail_screen.dart';
import 'package:movieinfo/screens/home_screen.dart';
import 'package:movieinfo/style/theme.dart' as Style;

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchBloc..search("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        title: Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              controller: _searchController,
              onChanged: (changed) {
                searchBloc..search(_searchController.text);
              },
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: _searchController.text.length > 0
                    ? IconButton(
                        icon: Icon(EvaIcons.backspaceOutline),
                        onPressed: () {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _searchController.clear();
                            searchBloc..search(_searchController.text);
                          });
                        })
                    : Icon(
                        EvaIcons.searchOutline,
                        color: Colors.grey[500],
                        size: 20.0,
                      ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.grey[100].withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey[100].withOpacity(0.3),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
                labelText: "Search...",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Style.Colors.mainColor,
                  fontWeight: FontWeight.w500,
                ),
                labelStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              autocorrect: false,
              autovalidate: true,
            ),
          ),
          Expanded(
            child: StreamBuilder<MovieResponse>(
              stream: searchBloc.subject.stream,
              builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0) {
                    return Container();
                  }
                  return _buildSearchWidget(snapshot.data);
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error);
                } else {
                  return _buildLoadingWidget();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30.0,
          width: 25.0,
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildSearchWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        child: Text("No Movies"),
      );
    } else
      return Container(
        height: 600.0,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                top: 5.0,
                bottom: 10.0,
                right: 10.0,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                          movie: movies[index],
                        ),
                      ));
                },
                child: Column(
                  children: <Widget>[
                    movies[index].poster == null
                        ? Container(
                            width: 220.0,
                            height: 380.0,
                            decoration: BoxDecoration(
                              color: Style.Colors.secondColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  EvaIcons.filmOutline,
                                  color: Colors.white,
                                  size: 50.0,
                                )
                              ],
                            ),
                          )
                        : Container(
                            width: 200.0,
                            height: 300.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w400/" +
                                        movies[index].poster),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 100.0,
                      child: Center(
                        child: Text(
                          movies[index].title,
                          maxLines: 2,
                          style: TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          movies[index].rating.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        RatingBar.builder(
                          itemSize: 8.0,
                          initialRating: movies[index].rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            EvaIcons.star,
                            color: Colors.yellow,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}
