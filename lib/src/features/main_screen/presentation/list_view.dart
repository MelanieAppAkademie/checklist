import 'package:checklist/src/data/database_repository.dart';
import 'package:flutter/material.dart';

class ItemsListView extends StatefulWidget {
  final DatabaseRepository databaseRepository;

  const ItemsListView({super.key, required this.databaseRepository});

  @override
  State<ItemsListView> createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  late Future<List<String>?> _itemsFuture;

  @override
  void initState() {
    super.initState();
// die Items müssen beim initialisieren noch mal aus der Datenbank geladen werden
    _loadItems();

  }

  // Hier werden die Itens aus der Datenbank geholt
  void _loadItems() {
    setState(() {
      _itemsFuture = widget.databaseRepository.getItems();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<String>?>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading items'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No items found'),
            );
          } else {
            final itemsList = snapshot.data!;
            return ListView.builder(
              itemCount: itemsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(itemsList[index]),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await widget.databaseRepository
                              .removeItem(itemsList[index]);
                          // Items neu laden nach dem Entfernen
                          _loadItems();
                         
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
