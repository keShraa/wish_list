import 'dart:async';
import 'dart:io';
import 'package:wish_list/models/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wish_list/models/article.dart';

class DatabaseClient {

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      // Create this database
      _database = await create();
      return _database;
    }
  }


  /* CREATION DE LA BDD */

  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String databaseDirectory = join(directory.path, 'database.db');
    var bdd = await openDatabase(databaseDirectory, version: 1, onCreate: _onCreate);
    return bdd;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("""
    CREATE TABLE item (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL)
    """
    );

    await db.execute("""
    CREATE TABLE article (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    item INTEGER,
    price TEXT,
    store TEXT,
    image TEXT)
    """);
  }


  /* ECRITURE DES DONNEES */

  Future<Item> addItem(Item item) async {
    Database myDatabase = await database;
    item.id = await myDatabase.insert('item', item.toMap());
    return item;
  }

  /* MISE A JOUR DES DONNEES */

  Future<int> updateItem(Item item) async {
    Database myDatabase = await database;
    return myDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  /* MISE A JOUR OU INSERER DES DONNEES */
  // Item
  Future<Item> upsertItem(Item item) async {
    Database myDatabase = await database;
    if (item.id == null) {
      item.id = await myDatabase.insert('item', item.toMap());
    } else {
      await myDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }
  // Article
  Future<Article> upsertArticle(Article article) async {
    Database myDatabase = await database;
    (article.id == null)
    ? article.id = await myDatabase.insert('article', article.toMap())
        : await myDatabase.update('article', article.toMap(), where: 'id = ?', whereArgs: [article.id]);
    return article;
  }

  /* SUPPRESSION DES DONNEES */

  Future<int> delete(int id, String table) async {
    Database myDatabase = await database;
    await myDatabase.delete('article', where: 'item = ?', whereArgs: [id]);
    return await myDatabase.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  /* LECTURE DES DONNEES */
  // Item
  Future<List<Item>> allItems() async {
    Database myDatabase = await database;
    List<Map<String, dynamic>> result = await myDatabase.rawQuery("SELECT * FROM item");
    List<Item> items = [];
    result.forEach((map) {
      Item item = new Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }
  // Article
  Future<List<Article>> allArticles(int item) async {
    Database myDatabase = await database;
    List<Map<String, dynamic>> result = await myDatabase.query('article', where: 'item = ?', whereArgs: [item]);
    List<Article> articles = [];
    result.forEach((map) {
      Article article = Article();
      article.fromMap(map);
      articles.add(article);
    });
    return articles;
  }
}