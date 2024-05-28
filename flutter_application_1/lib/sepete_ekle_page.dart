import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'odeme_page.dart';

class SepetPage extends StatefulWidget {
  final String userEmail;

  SepetPage({required this.userEmail});

  @override
  _SepetPageState createState() => _SepetPageState();
}

class _SepetPageState extends State<SepetPage> {
  List<UserEventSepet> userEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchUserEvents();
  }

  Future<void> _fetchUserEvents() async {
    List<UserEventSepet> fetchedEvents =
        await DatabaseHelper.getUserEvents(widget.userEmail);
    setState(() {
      userEvents = fetchedEvents;
    });
  }

  Future<void> _removeUserEvent(UserEventSepet userEvent) async {
    if (userEvent.id != null) {
      await DatabaseHelper.removeUserEvent(widget.userEmail, userEvent.id!);
      _fetchUserEvents(); // Listeyi güncelle
    } else {
      // id null ise bir işlem yapmayabilirsiniz veya hata mesajı gösterebilirsiniz
      print('Hata: id null olamaz.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = userEvents.fold(
        0, (previousValue, element) => previousValue + element.ucret);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sepet',
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
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: userEvents.isNotEmpty
                ? ListView.builder(
                    itemCount: userEvents.length,
                    itemBuilder: (context, index) {
                      final userEvent = userEvents[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ' ${userEvent.etkinlikAdi}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'ID: ${userEvent.id}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Silme Onayı'),
                                            content: Text(
                                                'Bu etkinliği sepetten kaldırmak istediğinize emin misiniz?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('İptal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _removeUserEvent(userEvent);
                                                },
                                                child: Text('Sil'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Tarih ve Zaman: ${userEvent.tarihZaman}',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 89, 58, 138),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: Text(
                                    ' ${userEvent.ucret} TL',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Text(
                    'Sepette hiçbir etkinlik yok.',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                userEvents: userEvents,
                totalCost: totalCost,
              ),
            ),
          );
        },
        label: Text('Ödeme Yap (${totalCost.toString()} TL)', style: TextStyle(color: Colors.white, fontSize: 18)), // Increased font size to 18
        icon: Icon(Icons.payment),
        backgroundColor: Color.fromARGB(255, 89, 58, 138),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
