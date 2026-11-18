import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      String? savedNotes = prefs.getString('notes');

      if (savedNotes != null) {
        setState(() {
          notesList = List<Map<String, dynamic>>.from(
            jsonDecode(savedNotes)
                .map((note) => Map<String, dynamic>.from(note)),
          );
        });
      }
    });
  }

  String selectedCategory = 'Recent';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String noteCategory = 'Home';

  int editIndex = -1;

  List<Map<String, dynamic>> notesList = [];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredNotes = notesList.where((note) {
      bool categoryMatch;

      if (selectedCategory == 'Recent') {
        categoryMatch = true;
      } else if (selectedCategory == 'Favourite') {
        categoryMatch = note['isFavourite'] == true;
      } else {
        categoryMatch = note['category'] == selectedCategory;
      }

      bool searchMatch = note['title'].toString().toLowerCase().contains(
        searchController.text.toLowerCase(),
      );

      return categoryMatch && searchMatch;
    }).toList();

    if (selectedCategory == 'Recent') {
      filteredNotes = filteredNotes.reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController, // 1. Controller ko connect kiya
              onChanged: (value) {
                setState(
                  () {},
                ); // 2. Har letter type hone par list ko refresh karega
              },
              decoration: InputDecoration(
                labelText: 'Search Notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),

            //.....Home..............................
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      backgroundColor: selectedCategory == 'Home'
                          ? const Color.from(
                              alpha: 0.809,
                              red: 0.263,
                              green: 0.875,
                              blue: 0.02,
                            )
                          : const Color.fromRGBO(5, 201, 227, 0.686),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Home';
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home),
                        SizedBox(width: 8),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: Color.fromRGBO(251, 247, 247, 1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Recent button........................
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      backgroundColor: selectedCategory == 'Recent'
                          ? const Color.from(
                              alpha: 0.809,
                              red: 0.263,
                              green: 0.875,
                              blue: 0.02,
                            )
                          : const Color.fromRGBO(5, 201, 227, 0.686),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Recent';
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.recent_actors),
                        SizedBox(width: 8),
                        Text(
                          'Recent',
                          style: TextStyle(
                            color: Color.fromRGBO(251, 247, 247, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  //.........Work..........................
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      backgroundColor: selectedCategory == 'Work'
                          ? const Color.from(
                              alpha: 0.809,
                              red: 0.263,
                              green: 0.875,
                              blue: 0.02,
                            )
                          : const Color.fromRGBO(5, 201, 227, 0.686),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Work';
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.work),
                        SizedBox(width: 8),
                        Text(
                          'Work',
                          style: TextStyle(
                            color: Color.fromRGBO(251, 247, 247, 1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //........Favourite.........................
                  //
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      backgroundColor: selectedCategory == 'Favourite'
                          ? const Color.from(
                              alpha: 0.809,
                              red: 0.263,
                              green: 0.875,
                              blue: 0.02,
                            )
                          : const Color.fromRGBO(5, 201, 227, 0.686),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'Favourite';
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite),
                        SizedBox(width: 8),
                        Text(
                          'Favourite',
                          style: TextStyle(
                            color: Color.fromRGBO(251, 247, 247, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Your Notes",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10.0),

            // Notes Display......................................
            Expanded(
              child: filteredNotes.isEmpty
                  ? const Center(
                      child: Text(
                        'No Notes Found!\nCreate your first note.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
                        final actualIndex = notesList.indexOf(note);

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 12.0),

                          child: ListTile(
                            title: Text(
                              note['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(note['description']),
                                const SizedBox(height: 5),
                                Text(
                                  note['category'],
                                  style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  titleController.text = note['title'];
                                  descriptionController.text =
                                      note['description'];
                                  noteCategory = note['category'];
                                  editIndex = actualIndex;

                                  showDialog(
                                    // screen pe ek popup dialog box show hoga
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setDialogState) {
                                          return AlertDialog(
                                            // ye ek popuop dialog box hai jisme user note ko edit kar sakta hai
                                            title: const Text(
                                              'Edit Note',
                                            ), // ye dialog box ka title hai
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,

                                              children: [
                                                TextField(
                                                  controller: titleController,
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: 'Title',
                                                      ),
                                                ),
                                                TextField(
                                                  controller:
                                                      descriptionController,
                                                  maxLines: 3,
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: 'Description', // ye dialog box me user note ka title aur description edit kar sakta hai
                                                      ),
                                                ),
                                                DropdownButton<String>(
                                                  // ye dialog box me user note ka category edit kar sakta hai
                                                  value: noteCategory, // ye dialog box me user note ka category edit kar sakta hai
                                                  items:
                                                      [
                                                        'Home',
                                                        'Recent',
                                                        'Work',
                                                        'Favourite',
                                                      ].map((category) {
                                                        // ye dialog box me user note ka category edit kar sakta hai
                                                        return DropdownMenuItem(
                                                          // ye dialog box me user note ka category edit kar sakta hai
                                                          value: category,
                                                          child: Text(category),
                                                        );
                                                      }).toList(),
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      setDialogState(() {
                                                        noteCategory = value;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              // ye dialog box me user note ka title aur
                                              // description edit karne ke baad update button click karega to note update ho jayega
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    notesList[editIndex]['title'] =
                                                        titleController.text;
                                                    notesList[editIndex]['description'] =
                                                        descriptionController
                                                            .text;
                                                    notesList[editIndex]['category'] =
                                                        noteCategory;
                                                  });

                                                  SharedPreferences.getInstance()
                                                      .then((prefs) {
                                                        prefs.setString(
                                                          'notes',
                                                          jsonEncode(notesList),
                                                        );
                                                      });

                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Update'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else if (value == 'delete') {
                                  setState(() {
                                    notesList.removeAt(actualIndex);
                                  });

                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setString(
                                      'notes',
                                      jsonEncode(notesList),
                                    );
                                  });
                                } else if (value == 'favourite') {
                                  setState(() {
                                    /*notesList[actualIndex]['isFavourite'] =
                                        !(notesList[actualIndex]['isFavourite']
                                            as bool);*/
                                    notesList[actualIndex]['isFavourite'] =
                                        (notesList[actualIndex]['isFavourite'] ??
                                            false) ==
                                        false;
                                  });

                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setString(
                                      'notes',
                                      jsonEncode(notesList),
                                    );
                                  });
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                                PopupMenuItem(
                                  value: 'favourite',
                                  child: Text('Favourite'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      //................add note button................
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,

        onPressed: () {
          titleController.clear();
          descriptionController.clear();

          noteCategory =
              selectedCategory == 'Recent' || selectedCategory == 'Favourite'
              ? 'Home'
              : selectedCategory;

          showDialog(
            context: context,

            builder: (context) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return AlertDialog(
                    title: const Text('Add New Note'),

                    content: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Title',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Enter Description',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          value: noteCategory,

                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),

                          items: ['Home', 'Recent', 'Work', 'Favourite'].map((
                            category,
                          ) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setDialogState(() {
                              noteCategory = value!;
                            });
                          },
                        ),
                      ],
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          if (titleController.text.trim().isEmpty ||
                              descriptionController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter all details'),
                              ),
                            );

                            return;
                          }

                          setState(() {
                            notesList.add({
                              'title': titleController.text.trim(),
                              'description': descriptionController.text.trim(),
                              'category': noteCategory,
                              'isFavourite': noteCategory == 'Favourite',
                            });
                          });

                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setString('notes', jsonEncode(notesList));
                          });

                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
