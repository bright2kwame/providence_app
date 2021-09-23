import 'user_model.dart';
import 'all_model_data.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DBOperations {
  // Define a function that inserts dogs into the database
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await ManageDatabase().initialise();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<User>> users() async {
    // Get a reference to the database.
    final db = await ManageDatabase().initialise();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      var data = maps[i];
      return parseQueryData(data);
    });
  }

  User parseQueryData(dynamic data) {
    return User(
      id: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      fullName: data['fullName'],
      email: data['email'],
      phone: data['phone'],
      avatar: data['avatar'],
      token: data['token'],
    );
  }

  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final db = await ManageDatabase().initialise();

    // Update the given Dog.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the User has a matching id.
      where: 'id = ?',
      // Pass the User's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );
  }

  //MARK: get user
  Future<User> getUser() async {
    final db = await ManageDatabase().initialise();
    var queryResult = await db.query('users', limit: 1);
    return parseQueryData(queryResult[0]);
  }

  Future<void> deleteUser(int id) async {
    // Get a reference to the database.
    final db = await ManageDatabase().initialise();

    // Remove the Dog from the database.
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the User's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
