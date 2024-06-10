import 'dart:async';

import 'package:checklist/src/data/database_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsDatabase implements DatabaseRepository {
  // attributes
  final SharedPreferences _prefs;
  static const _itemsKey = 'items'; // hier dient es als unique identifier, um die items voneinander unterschieden zu können


  // constructor
  const SharedPrefsDatabase(this._prefs);



  // methodes
  @override
  Future<List<String>?> getItems() async {
    return _prefs.getStringList(_itemsKey) ?? []; // wenn die liste null ist, dann gebe uns eine Leere Liste aus
  }

  @override
  Future<void> removeItem(String item) async {
    final items = _prefs.getStringList(item) ?? [];
    items.remove(item);
    await _prefs.setStringList(_itemsKey, items); // gebe uns hier die Liste ohne das gelöschte item zurück

  }

  @override
  Future<void> storeItem(String item) async {
    final items = _prefs.getStringList(item) ?? [];
    items.add(item);
    await _prefs.setStringList(_itemsKey, items); // gebe uns die Liste mit dem neuen Item zurück
  }
}
