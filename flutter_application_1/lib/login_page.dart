import 'admin_home_page.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Etkinlik ve Organizasyon',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 89, 58, 138),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/anasayfa1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;

                User? user = await DatabaseHelper.getUserByEmail(email);
                Admin? admin = await DatabaseHelper.getAdminByEmail(email);

                if (user != null && user.password == password) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventHomePage(
                        userEmail: user.email,
                        userName: user.name,
                      ),
                    ),
                  );
                } 
                else if (admin != null && admin.password == password) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(
                        userEmail: admin.email,
                        userName: admin.name, userPassword: admin.password,
                      ),
                    ),
                  );
                } 
                else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Hata'),
                        content: Text('E-posta veya şifre yanlış.'),
                        actions: <Widget>[
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
                }
              },
              child: Text('Giriş Yap', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 89, 58, 138),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                'Hesabın yok mu? Kayıt ol',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}