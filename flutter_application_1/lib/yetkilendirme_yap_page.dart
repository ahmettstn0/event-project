import 'package:flutter/material.dart';
import 'yetkilendirme_page.dart';
import 'database_helper.dart';

class AuthorizePage extends StatefulWidget {
  @override
  _AuthorizePageState createState() => _AuthorizePageState();
}

class _AuthorizePageState extends State<AuthorizePage> {
  late List<User> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  Future<void> _fetchUserList() async {
    List<User> userList = await DatabaseHelper.getAllUsers();
    setState(() {
      users = userList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yetkilendirme Yap',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Color.fromARGB(255, 89, 58, 138), 
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/anasayfa1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                            elevation: 3, // Düğmenin gölgesi
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthorizationPage()));
                },
                child: Text('Geri Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _authorizeUser(User user) async {
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
}