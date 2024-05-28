import 'package:flutter/material.dart';
import 'database_helper.dart'; 


class RecommendedEventsPage extends StatefulWidget {
  final String userEmail;

  const RecommendedEventsPage({required this.userEmail});

  @override
  _RecommendedEventsPageState createState() => _RecommendedEventsPageState();
}

class _RecommendedEventsPageState extends State<RecommendedEventsPage> {
  late String _userEvent;

  @override
  void initState() {
    super.initState();
    _updateUserEvent();
  }

  Future<void> _updateUserEvent() async {
    try {
      final user = await DatabaseHelper.getUserByEmail(widget.userEmail);
      if (user != null) {
        setState(() {
          _userEvent = user.event;
        });
      } else {
        // Handle user not found
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Önerilen Etkinlikler',
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
        child: FutureBuilder(
          future: DatabaseHelper.getAllEvents(),
          builder: (context, AsyncSnapshot<List<Event>> eventSnapshot) {
            if (eventSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (eventSnapshot.hasError) {
              return Center(
                child: Text('Bir hata oluştu.'),
              );
            }
            if (eventSnapshot.data == null || eventSnapshot.data!.isEmpty) {
              return Center(
                child: Text('Etkinlik bulunamadı.'),
              );
            }
            List<Event> filteredEvents = eventSnapshot.data!
                .where((event) => event.etkinlikTuru == _userEvent)
                .toList();

            if (filteredEvents.isEmpty) {
              return Center(
                child: Text('Önerilen etkinlik bulunamadı.'),
              );
            }
            return ListView.builder(
              itemCount: (filteredEvents.length / 2).ceil(),
              itemBuilder: (context, index) {
                final int firstIndex = index * 2;
                final int secondIndex = firstIndex + 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildCard(context, filteredEvents[firstIndex]),
                        ),
                      ),
                      Expanded(
                        child: secondIndex < filteredEvents.length
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _buildCard(context, filteredEvents[secondIndex]),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        _showEventDetails(context, event);
      },
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.resimUrl,
              height: 150, 
              width: double.infinity, 
              fit: BoxFit.cover, 
            ),
            ListTile(
              title: Text(
                event.etkinlikAdi,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                event.tarihZaman,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150, 
                width: double.infinity, 
                child: Image.network(
                  event.resimUrl,
                  fit: BoxFit.cover, 
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  event.etkinlikAdi,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
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
