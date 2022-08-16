import 'package:firebase_basemodel_example/models/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: (){
                testSave();
              }, child: const Text("Test Save")),

              const SizedBox(height: 20,),

              ElevatedButton(onPressed: (){
                testUpdate();
              }, child: const Text("Test Update")),
            ],
          ),
        ),
      ),
    );
  }

  void testSave(){
    User user = User();
    user.setName('John');
    user.setAge(19);
    user.saveItem('userCollection',onComplete: (error){
      //handle result
    });
  }

  void testUpdate(){
    FirebaseFirestore.instance.collection('userCollection')
        .get()
        .then((value){
          for(DocumentSnapshot doc in value.docs){
            User user = User.fromDocumentSnapshot(doc: doc);
            doc.reference.parent.path;
            user.setCollectionName('userCollection');//needed to update data
            user.setName("Michael");
            user.updateItems();
          }
    });
  }
}
