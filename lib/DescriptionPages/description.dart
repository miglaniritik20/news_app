import 'package:flutter/material.dart';
import 'package:newsapp/HomePages/HomePage.dart';
import 'package:http/http.dart';
import 'package:newsapp/modules/Data.dart';
import 'dart:convert';

class Description extends StatefulWidget {
//  NetworkImage networkImage;
//  final String name;
//  final String email;
  String url;
  Description(this.url);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  Future<DescriptionData> _getDescData() async{
    Response response = await get('https://api.sae.news:8888/articles/get'+ widget.url +'/?format=json');
    var data = jsonDecode(response.body);
    List<DescriptionData> descItems =[];
    DescriptionData neitem = DescriptionData(data['title'],data['description'], data['published'], data['featured_image'], data['author']['username'], data['author']['first_name'], data['author']['Last_name']);
    print('DescItems ${descItems.length}');
    return neitem;
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
          onTap: (){
            Navigator.push(context, new MaterialPageRoute(builder:(context){
                return HomePage();
            }));
          },
          trailing: Icon(Icons.home),
        ),
        ListTile(
          title: new Text('Tech'),
          onTap: (){},
          trailing: Icon(Icons.border_color),
        ),
        ListTile(
          title: new Text('Cult'),
          onTap: (){

          },
          trailing: Icon(Icons.ac_unit),
        ),
        ListTile(
          title: new Text('StartUps'),
          onTap: (){},
          trailing: Icon(Icons.build),
        ),
        ListTile(
          title: new Text('Your Voice'),
          onTap: (){},
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
          future: _getDescData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder:  (BuildContext context, int index){
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          child: Text(snapshot.data.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            
                          ),),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(
                          thickness: 5.0,
                          height: 30.0,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(snapshot.data.publish,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),),
                          Text(snapshot.data.firstName+ "( " + snapshot.data.userName + " )",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0,
                          ),),
                        ],),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image(
                              image: NetworkImage(snapshot.data.imgURL),
                              fit: BoxFit.fill,
                              alignment: Alignment.topCenter,
                              height: 230.0,
                              width: MediaQuery.of(context).size.width,
                            ),
                        ),
                        Text(snapshot.data.desc,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0
                        ),)
                      ],
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
      drawer: Drawer(child:getDrawerContent(context),),
      body:_buildBody(),
    );
  }
}