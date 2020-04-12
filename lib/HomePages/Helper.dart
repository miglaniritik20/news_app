import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newsapp/DB_provider/db_provider.dart';
import 'package:newsapp/DB_provider/news_api_provider.dart';
import 'package:newsapp/DescriptionPages/description.dart';
import 'package:newsapp/modules/news.dart';

class Helper extends StatefulWidget {
  //const Helper({Key key}) : super(key: key);
  final String url;
  Helper(this.url);

  @override
  _HelperState createState() => _HelperState();
}

class _HelperState extends State<Helper> {
    Future<List<News>> _getData() async {
    Response response = await get(widget.url);
    var data = jsonDecode(response.body);
    var posts = data['posts'];
    List<News> newsItems = [];

    for (var item in posts) {
      News neitem = News(item['id'], item['title'], item['description'],
          item['url'], item['image'], item['published']);
      newsItems.add(neitem);
    }
    
    print(newsItems.length);
    if(newsItems.length==0){
      return null;
    }else{return newsItems;}
    
  }
  var off=false;
  var isLoading = false;
  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });
    var apiProvider = NewApiProvider();
    await apiProvider.getAllNews();
    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFromApi();
  }


  Widget _buildBody() {
    return SafeArea(
      child: new Container(
        margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
        child: new Column(
          children: <Widget>[
            _getListViewWidget(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _getListViewWidget() {
    return new Flexible(
      child: FutureBuilder(
          future:  off?DbProvider.db.getAllNews():_getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) {
                        return Description(snapshot.data[index].url);
                      }));
                    },
                    splashColor: Colors.black12,
                    child: new Container(
                      margin: EdgeInsets.all(8.0),
                      //color: Colors.white,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 2.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                            snapshot.data[index].imglink==null?Container(height: 240,child:Placeholder(),): 
                            Image(
                                image:
                                    NetworkImage(snapshot.data[index].imglink),
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                                height: 240.0,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0,
                                right: 10.0,
                                bottom: 10.0,
                                left: 10.0),
                            child: Text(
                              snapshot.data[index].title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0,
                                right: 10.0,
                                bottom: 10.0,
                                left: 10.0),
                            child: Container(
                              child: Text(
                                snapshot.data[index].description,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, //_buildNewsItem,
              );
            }
          }),
    );
  }
}
