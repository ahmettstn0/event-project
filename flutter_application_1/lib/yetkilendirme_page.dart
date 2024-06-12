import 'package:flutter/material.dart';
import 'database_helper.dart';

class AuthorizePage extends StatefulWidget {
  @override
  _AuthorizePageState createState() => _AuthorizePageState();
}

class _AuthorizePageState extends State<AuthorizePage> {
  late List<User> users = [];
  late List<Admin> admins = [];

  @override
  void initState() {
    super.initState();
    _fetchUserList();
    _getAllAdmins();
  }

  Future<void> _fetchUserList() async {
    List<User> userList = await DatabaseHelper.getAllUsers();
    setState(() {
      users = userList;
    });
  }

  Future<void> _getAllAdmins() async {
    List<Admin> fetchedAdmins = await DatabaseHelper.getAllAdmins();
    fetchedAdmins = fetchedAdmins.where((admin) => admin.email != 'admin@example.com').toList();
    setState(() {
      admins = fetchedAdmins;
    });
  }

  Future<void> _authorizeUser(User user) async {
    print('Kullanıcı yetkilendirildi: ${user.name}');
    await DatabaseHelper.insertAdmin(
      Admin(
        name: user.name,
        email: user.email,
        password: user.password,
      ),
    );
    await DatabaseHelper.deleteUser(user.email);
    _fetchUserList();
  }

  Future<void> _removeAdmin(int index) async {
    await DatabaseHelper.deleteAdmin(admins[index]);
    setState(() {
      admins.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Yetkilendirme Sayfası',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 89, 58, 138),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Yetkilendirme Yap'),
              Tab(text: 'Yetkilendirme Kaldır'),
            ],
            labelColor: Colors.white, 
            unselectedLabelColor: Colors.white70, 
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/anasayfa1.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            children: [
              _buildAuthorizeTab(),
              _buildDeauthorizeTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorizeTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white.withOpacity(0.9),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      users[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      users[index].email,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 89, 58, 138),
                        elevation: 3, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), 
                        ),
                      ),
                      onPressed: () {
                        _authorizeUser(users[index]);
                      },
                      child: Text(
                        'Yetkilendir',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeauthorizeTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: admins.length,
              itemBuilder: (context, index) {
                final admin = admins[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      admin.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      admin.email,
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeAdmin(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}