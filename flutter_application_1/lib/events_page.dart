import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_helper.dart';

class EventsPage extends StatefulWidget {
  final String userEmail;
  EventsPage({required this.userEmail});
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];
  String selectedFilter = 'Tümü';

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

  List<Event> getFilteredEvents() {
    if (selectedFilter == 'Tümü') {
      return events;
    } else {
      return events.where((event) => event.etkinlikTuru == selectedFilter).toList();
    }
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
        actions: [
          IconButton(
            onPressed: () {
              // Search functionality can be added here
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/anasayfa1.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildFilterButton('Tümü'),
                    _buildFilterButton('Konser'),
                    _buildFilterButton('Tiyatro'),
                    _buildFilterButton('Spor'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: (getFilteredEvents().length / 2).ceil(),
                itemBuilder: (context, index) {
                  final int firstIndex = index * 2;
                  final int secondIndex = firstIndex + 1;

                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildCard(getFilteredEvents()[firstIndex]),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: secondIndex < getFilteredEvents().length
                              ? _buildCard(getFilteredEvents()[secondIndex])
                              : SizedBox(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Text(text),
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
            TextButton(
              onPressed: () {
                _addToCart(event);
              },
              child: Text('Sepete Ekle'),
            ),
          ],
        );
      },
    );
  }

 void _addToCart(Event event) {
  UserEventSepet userEventSepet = UserEventSepet(
    id: null  ,
    userEmail: widget.userEmail,
    etkinlikAdi: event.etkinlikAdi,
    tarihZaman: event.tarihZaman,
    konum: event.konum,
    ucret: event.ucret,
  );

  DatabaseHelper.insertUserEventSepet(userEventSepet).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Etkinlik sepete eklendi'),
        backgroundColor: Colors.green,
      ),
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Etkinlik sepete eklenirken bir hata oluştu'),
        backgroundColor: Colors.red,
      ),
    );
  });
}
}