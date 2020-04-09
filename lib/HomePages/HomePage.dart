import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newsapp/DescriptionPages/description.dart';
import 'package:newsapp/HomePages/LoginHome.dart';
import 'package:newsapp/Services/Authenticate.dart';
import 'package:newsapp/modules/news.dart';

class HomePage extends StatefulWidget {
//  NetworkImage networkImage;
//  final String name;
//  final String email;
//  HomePage(this.networkImage, this.name, this.email);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthService _authService = AuthService();
  LoginHomePage p1;
  Future<List<News>> _getData() async{
    Response response = await get('https://api.sae.news:8888/articles/getsidebar/name3/?format=json');
    var data = jsonDecode(response.body);
    var posts = data['posts'];
    List<News> newsItems =[];

    for( var item in posts){
      News neitem = News(item['title'],item['description'], item['url'], item['image'], item['published']);
      newsItems.add(neitem);
    }
    print(newsItems.length);
    return newsItems;
  }

  @override
  void initState() {
    super.initState();
  }


  Widget getDrawerContent(BuildContext context){
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(accountName: Text('Ritik'),
             accountEmail: Text('ritikmiglani488@gmail.com'),
             currentAccountPicture: GestureDetector(
               child: CircleAvatar(
                 backgroundColor: Colors.purple,
                child: Text(' R'),
             ),), 
            ),
        ListTile(
          title: new Text('Home'),
          onTap: (){},
          trailing: Icon(Icons.home),
        ),
        ListTile(
          title: new Text('Tech'),
          onTap: (){},
          trailing: Icon(Icons.border_color),
        ),
        ListTile(
          title: new Text('Cult'),
          onTap: (){},
          trailing: Icon(Icons.ac_unit),
        ),
        ListTile(
          title: new Text('StartUps'),
          onTap: (){},
          trailing: Icon(Icons.build),
        ),
        ListTile(
          title: new Text('Your Voice'),
          onTap: () async {
            await _authService.signOut();
          },
          trailing: Icon(Icons.call),
        ),
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

  Widget _getListViewWidget() {
    return new Flexible(
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder:  (BuildContext context, int index){
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder:(context){
                        return Description(snapshot.data[index].url);
                      }));
                    },
                    splashColor: Colors.black12,
                    child: new Container(
                    margin: EdgeInsets.all(8.0),
                    //color: Colors.white,
                    decoration:BoxDecoration(
                      border: Border.all(color: Colors.black12,width: 2.0),
                    ) ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image(
                          image: NetworkImage(snapshot.data[index].imglink),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          height: 240.0,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0,right: 10.0,bottom: 10.0,left: 10.0),
                          child: Text(snapshot.data[index].title,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 23.0
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0,right: 10.0,bottom: 10.0,left: 10.0),
                          child: Container(
                            child: Text(snapshot.data[index].description,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                      ),
                  );
                },//_buildNewsItem,
              );
            }
          }
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: new Text(
          'Campus Connect',
          style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(child: getDrawerContent(context),),
      body:_buildBody(),
      backgroundColor: Colors.white,
      extendBody: true,
      resizeToAvoidBottomPadding: true,
    );
  }
}
