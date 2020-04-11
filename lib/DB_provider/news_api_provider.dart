import 'dart:convert';
import 'package:http/http.dart';
import 'package:newsapp/DB_provider/db_provider.dart';
import '../modules/news.dart';

class NewApiProvider {
    Future<List<News>> getAllNews() async {
    Response response = await get(
        'https://api.sae.news:8888/articles/getsidebar/name3/?format=json');
    var data = jsonDecode(response.body);
    var posts = data['posts'];
    List<News> newsItems = [];

    return (posts as List).map((news) {
      print('Inserting $news');
      DbProvider.db.createNews(News.fromJson(news));
    }).toList();
    
  }
}
