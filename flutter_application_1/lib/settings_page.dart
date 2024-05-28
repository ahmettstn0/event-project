import 'package:flutter/material.dart';
import 'login_page.dart';
import 'joined_events_page.dart';

class SettingsPage extends StatelessWidget {
  final String userEmail;
  final String userName;

  const SettingsPage({
    Key? key,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ayarlar',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.white, 
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(200, 89, 58, 138),
                  borderRadius: BorderRadius.circular(20), 
                ),
                child: ListTile(
                  title: Text(
                    'Kullanıcı Bilgileri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: Colors.white, 
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Kullanıcı Bilgileri'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('E-posta: $userEmail'),
                              Text('Ad Soyad: $userName'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Kapat'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(200, 89, 58, 138), 
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: Text(
                    'Katıldığım Etkinlikler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                  leading: Icon(
                    Icons.event,
                    color: Colors.white, 
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinedEventsPage(
                          userEmail: userEmail,
                          userName: userName,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
                child: Text('Çıkış Yap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}