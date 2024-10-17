// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/my_transaction.dart';

class TransactionDataBase {
  // Nome do banco de dados e tabela
  static const databaseName = 'transactions.db';
  static const tableName = 'transactions';

  // Instância Singleton da classe TransactionDataBase
  static final TransactionDataBase instance = TransactionDataBase._init();

  // Construtor privado para garantir que a classe seja um Singleton
  TransactionDataBase._init();

  // Variável para armazenar a instância do banco de dados
  static Database? _database;

  // Método para obter o banco de dados
  static Future<Database> getDatabase() async {
    // Se já existir uma instância do banco, retorna ela
    if (_database != null) return _database!;

    // Caso contrário, inicializa o banco
    _database = await _initDB(databaseName);
    return _database!;
  }

  // Inicialização do banco de dados
  static Future<Database> _initDB(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY, 
            title TEXT, 
            value REAL, 
            date TEXT
          )
          ''',
        );
      },
    );
  }

  // Método para inserir transação
  Future<void> insertTransaction(MyTransaction transaction) async {
    final db = await getDatabase();
    await db.insert(
      tableName,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para retornar todas as transações
  Future<List<MyTransaction>> getTransactions() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return MyTransaction.fromMap(maps[i]);
    });
  }

  // Método para remover transação por id
  Future<void> removeTransaction(String id) async {
    final db = await getDatabase();
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}