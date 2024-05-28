import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class EklePage extends StatefulWidget {
  @override
  _EklePageState createState() => _EklePageState();
}

class _EklePageState extends State<EklePage> {
  final TextEditingController etkinlikAdiController = TextEditingController();
  final TextEditingController tarihZamanController = TextEditingController();
  final TextEditingController konumController = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();
  final TextEditingController katilimciAdiController = TextEditingController();
  final TextEditingController salonController = TextEditingController();
  final TextEditingController kontenjanController = TextEditingController();
  final TextEditingController ucretController = TextEditingController();
  final TextEditingController resimUrlController = TextEditingController();
  String? selectedEtkinlikTuru;
  List<String> etkinlikTurleri = ['Konser', 'Spor', 'Tiyatro'];

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime combinedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);

        setState(() {
          tarihZamanController.text = formattedDateTime;
        });
      }
    }
  }

  Future<void> _addEventToDatabase() async {
    String etkinlikAdi = etkinlikAdiController.text;
    String tarihZaman = tarihZamanController.text;
    String konum = konumController.text;
    String aciklama = aciklamaController.text;
    String katilimciAdi = katilimciAdiController.text;
    String salon = salonController.text;
    String resimUrl = resimUrlController.text;
    int kontenjan = int.tryParse(kontenjanController.text) ?? 0;
    double ucret = double.tryParse(ucretController.text) ?? 0.0;

    final event = Event(
      etkinlikAdi: etkinlikAdi,
      tarihZaman: tarihZaman,
      konum: konum,
      aciklama: aciklama,
      katilimciAdi: katilimciAdi,
      salon: salon,
      kontenjan: kontenjan,
      ucret: ucret,
      etkinlikTuru: selectedEtkinlikTuru ?? '',
      resimUrl: resimUrl,
    );

    await DatabaseHelper.insertEvent(event);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ekle',
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
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: etkinlikAdiController,
                  decoration: InputDecoration(
                    labelText: 'Etkinlik Adı',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white, 
                    filled: true, 
                  ),
                  style: TextStyle(color: Colors.black), 
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDateTime(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: tarihZamanController,
                      decoration: InputDecoration(
                        labelText: 'Tarih ve Zaman',
                        labelStyle: TextStyle(color: Colors.black), 
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), 
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), 
                        ),
                        fillColor: Colors.white,
                        filled: true, 
                      ),
                      style: TextStyle(color: Colors.black), 
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: konumController,
                  decoration: InputDecoration(
                    labelText: 'Konum (Harita Koordinatları)',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white, 
                    filled: true, 
                  ),
                  style: TextStyle(color: Colors.black), 
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: aciklamaController,
                  decoration: InputDecoration(
                    labelText: 'Açıklama',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white, 
                    filled: true, 
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: katilimciAdiController,
                  decoration: InputDecoration(
                    labelText: 'Katılımcı Adı',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white, 
                    filled: true, 
                  ),
                  style: TextStyle(color: Colors.black), 
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: salonController,
                  decoration: InputDecoration(
                    labelText: 'Salon',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white,
                    filled: true, 
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: kontenjanController,
                  decoration: InputDecoration(
                    labelText: 'Kontenjan',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white, 
                    filled: true, 
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black), 
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: resimUrlController,
                  decoration: InputDecoration(
                    labelText: 'Resim Url',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white, 
                    filled: true, 
                  ),
                  style: TextStyle(color: Colors.black), 
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: ucretController,
                  decoration: InputDecoration(
                    labelText: 'Ücret',
                    labelStyle: TextStyle(color: Colors.black), 
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white, 
                    filled: true, 
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black), 
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedEtkinlikTuru,
                  onChanged: (newValue) {
                    setState(() {
                      selectedEtkinlikTuru = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Etkinlik Türü',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                    ),
                    fillColor: Colors.white, 
                    filled: true, 
                  ),
                  items: etkinlikTurleri.map((etkinlikTuru) {
                    return DropdownMenuItem<String>(
                      value: etkinlikTuru,
                      child: Text(etkinlikTuru),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _addEventToDatabase();
                  },
                  child: Text('Ekle', style: TextStyle(color: Colors.black)), 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}