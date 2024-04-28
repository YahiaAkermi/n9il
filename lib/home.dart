import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:untitled/note.dart';
import "package:get/get.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? title;
  String? description;
  DateTime now = DateTime.now();
  Map<int, Note> notes = {};
  int i = 0;
  Note? selectedNote;

  void submit(String tit, String des) {
    setState(() {
      notes.addAll({i: Note(id: i, title: tit, description: des, date: now.toString())});
    });
    i++;
    Get.back();
  }

  FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    await flutterTts.setLanguage('us-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }


  void deleteNote(int id) {
    setState(() {
      notes.removeWhere((key, value) => value.id == id);
      selectedNote = null;
    });
  }

  Future<bool> showConfirmationDialog(BuildContext context, int id) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 202, 224, 55), // Changed app bar color
        title: Text("Notes"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                Note note = notes.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Changed container background color
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.note),
                      title: Text(note.title!, style: TextStyle(color: Colors.black)), // Changed text color
                      subtitle: Text(note.description.toString(), style: TextStyle(color: Colors.grey)), // Changed text color
                      onTap: () {
                        print("ded");
                        Get.toNamed("/details", arguments: note);
                      },
                      onLongPress: () async {
                        bool shouldDelete = await showConfirmationDialog(context, note.id);
                        if (shouldDelete) {
                          deleteNote(note.id);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      Note note = notes.values.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Changed container background color
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.note),
                            title: Text(note.title!, style: TextStyle(color: Colors.black)), // Changed text color
                            subtitle: Text(note.description.toString(), style: TextStyle(color: Colors.grey)), // Changed text color
                            onTap: () {
                              print("ded");
                              setState(() {
                                selectedNote = note;
                              });
                            },
                            onLongPress: () async {
                              bool shouldDelete = await showConfirmationDialog(context, note.id);
                              if (shouldDelete) {
                                deleteNote(note.id);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: selectedNote!= null
                      ? Container(
                    color: Colors.grey[200], // Changed container background color
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note Title:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Changed text color
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            selectedNote!.title!,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Note Description:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Changed text color
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            selectedNote!.description.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Date:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Changed text color
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            selectedNote!.date.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          TextButton(onPressed: (){
                            speak(selectedNote!.description);
                          }, child: Text("Play"))
                        ],
                      ),
                    ),
                  )
                      : Container(),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("de");
          Get.defaultDialog(
              title: "Note",
              titleStyle: TextStyle(fontFamily: 'Cairo'),
              content: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: titleController,
                            style: TextStyle(color: Colors.black), // Changed text color
                            onSaved: (value) {
                              title = value;
                            },
                            onChanged: (value) {
                              title = value;
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please enter the title of Note";
                              }
                              if (value.isEmpty) {
                                return "Please enter the title of Note";
                              }
                              return null;
                            },
                            decoration: InputDecoration(hintText: "Note Title.....")),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: descriptionController,
                            style: TextStyle(color: Colors.black), // Changed text color
                            onSaved: (value) {
                              description = value;
                            },
                            onChanged: (value) {
                              description = value;
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please enter the content of Note";
                              }
                              if (value.isEmpty) {
                                return "Please enter the content of Note";
                              }
                              return null;
                            },
                            decoration: InputDecoration(hintText: "Note Description.....")),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.transparent,
                              ),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue.withOpacity(0.1)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: BorderSide(
                                        color: Colors.blue,
                                      )))),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontFamily: 'Cairo', color: Colors.blue),
                          )),
                      SizedBox(width: 10),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.blue,
                              ),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(0.1)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: BorderSide(
                                        color: Colors.blue,
                                      )))),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              print(title);
                              print(description);
                              submit(title!, description!);
                            }
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                fontFamily: 'Cairo', color: Colors.white),
                          )),
                    ],
                  ),
                ],
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
