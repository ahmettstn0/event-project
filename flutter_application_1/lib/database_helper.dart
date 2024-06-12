import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class User {
  String name;
  String email;
  String password;
  String event; 

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.event,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'event': event,
    };
  }
}

class UserEvent {
  String email;
  String etkinlikAdi;
  String tarihZaman; 
  double ucret;
  String salon;
  String resimUrl;

  UserEvent({
    required this.email,
    required this.etkinlikAdi,
    required this.tarihZaman,
    required this.salon,
    required this.ucret,
    required this.resimUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'etkinlikAdi': etkinlikAdi,
      'tarihZaman': tarihZaman,
      'salon': salon,
      'ucret': ucret,
      'resimUrl':resimUrl,
    };
  }
}

class Admin {
  String name;
  String email;
  String password;

  Admin({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

class Event {
  String etkinlikAdi;
  String tarihZaman;
  String konum;
  String aciklama;
  String katilimciAdi;
  String salon;
  int kontenjan;
  double ucret;
  String etkinlikTuru;
  String resimUrl;

  Event({
    required this.etkinlikAdi,
    required this.tarihZaman,
    required this.konum,
    required this.aciklama,
    required this.katilimciAdi,
    required this.salon,
    required this.kontenjan,
    required this.ucret,
    required this.etkinlikTuru,
    required this.resimUrl,
  });

  get userEmail => null;

  Map<String, dynamic> toMap() {
    return {
      'etkinlikAdi': etkinlikAdi,
      'tarihZaman': tarihZaman,
      'konum': konum,
      'aciklama': aciklama,
      'katilimciAdi': katilimciAdi,
      'salon': salon,
      'kontenjan': kontenjan,
      'ucret': ucret,
      'etkinlikTuru': etkinlikTuru,
      'resimUrl': resimUrl,
    };
  }
}

class UserEventSepet {
  int? id;
  final String userEmail;
  final String etkinlikAdi;
  final String tarihZaman;
  final String konum;
  final double ucret;

  UserEventSepet({
    this.id,
    required this.userEmail,
    required this.etkinlikAdi,
    required this.tarihZaman,
    required this.konum,
    required this.ucret,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': userEmail,
      'etkinlikAdi': etkinlikAdi,
      'tarihZaman': tarihZaman,
      'konum': konum,
      'ucret': ucret,
    };
  }
}

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      await _initDatabase();
      return _database!;
    }
  }

  static Future<void> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'donem_projesi2_database.db');
    _database = await openDatabase(path, version: 1, onCreate: _createDb);
  }

  static Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User(
        name TEXT,
        email TEXT PRIMARY KEY,
        password TEXT,
        event TEXT
      )
    ''');

  await db.execute('''
    CREATE TABLE Event(
      etkinlikAdi TEXT,
      tarihZaman TEXT,
      konum TEXT,
      aciklama TEXT,
      katilimciAdi TEXT,
      salon TEXT,
      kontenjan INTEGER,
      ucret REAL,
      etkinlikTuru TEXT,
      resimUrl TEXT
    )
  ''');

    await db.execute('''
      CREATE TABLE Admin(
        name TEXT,
        email TEXT PRIMARY KEY,
        password TEXT
      )
    ''');

       await db.execute('''
      CREATE TABLE UserEvent(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        etkinlikAdi TEXT,
        tarihZaman TEXT,
        salon TEXT,
        ucret REAL,
        resimUrl TEXT
      )
    ''');

      await db.execute('''
      CREATE TABLE UserEventSepet(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        etkinlikAdi TEXT,
        tarihZaman TEXT,
        konum TEXT,
        ucret REAL
      )
    ''');
  }

static Future<User?> getUserByEmail(String email) async {
  final Database db = await database;
  List<Map<String, dynamic>> result = await db.query(
    'User',
    where: 'email = ?',
    whereArgs: [email],
    limit: 1,
  );
  if (result.isNotEmpty) {
    return User(
      name: result[0]['name'],
      email: result[0]['email'],
      password: result[0]['password'],
      event: result[0]['event'],
    );
  } else {
    return null;
  }
}

  static Future<void> addUserEvent({
    required String userEmail,
    required String etkinlikAdi,
    required String tarihZaman,
    required String salon,
    required double ucret,
    required String resimUrl,
  }) async {
    final Database db = await database;
    await db.insert(
      'UserEvent',
      {
        'email': userEmail,
        'etkinlikAdi': etkinlikAdi,
        'tarihZaman': tarihZaman,
        'salon': salon,
        'ucret': ucret,
        'resimUrl' :resimUrl,
      },
    );
  }

  static Future<Admin?> getAdminByEmail(String email) async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query('Admin',
        where: 'email = ?', whereArgs: [email], limit: 1);

    if (result.isNotEmpty) {
      return Admin(
        name: result[0]['name'],
        email: result[0]['email'],
        password: result[0]['password'],
      );
    } else {
      return null;
    }
  }

  static Future<void> insertUser(User user) async {
    final Database db = await database;
    await db.insert(
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertEvent(Event event) async {
    final Database db = await database;
    await db.insert(
      'Event',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteEvent(Event event) async {
    final Database db = await database;
    await db.delete(
      'Event',
      where: 'etkinlikAdi = ? AND tarihZaman = ?',
      whereArgs: [event.etkinlikAdi, event.tarihZaman],
    );
  }

  static Future<List<Event>> getAllEvents() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query('Event');
    List<Event> events = results.map((map) => Event(
      etkinlikAdi: map['etkinlikAdi'],
      tarihZaman: map['tarihZaman'],
      konum: map['konum'],
      aciklama: map['aciklama'],
      katilimciAdi: map['katilimciAdi'],
      salon: map['salon'],
      kontenjan: map['kontenjan'],
      ucret: map['ucret'],
      etkinlikTuru: map['etkinlikTuru'],
      resimUrl: map['resimUrl'],
    )).toList();
    return events;
  }

 static Future<List<UserEventSepet>> getUserEvents(String email) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'UserEventSepet',
      where: 'email = ?',
      whereArgs: [email],
    );

    return List.generate(results.length, (index) {
      return UserEventSepet(
        id: results[index]['id'],
        userEmail: results[index]['email'],
        etkinlikAdi: results[index]['etkinlikAdi'],
        tarihZaman: results[index]['tarihZaman'],
        konum: results[index]['konum'],
        ucret: results[index]['ucret'],
      );
    });
  }

  static Future<void> deleteUserEvent(int etkinlikId, String etkinlikAdi) async {
    final db = await database;
    await db.delete(
      'UserEventSepet',
      where: 'id = ?',
      whereArgs: [etkinlikId],
    );
  }

  static Future<void> insertAdmin(Admin admin) async {
    final Database db = await database;
    await db.insert(
      'Admin',
      admin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

static Future<List<UserEvent>> getUserEventsByEmail(String email) async {
  final Database db = await database;
  List<Map<String, dynamic>> results = await db.query(
    'UserEvent',
    where: 'email = ?',
    whereArgs: [email],
  );
  List<UserEvent> userEvents = results.map((map) => UserEvent(
    email: map['email'],
    etkinlikAdi: map['etkinlikAdi'],
    tarihZaman: map['tarihZaman'],
    salon: map['salon'],
    ucret: map['ucret'],
    resimUrl: map['resimurl'] ?? '', 
  )).toList();
  return userEvents;
}

  static Future<void> deleteAdmin(Admin admin) async {
    final Database db = await database;
    await db.delete(
      'Admin',
      where: 'email = ?',
      whereArgs: [admin.email],
    );
  }

  static Future<List<Admin>> getAllAdmins() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query('Admin');
    List<Admin> admins = results.map((map) => Admin(
      name: map['name'],
      email: map['email'],
      password: map['password'],
    )).toList();
    return admins;
  }

  static Future<void> updateUserEvent(String email, String event) async {
    final Database db = await database;
    await db.update(
      'User',
      {'event': event},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  static Future<List<User>> getAllUsers() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query('User');
    List<User> users = results.map((map) => User(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      event: map['event'],
    )).toList();
    return users;
  }

  static Future<void> deleteUser(String email) async {
    final Database db = await database;
    await db.delete(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  static Future<void> insertUserEvent(UserEvent userEvent) async {
  final Database db = await database;
  await db.insert(
    'UserEvent',
    userEvent.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE Event ADD COLUMN resimUrl TEXT;');
  }
}

static Future<void> insertUserEventSepet(UserEventSepet userEventSepet) async {
  final Database db = await database;
  await db.insert(
    'UserEventSepet',
    userEventSepet.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

static Future<void> removeUserEvent(String userEmail, int id) async {
  final db = await database; 
  await db.delete(
    'UserEventSepet',
    where: 'id = ? AND email = ?',
    whereArgs: [id, userEmail],
  );
}

static Future<Event?> getEvent(String etkinlikAdi, String tarihZaman) async {
  final Database db = await database;
  List<Map<String, dynamic>> result = await db.query(
    'Event',
    where: 'etkinlikAdi = ? AND tarihZaman = ?',
    whereArgs: [etkinlikAdi, tarihZaman],
    limit: 1,
  );
  if (result.isNotEmpty) {
    return Event(
      etkinlikAdi: result[0]['etkinlikAdi'],
      tarihZaman: result[0]['tarihZaman'],
      konum: result[0]['konum'],
      aciklama: result[0]['aciklama'],
      katilimciAdi: result[0]['katilimciAdi'],
      salon: result[0]['salon'],
      kontenjan: result[0]['kontenjan'],
      ucret: result[0]['ucret'],
      etkinlikTuru: result[0]['etkinlikTuru'],
      resimUrl: result[0]['resimUrl'],
    );
  } else {
    return null;
  }
}

static Future<void> updateEventKontenjan(String etkinlikAdi, String tarihZaman, int updatedKontenjan) async {
  final Database db = await database;
  await db.update(
    'Event',
    {'kontenjan': updatedKontenjan},
    where: 'etkinlikAdi = ? AND tarihZaman = ?',
    whereArgs: [etkinlikAdi, tarihZaman],
  );
}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDir = await getApplicationDocumentsDirectory();
  String dbPath = join(appDocDir.path, 'donem_projesi2_database.db');
  print('Database Path: $dbPath');
  await DatabaseHelper._initDatabase();
  runApp(MyApp());
}