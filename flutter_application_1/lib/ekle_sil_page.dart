import 'package:flutter/material.dart';
import 'ekle_page.dart'; 
import 'sil_page.dart'; 

class EkleSilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ekle/Sil',
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200, 
                height: 50, 
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EklePage()),
                    );
                  },
                  child: Text('Ekle', style: TextStyle(fontSize: 18)), 
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200, 
                height: 50, 
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SilPage()),
                    );
                  },
                  child: Text('Sil', style: TextStyle(fontSize: 18)), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}