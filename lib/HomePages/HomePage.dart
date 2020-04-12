import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/HomePages/Helper.dart';
import '../DB_provider/db_provider.dart';
import '../DB_provider/news_api_provider.dart';
import '../Services/Authenticate.dart';
import 'LoginHome.dart';

class HomePage extends StatefulWidget {      
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final GoogleSignIn _googleSignIn =new GoogleSignIn(scopes: ['email']);
  AuthService _authService = AuthService();
  LoginHomePage p1;
  var off=false;
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
    _loadFromApi();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
          child: Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: Colors.indigo,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.offline_pin),
              tooltip: 'Go Offline',
              onPressed: () async {
                setState(() {
                  off==true?off=false:off=true;
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
           bottom: PreferredSize(
                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.3),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Text('Home',
                          style: TextStyle(
                              fontSize: 20.0,
                              color:Colors.white)),
                        ),
                        Tab(
                          child: Text('Technology',
                          style: TextStyle(
                              fontSize: 20.0,
                              color:Colors.white)),
                        ),
                        Tab(
                          child: Text('Cultural',
                          style: TextStyle(
                              fontSize: 20.0,
                              color:Colors.white)),
                        ),
                        Tab(
                          child: Text('Startups',
                          style: TextStyle(
                              fontSize: 20.0,
                              color:Colors.white)),
                        ),
                        Tab(
                          child: Text('Your Voice',
                          style: TextStyle(
                              fontSize: 20.0,
                              color:Colors.white)),
                        ),
                      
                      ]), preferredSize: Size.fromHeight(50.0)),
        ),

        drawer: Drawer(
          child: getDrawerContent(context),
        ),
        body: TabBarView(
          children:<Widget>[
            Helper('https://api.sae.news:8888/articles/getsidebar/name3/?format=json'),
            Helper('https://api.sae.news:8888/articles/getsidebar/tech1/?format=json'),
            Helper('https://api.sae.news:8888/articles/getsidebar/cult1/?format=json'),
            Helper('https://api.sae.news:8888/articles/getsidebar/startup1/?format=json'),
            Helper('https://api.sae.news:8888/articles/getsidebar/yv1/?format=json'),
          ] 
        ),
        backgroundColor: Colors.white,
        extendBody: true,
        resizeToAvoidBottomPadding: true,
      ),
    );
  } 
 }