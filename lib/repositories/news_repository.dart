import 'dart:convert';

import 'package:blocnews/models/article_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<List<ArticleModel>> fetchNews() async {
    var response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=tesla&from=2021-10-11&sortBy=publishedAt&apiKey=1da03ad72fca4f4b9af10c3859e468b4"));

    var data = jsonDecode(response.body);

    List<ArticleModel> _articleModelList = [];

    if (response.statusCode == 200) {
      for (var item in data["articles"]) {
        ArticleModel _artcileModel = ArticleModel.fromJson(item);
        _articleModelList.add(_artcileModel);
      }
      return _articleModelList;
    } else {
      return _articleModelList; // empty list
    }
  }
}
