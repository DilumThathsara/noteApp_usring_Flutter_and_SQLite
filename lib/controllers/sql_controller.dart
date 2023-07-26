import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_lite/models/note_model.dart';

class SQLController {
  //---create and initialize the db function
  static Future<Database> initDB() async {
    //---this db stores in device file storage system
    //--- andorid, it is typically data/data
    //--- an ISO, it is in the document directory

    final dbPath = await getDatabasesPath();

    //--- create the new path object by providing db name
    final path = join(dbPath, 'notes.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //--- create table here
        await createTables(db);
      },
    );
  }

  //--- create mysql lite tables
  static Future<void> createTables(Database database) async {
    await database.execute(""" 
    CREATE TABLE Notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  //--- add a new note to table
  static Future<void> createNote(String title, String description) async {
    final db = await initDB();

    //---inserting data object
    final data = {
      "title": title,
      "description": description,
    };

    //---inserting notes data
    await db.insert("Notes", data);
  }

  //--- fetch notes from db
  static Future<List<NoteModel>> getNote() async {
    final db = await initDB();

    //---fetching notes from the notes table
    final result = await db.query('Notes', orderBy: "id");

    //---inserting notes data
    return result.map((e) => NoteModel.fromJson(e)).toList();
  }

  //--- update an exisiting note
  static Future<void> updateNote(
    int id,
    String title,
    String description,
  ) async {
    final db = await initDB();

    //---inserting data object
    final data = {
      "title": title,
      "description": description,
      "createdAt": DateTime.now().toString(),
    };

    //---inserting notes data
    //--- using whereArgs prevents sql injection
    await db.update("Notes", data, where: "id = ?", whereArgs: [id]);
  }

  //--- delete an exisiting note
  static Future<void> deleteNote(
    int id,
  ) async {
    final db = await initDB();

    //---delete notes data
    await db.delete("Notes", where: "id = ?", whereArgs: [id]);
  }
}
