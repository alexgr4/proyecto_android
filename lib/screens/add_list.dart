import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:proyecto_android/model/media.dart';
import 'package:proyecto_android/model/user.dart';
import 'package:proyecto_android/restart.dart';

import '../globals.dart' as globals;

import 'package:flutter/material.dart';

class AddList extends StatefulWidget {
  final int id;
  const AddList({Key? key, required this.id}) : super(key: key);

  @override
  _AddListState createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  late TextEditingController controller;

  late String query;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    query = '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final media = db.collection("/users/${globals.userId}/media");
    final userLists = db.collection("/users");
    return Theme(
      data: ThemeData(fontFamily: 'MadeTommy'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: globals.orange,
          title: const Text('Add to list...'),
          centerTitle: true,
        ),
        backgroundColor: globals.darkGrey,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
              stream: mediaSnapshots(globals.userId, widget.id),
              builder: (
                BuildContext context,
                AsyncSnapshot<Media?> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final listInfo = snapshot.data!;
                return StreamBuilder(
                  stream: userSnapshots(globals.userId),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<MyUser?> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final docSnapshot = snapshot.data;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (listInfo.isMovie) {
                              if (!listInfo.isWatched) {
                                media.doc('M-${widget.id}').update({
                                  'list': FieldValue.arrayUnion(['Watched']),
                                });
                              } else {
                                media.doc('M-${widget.id}').update({
                                  'list': FieldValue.arrayRemove(['Watched']),
                                });
                              }
                            } else {
                              if (!listInfo.isWatched) {
                                media.doc('S-${widget.id}').update({
                                  'list': FieldValue.arrayUnion(['Watched']),
                                });
                              } else {
                                media.doc('S-${widget.id}').update({
                                  'list': FieldValue.arrayRemove(['Watched']),
                                });
                              }
                            }
                          },
                          child: Card(
                            color: listInfo.isWatched
                                ? globals.orange
                                : globals.lightGrey,
                            child: ListTile(
                              leading: listInfo.isWatched
                                  ? Icon(
                                      Icons.check_box,
                                      color: globals.darkGrey,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      color: globals.darkGrey,
                                    ),
                              title: Text(
                                'Watched',
                                style: TextStyle(
                                    color: globals.darkGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (listInfo.isMovie) {
                              if (!listInfo.isLater) {
                                media.doc('M-${widget.id}').update({
                                  'list': FieldValue.arrayUnion(['Later']),
                                });
                              } else {
                                media.doc('M-${widget.id}').update({
                                  'list': FieldValue.arrayRemove(['Later']),
                                });
                              }
                            } else {
                              if (!listInfo.isLater) {
                                media.doc('S-${widget.id}').update({
                                  'list': FieldValue.arrayUnion(['Later']),
                                });
                              } else {
                                media.doc('S-${widget.id}').update({
                                  'list': FieldValue.arrayRemove(['Later']),
                                });
                              }
                            }
                          },
                          child: Card(
                            color: listInfo.isLater
                                ? globals.orange
                                : globals.lightGrey,
                            child: ListTile(
                              leading: listInfo.isLater
                                  ? Icon(
                                      Icons.check_box,
                                      color: globals.darkGrey,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      color: globals.darkGrey,
                                    ),
                              title: Text(
                                'Later',
                                style: TextStyle(
                                    color: globals.darkGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ),
                        for (int i = 3; i < docSnapshot!.lists.length; i++)
                          GestureDetector(
                            onTap: () {
                              listInfo.custom = docSnapshot.lists[i];

                              if (listInfo.isMovie) {
                                if (!listInfo.isCustomList) {
                                  media.doc('M-${widget.id}').update({
                                    'list': FieldValue.arrayUnion(
                                        [docSnapshot.lists[i]]),
                                  });
                                } else {
                                  media.doc('M-${widget.id}').update({
                                    'list': FieldValue.arrayRemove(
                                        [docSnapshot.lists[i]]),
                                  });
                                }
                              } else {
                                if (!listInfo.isCustomList) {
                                  media.doc('S-${widget.id}').update({
                                    'list': FieldValue.arrayUnion(
                                        [docSnapshot.lists[i]]),
                                  });
                                  debugPrint(listInfo.isCustomList.toString());
                                } else {
                                  media.doc('S-${widget.id}').update({
                                    'list': FieldValue.arrayRemove(
                                        [docSnapshot.lists[i]]),
                                  });
                                  debugPrint(listInfo.isCustomList.toString());
                                }
                              }
                              /* debugPrint(listInfo.custom);
                              debugPrint(listInfo.isCustomList.toString());
                              debugPrint(listInfo.lists.toString()); */
                            },
                            child: Card(
                              color: listInfo.isCustomList
                                  ? globals.orange
                                  : globals.lightGrey,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: ListTile(
                                      leading: listInfo.isCustomList
                                          ? Icon(
                                              Icons.check_box,
                                              color: globals.darkGrey,
                                            )
                                          : Icon(
                                              Icons.check_box_outline_blank,
                                              color: globals.darkGrey,
                                            ),
                                      title: Text(
                                        docSnapshot.lists[i],
                                        style: TextStyle(
                                            color: globals.darkGrey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      userLists.doc(globals.userId).update({
                                        'lists': FieldValue.arrayRemove(
                                            [docSnapshot.lists[i]]),
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Icon(
                                        Icons.delete,
                                        color: globals.darkGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                flex: 3,
                                child: TextField(
                                  onChanged: (text) {
                                    setState(() {
                                      query = text;
                                    });
                                  },
                                  controller: controller,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Add your custom list!',
                                    hintStyle:
                                        TextStyle(color: globals.lightGrey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: globals.orange),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: globals.orange),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: globals.orange,
                                        minimumSize: const Size.fromHeight(40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        )),
                                    onPressed: () {
                                      userLists.doc(globals.userId).update({
                                        'lists': FieldValue.arrayUnion([query]),
                                      });
                                    },
                                    child: const Text('Add list')))
                          ],
                        )
                      ],
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
