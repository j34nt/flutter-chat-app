import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/user.dart';


class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    User(online: true, email: 'test1@mail.com', name: 'Maria', uid: '1'),
    User(online: true, email: 'test2@mail.com', name: 'Jose', uid: '2'),
    User(online: true, email: 'test3@mail.com', name: 'Bastian', uid: '3'),
    User(online: false, email: 'test4@mail.com', name: 'Alexandra', uid: '4'),
    User(online: true, email: 'test5@mail.com', name: 'Pedro', uid: '5'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi nombre', style: TextStyle(color: Colors.black87),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87,),
          onPressed: (){},
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400],),
            // child: Icon(Icons.offline_bolt, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUser(),
      )
   );
  }

  ListView _listViewUser() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(users[i]),
      separatorBuilder: (_,i) => Divider(),
      itemCount: users.length
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }
  _loadUsers() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}