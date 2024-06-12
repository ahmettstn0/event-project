import 'package:flutter/material.dart';
import 'database_helper.dart';

class AdminEventPage extends StatefulWidget {
  @override
  _AdminEventPageState createState() => _AdminEventPageState();
}

class _AdminEventPageState extends State<AdminEventPage> {
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
          'Etkinlikler',
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
        child: ListView.builder(
          itemCount: (events.length / 2).ceil(), 
          itemBuilder: (context, index) {
            final int firstIndex = index * 2;
            final int secondIndex = firstIndex + 1;
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildCard(events[firstIndex]),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: secondIndex < events.length ? _buildCard(events[secondIndex]) : SizedBox(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

Widget _buildCard(Event event) {
  return Card(
    elevation: 3,
    child: Container(
      height: 180, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              event.resimUrl,
              fit: BoxFit.cover, 
            ),
          ),
          ListTile(
            title: Text(
              event.etkinlikAdi.length > 20 ? event.etkinlikAdi.substring(0, 20) + "..." : event.etkinlikAdi,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), 
            ),
            subtitle: Text(
              event.tarihZaman, 
              style: TextStyle(color: Colors.grey, fontSize: 14), 
            ),
            onTap: () {
              _showEventDetails(event);
            },
          ),
        ],
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
            Image.network(event.resimUrl),
            SizedBox(height: 8), 
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
            child: Text('Kapat'),
          ),
        ],
      );
    },
  );
}
}