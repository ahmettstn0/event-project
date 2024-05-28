import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_helper.dart'; 

class PaymentScreen extends StatelessWidget {
  final List<UserEventSepet> userEvents;
  final double totalCost;

  PaymentScreen({required this.userEvents, required this.totalCost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ödeme',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: userEvents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Etkinlik: ${userEvents[index].etkinlikAdi}',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tarih ve Zaman: ${userEvents[index].tarihZaman}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Ücret: ${userEvents[index].ucret} TL',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showPaymentDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 89, 58, 138),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Ödeme Yap (${totalCost.toString()} TL)',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kredi Kartı Bilgileri'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: cardNumberController,
                decoration: InputDecoration(labelText: 'Kart Numarası'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: expiryDateController,
                decoration: InputDecoration(labelText: 'Son Kullanma Tarihi'),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                controller: cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                for (var event in userEvents) {
                  await DatabaseHelper.addUserEvent(
                    userEmail: event.userEmail,
                    etkinlikAdi: event.etkinlikAdi,
                    tarihZaman: event.tarihZaman,
                    salon: event.konum,
                    ucret: event.ucret,
                    resimUrl: 'your_image_url', 
                  );
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 89, 58, 138),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Ödeme Yap',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('İptal'),
            ),
          ],
        );
      },
    );
  }
}
