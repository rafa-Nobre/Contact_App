import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact_model.dart';

class ContactController {
  static final ContactController _instance = ContactController.internal();
  factory ContactController() => _instance;

  ContactController.internal();

  Database? _database;
  Future<Database?> get database async {
    _database ??= await initDataBase();
    return _database;
  }

  Future<Database> initDataBase() async {
    String? databasesPath = await getDatabasesPath();
    databasesPath ??= "";
    String path = join(databasesPath, "contacts.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute("CREATE TABLE ${Contact.contactTable}(${Contact.idColumn} INTEGER PRIMARY KEY, "
            "                                 ${Contact.nameColumn} TEXT, "
            "                                 ${Contact.emailColumn} TEXT, "
            "                                 ${Contact.phoneColumn} TEXT, "
            "                                 ${Contact.imgColumn} TEXT) ");
      },
    );
  }

  Future<Contact> saveContact(Contact newContact) async {
    Database? dbContact = await database;
    if (dbContact != null) newContact.id = await dbContact.insert(Contact.contactTable, newContact.toMap());
    return newContact;
  }

  Future<Contact?> getContact(int id) async {
    Database? dbContact = await database;
    if (dbContact != null) {
      List<Map> maps = await dbContact.query(Contact.contactTable,
          columns: [Contact.idColumn, Contact.nameColumn, Contact.emailColumn, Contact.phoneColumn, Contact.imgColumn],
          where: "${Contact.idColumn} = ?",
          whereArgs: [id]);
      if (maps.isNotEmpty) {
        return Contact.fromMap(maps.first);
      } else {
        return null;
      }
    }
    return null;
  }

  Future<int> deleteContact(int id) async {
    Database? dbContact = await database;
    if (dbContact != null) {
      return await dbContact.delete(
        Contact.contactTable,
        where: "${Contact.idColumn} = ?",
        whereArgs: [id],
      );
    } else {
      return 0;
    }
  }

  Future<int> updateContact(Contact currentContact) async {
    Database? dbContact = await database;
    if (dbContact != null) {
      return await dbContact.update(
        Contact.contactTable,
        currentContact.toMap(),
        where: "${Contact.idColumn} = ?",
        whereArgs: [currentContact.id],
      );
    } else {
      return 0;
    }
  }

  Future<List> getAllContact() async {
    Database? dbContact = await database;
    if (dbContact != null) {
      List listMap = await dbContact.query(Contact.contactTable);
      List<Contact> listContacts = [];

      for (Map m in listMap) {
        listContacts.add(Contact.fromMap(m));
      }
      return listContacts;
    } else {
      return [];
    }
  }

  Future<int?> getNumber() async {
    Database? dbContact = await database;
    if (dbContact != null) {
      return Sqflite.firstIntValue(await dbContact.rawQuery("select count(*) from ${Contact.contactTable}"));
    } else {
      return 0;
    }
  }
}
