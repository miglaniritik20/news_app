import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import '../DB_provider/db_provider.dart';
import '../DB_provider/news_api_provider.dart';
import '../DescriptionPages/description.dart';
import '../Services/Authenticate.dart';
import '../modules/news.dart';
import 'LoginHome.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn =new GoogleSignIn(scopes: ['email']);
  AuthService _authService = AuthService();
  LoginHomePage p1;
  Future<List<News>> _getData() async {
    Response response = await get(
        'https://api.sae.news:8888/articles/getsidebar/name3/?format=json');
    var data = jsonDecode(response.body);
    var posts = data['posts'];
    List<News> newsItems = [];

    for (var item in posts) {
      News neitem = News(item['id'], item['title'], item['description'],
          item['url'], item['image'], item['published']);
      newsItems.add(neitem);
    }
    print(newsItems.length);
    if (newsItems.length == 0) {
      return null;
    } else {
      return newsItems;
    }
  }

  var off = false;
  var isLoading = false;
  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DbProvider.db.deleteAllNews();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All News deleted');
  }

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
    
  }

  Widget getDrawerContent(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(accountName: Text('Ritik'),
             accountEmail: Text("ritikmiglani488@gmail.com"),
             currentAccountPicture: GestureDetector(
               child: CircleAvatar(
                 //backgroundImage: NetworkImage(_googleSignIn.currentUser.photoUrl),
                 backgroundColor: Colors.purple,
                child: Text(' R'),
             ),), 
            ),
        ListTile(
          title: new Text('Home'),
          onTap: () {},
          trailing: Icon(Icons.home),
        ),
        ListTile(
          title: new Text('Tech'),
          onTap: () {},
          trailing: Icon(Icons.border_color),
        ),
        ListTile(
          title: new Text('Cult'),
          onTap: () {},
          trailing: Icon(Icons.ac_unit),
        ),
        ListTile(
          title: new Text('StartUps'),
          onTap: () {},
          trailing: Icon(Icons.build),
        ),
        ListTile(
          title: new Text('Your Voice'),
          onTap: () {
          },
          trailing: Icon(Icons.call),
        ),
        Divider(),
        ListTile(
          title: new Text('Logout'),
          onTap: () async {
            await _deleteData();
            await _authService.signOut();
          },
          trailing: Icon(Icons.call),
        ),
        Divider(),
      ],
    );
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
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          // Container(
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //     icon: Icon(Icons.settings_input_antenna),
          //     onPressed: () async {
          //       //await _loadFromApi();
          //     },
          //   ),
          // ),
          IconButton(
            icon: Icon(Icons.offline_pin),
            tooltip: 'Go Offline',
            onPressed: () async {
              setState(() {
                off == true ? off = false : off = true;
              });
            },
          ),
        ],
        title: new Text(
          'Campus Connect',
          style: TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: getDrawerContent(context),
      ),
      body: _buildBody(),
      backgroundColor: Colors.white,
      extendBody: true,
      resizeToAvoidBottomPadding: true,
    );
  }

  Widget _getListViewWidget() {
    return new Flexible(
      child: FutureBuilder(
          future: off ? DbProvider.db.getAllNews() : _getData(),
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
                              // Positioned(
                              //     top: 0,
                              //     right: 0,
                              //     child: IconButton(
                              //       onPressed: null,
                              //       icon: Icon(
                              //         Icons.bookmark,
                              //         color: Colors.blueAccent,
                              //         size: 40,
                              //       ),
                              //     ))
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
                                 
                                ),
                              )),
                      ],
                    ),)
                  );
                }, //_buildNewsItem,
              );
            }
          }),
    );
  }
}
