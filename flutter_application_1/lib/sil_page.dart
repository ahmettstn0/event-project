import 'package:flutter/material.dart';
import 'database_helper.dart';

class SilPage extends StatefulWidget {
  @override
  _SilPageState createState() => _SilPageState();
}

class _SilPageState extends State<SilPage> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEventsFromDatabase();
  }

  Future<void> _fetchEventsFromDatabase() async {
    List<Event> fetchedEvents = await DatabaseHelper.getAllEvents();
    setState(() {
      events = fetchedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Etkinlikleri Sil',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Color.fromARGB(
            255, 89, 58, 138), 
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/anasayfa1.jpeg'), // Arka plan resmi
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              elevation: 2, 
              child: ListTile(
                title: Text(
                  event.etkinlikAdi,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(event.tarihZaman),
                onTap: () {
                  _showEventDetails(event);
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteEvent(event);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showEventDetails(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.etkinlikAdi),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tarih ve Zaman: ${event.tarihZaman}'),
              Text('Konum: ${event.konum}'),
              Text('Açıklama: ${event.aciklama}'),
              Text('Katılımcı Adı: ${event.katilimciAdi}'),
              Text('Salon: ${event.salon}'),
              Text('Kontenjan: ${event.kontenjan}'),
              Text('Ücret: ${event.ucret}'),
              Text('Etkinlik Türü: ${event.etkinlikTuru}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple,
                primary: Colors.white, 
              ),
              child: Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(Event event) {
    DatabaseHelper.deleteEvent(event);
    _fetchEventsFromDatabase();
  }
}