import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'recommended_events_page.dart';
import 'events_page.dart';
import 'sepete_ekle_page.dart'; 

class EventHomePage extends StatefulWidget {
  final String userEmail;
  final String userName;

  const EventHomePage({required this.userEmail, required this.userName});

  @override
  _EventHomePageState createState() => _EventHomePageState();
}

class _EventHomePageState extends State<EventHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Etkinlik ve Organizasyon',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 89, 58, 138),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/anasayfa1.jpeg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildEventCategory(
                        'Önerilenler',
                        Icons.event,
                        context,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildEventCategory(
                        'Etkinlikler',
                        Icons.event_available,
                        context,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildEventCategory(
                        'Ayarlar',
                        Icons.settings,
                        context,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _buildEventCategory(
                        'Sepetim', 
                        Icons.shopping_cart,
                        context,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCategory(
    String title,
    IconData iconData,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (title == 'Önerilenler') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendedEventsPage(
                userEmail: widget.userEmail,
              ),
            ),
          );
        } else if (title == 'Etkinlikler') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventsPage(userEmail: widget.userEmail),
            ),
          );
        } else if (title == 'Ayarlar') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(
                userEmail: widget.userEmail,
                userName: widget.userName,
              ),
            ),
          );
        } else if (title == 'Sepetim') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SepetPage(
                userEmail: widget.userEmail,
              ),
            ),
          );
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
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(iconData, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}