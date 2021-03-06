import 'dart:io';

import 'package:blocnews/blocs/newsbloc/news_bloc.dart';
import 'package:blocnews/blocs/newsbloc/news_states.dart';
import 'package:blocnews/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.03),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Flutter",
                        style:
                        TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "News",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),

                ),
                SizedBox(
                  height: height * 0,

                ),
                Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(0.1),
                  margin: EdgeInsets.fromLTRB(1,1,0.6,10),

                  alignment: Alignment.center,
                  constraints: BoxConstraints.expand(height: 155),
                  child: imageSlider(context),
                ),
                Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.7),
                  width: width,
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: height * 0.3),
            child: BlocBuilder<NewsBloc, NewsStates>(
              builder: (BuildContext context, NewsStates state) {
                if (state is NewsLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NewsLoadedState) {
                  List<ArticleModel> _articleList = [];
                  _articleList = state.articleList;
                  return ListView.builder(
                      itemCount: _articleList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (Platform.isAndroid) {
                              FlutterWebBrowser.openWebPage(
                                url: _articleList[index].url,
                                customTabsOptions: CustomTabsOptions(
                                  colorScheme: CustomTabsColorScheme.dark,
                                  toolbarColor: Colors.deepPurple,
                                  secondaryToolbarColor: Colors.green,
                                  navigationBarColor: Colors.amber,
                                  addDefaultShareMenuItem: true,
                                  instantAppsEnabled: true,
                                  showTitle: true,
                                  urlBarHidingEnabled: true,
                                ),
                              );
                            } else if (Platform.isIOS) {
                              FlutterWebBrowser.openWebPage(
                                url: _articleList[index].url,
                                safariVCOptions: SafariViewControllerOptions(
                                  barCollapsingEnabled: true,
                                  preferredBarTintColor: Colors.green,
                                  preferredControlTintColor: Colors.amber,
                                  dismissButtonStyle:
                                      SafariViewControllerDismissButtonStyle
                                          .close,
                                  modalPresentationCapturesStatusBarAppearance:
                                      true,
                                ),
                              );
                            } else {
                              await FlutterWebBrowser.openWebPage(
                                  url: _articleList[index].url);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.grey,
                                      offset: Offset(0, 2),
                                      spreadRadius: 1)
                                ]),
                            height: height * 0.15,
                            margin: EdgeInsets.only(
                                bottom: height * 0.01,
                                top: height * 0.01,
                                left: width * 0.02,
                                right: width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  width: width * 0.3,
                                  height: height * 0.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            _articleList[index].urlToImage !=
                                                    null
                                                ? _articleList[index].urlToImage
                                                : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSojwMMYZgtiupM4Vzdb5iBeE4b0Mamf3AgrxQJR19Xa4oIWV5xun9a02Ggyh4bZAurP_c&usqp=CAU",
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Container(
                                  height: height * 0.15,
                                  width: width * 0.55,
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  child: Text(
                                    _articleList[index].title,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                } else if (state is NewsErrorState) {
                  String error = state.errorMessage;

                  return Center(child: Text(error));
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ));
                }
              },
            ),
          )
        ],
      )),
    );
  }
}
Swiper imageSlider(context){
  return new Swiper(
    autoplay: true,
    itemBuilder: (BuildContext context, int index){
      return new Image.network("https://clibme.com/wp-content/uploads/2021/05/tesla-model-x-white-electric-car-wing-falcon-lighting-clouds-1254x800.jpg",fit: BoxFit.fitHeight,);
    },
    itemCount: 4,
    viewportFraction: 0.5,
    scale: 0.8,
  );
}
