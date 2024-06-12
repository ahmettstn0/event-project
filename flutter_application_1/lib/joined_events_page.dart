import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_helper.dart';

class JoinedEventsPage extends StatelessWidget {
  final String userEmail;
  final String userName;

  const JoinedEventsPage({
    Key? key,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Katıldığım Etkinlikler',
          style: TextStyle(
            color: Colors.white, 
          ),
        ),
        backgroundColor:
            Color.fromARGB(255, 89, 58, 138), 
      ),
      body: FutureBuilder<List<UserEvent>>(
        future: DatabaseHelper.getUserEventsByEmail(userEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'),
            );
          } else {
            List<UserEvent> userEvents = snapshot.data ?? [];
            if (userEvents.isEmpty) {
              return Center(
                child: Text('Hiçbir etkinliğe katılmamışsınız.'),
              );
            } else {
              return Container(
                child: ListView.builder(
                  itemCount: userEvents.length,
                  itemBuilder: (context, index) {
                    UserEvent event = userEvents[index];
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: event.resimUrl.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Image.network(
                                            event.resimUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(event.resimUrl),
                                      ),
                                    ),
                                  ),
                                )
                              : Icon(Icons
                                  .error), 
                          title: Text(event.etkinlikAdi),
                          subtitle: Text(event.tarihZaman),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      event.resimUrl.isNotEmpty
                                          ? Image.network(
                                              event.resimUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                          : SizedBox
                                              .shrink(),
                                      Text('Etkinlik Adı: ${event.etkinlikAdi}'),
                                      Text('Tarih: ${event.tarihZaman}'),
                                      Text('Ücret: ${event.ucret}'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Kapat'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}