import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'yetkilendirme_page.dart';

class DeauthorizePage extends StatefulWidget {
  @override
  _DeauthorizePageState createState() => _DeauthorizePageState();
}

class _DeauthorizePageState extends State<DeauthorizePage> {
  List<Admin> admins = [];

  @override
  void initState() {
    super.initState();
    _getAllAdmins();
  }

  Future<void> _getAllAdmins() async {
    List<Admin> fetchedAdmins = await DatabaseHelper.getAllAdmins();

    // 'admin@example.com' maili olan admini filtrele
    fetchedAdmins = fetchedAdmins.where((admin) => admin.email != 'admin@example.com').toList();

    setState(() {
      admins = fetchedAdmins;
    });
  }

  Future<void> _removeAdmin(int index) async {
    await DatabaseHelper.deleteAdmin(admins[index]);
    setState(() {
      admins.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yetkilendirme Kaldır',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AuthorizationPage()),
                  );
                },
                child: Text('Geri Dön', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 89, 58, 138),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}