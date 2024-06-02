import 'package:flutter/material.dart';
import 'package:flutter_application_1/yetkilendirme_page.dart';
import 'settings_page.dart';
import 'admin_event_page.dart';
import 'ekle_sil_page.dart';

class AdminHomePage extends StatelessWidget {
  final String userEmail;
  final String userName;
  final String userPassword;

  const AdminHomePage({required this.userEmail, required this.userName, required this.userPassword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Etkinlik ve Organizasyon (Admin)',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(
          255,
          89,
          58,
          138,
        ),
      ),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Color.fromARGB(
                255,
                89,
                58,
                138,
              ),
              child: Image.asset(
                'assets/images/anasayfa1.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCategoryRow(
                  context,
                  [
                    _buildEventCategory('Etkinlikler', Icons.event_available, context),
                    if (userEmail == 'admin@example.com' && userPassword == 'admin123')
                      _buildEventCategory('Yetkilendirme', Icons.lock, context),
                  ],
                ),
                SizedBox(height: 5),
                _buildCategoryRow(
                  context,
                  [
                    _buildEventCategory('Ayarlar', Icons.settings, context),
                    _buildEventCategory('Ekle/Sil', Icons.add, context),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context, List<Widget> categories) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var category in categories) ...[
              SizedBox(width: 10),
              Expanded(child: category),
            ],
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEventCategory(String title, IconData iconData, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Etkinlikler') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminEventPage()), 
          );
        } else if (title == 'Ayarlar') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(
                userEmail: userEmail,
                userName: userName, 
              ),
            ),
          );
        } else if (title == 'Ekle/Sil') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EkleSilPage(),
            ),
          );
        } else if (title == 'Yetkilendirme' ){
          if (userEmail == 'admin@example.com' && userPassword == 'admin123') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthorizePage()),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Yetkilendirme Hatası"),
                content: Text("Yetkilendirme için gerekli izne sahip değilsiniz."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Tamam"),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 89, 58, 138),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}