import 'package:flutter/material.dart';
import 'yetkilendirme_kaldır_page.dart';
import 'yetkilendirme_yap_page.dart'; 

class AuthorizationPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yetkilendirme Sayfası',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AuthorizePage()),
                  );
                },
                child: Text('Yetkilendirme Yap'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DeauthorizePage()),
                  );
                },
                child: Text('Yetkilendirme Kaldır'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}