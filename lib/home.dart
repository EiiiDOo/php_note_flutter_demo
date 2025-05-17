import 'package:flutter/material.dart';
import 'package:php_note_demo/components/crud.dart';
import 'package:php_note_demo/components/custom_dialog.dart';
import 'package:php_note_demo/constant/link_api.dart';
import 'package:php_note_demo/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map> notes = [];
  final Crud _crud = Crud();
  Future<void> getNotes() async {
    Map<String, dynamic>? res = await _crud.postRequest(linkView, {
      'id': sharedPreferences.getString('id'),
    });
    if (res != null && res['status'] == 'success') {
      List data = res['data'];
      final List<Map<String, String>> parsedNotes =
          data.map<Map<String, String>>((note) {
            return {
              'notes_id': note['notes_id']?.toString() ?? '',
              'notes_title': note['notes_title']?.toString() ?? '',
              'notes_content': note['notes_content']?.toString() ?? '',
              'notes_image': note['notes_image']?.toString() ?? '',
              'notes_user': note['notes_user']?.toString() ?? '',
            };
          }).toList();
      setState(() {
        notes.addAll(parsedNotes);
      });
    } else {
      customDialog(context, 'Error', 'Can\'t fetch data', dismissible: true);
    }
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  List<String> items = List.generate(20, (i) => 'Item #${i + 1}');

  Future<void> _handleRefresh() async {
    // Simulate fetching new data from an API, database, etc.
    await Future.delayed(Duration(seconds: 2));

    // Update the list (prepend new items, for example).
    setState(() {
      final nextIndex = items.length + 1;
      items = List.generate(5, (i) => 'New Item #${nextIndex + i}') + items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (sharedPreferences.getString('id') != null)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(
                          '⚠️ Sign Out ',
                          textAlign: TextAlign.center,
                        ),
                        content: Text('Are you sure you want to sign out'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              sharedPreferences.clear();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/sign-in',
                                (route) => false,
                              );
                            },
                            child: Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              },
              icon: Icon(Icons.logout_rounded, color: Colors.red[900]),
            ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Home page'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child:
            notes.isEmpty
                ? ListView.builder(
                  itemCount: notes.length,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                  itemBuilder:
                      (context, index) => ListTile(title: Text(items[index])),
                  // (context, index) => _cardNotes(notes.elementAt(index)),
                )
                : Center(child: Text('Notes is Empty, Add One.')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  _cardNotes(Map note) {
    return Card(
      elevation: 15,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              'name',
              errorBuilder:
                  (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListTile(
              title: Text('${note['notes_title']}'),
              subtitle: Text(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                '${note['notes_content']}',
              ),

              trailing: Column(
                spacing: 10,
                children: [
                  Expanded(
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        customDialog(
                          context,
                          'Delete Note',
                          'Are You sure to delete this note.',
                          dismissible: true,
                          actions: [
                            TextButton(
                              onPressed: () async {
                                var res = await _crud.postRequest(linkDelete, {
                                  'id': note['notes_id'],
                                });
                                if (res != null && res['status'] == 'success') {
                                  notes.remove(note);
                                  setState(() {});
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Delete'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
