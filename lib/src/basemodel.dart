import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseBasemodel {
  Map<String, dynamic> items = {}; //utilized in app

  Map<String, dynamic> itemsToUpdate = {}; //to be pushed online

  final String collectionNameKey = 'collectionName'; //The collection that holds the data

  final String documentIdKey = 'documentId'; //The document id of the document

  /// Very important please when declaring this in your sub classes
  /// Implement the documentSnapshotData or
  /// Implement the documentSnapshot
  /// one must be implemented and one set to null
  ///
  // FirebaseBasemodel({Map? documentSnapshotData,
  //   DocumentSnapshot? documentSnapshot}){
  //   if(documentSnapshotData!=null){
  //     this.items = Map.from(documentSnapshotData);
  //   }
  //   if(documentSnapshot!=null){
  //     this.items = documentSnapshot.data() as Map<String, dynamic>;
  //   }
  // }
  FirebaseBasemodel();

  FirebaseBasemodel.fromMap({required Map items}) {
    this.items = Map.from(items);
  }

  FirebaseBasemodel.fromDocumentSnapshot({
    required DocumentSnapshot doc,
  }) {
    items = doc.data() as Map<String, dynamic>;
    items[documentIdKey] = doc.id;
  }

  void setDocumentId(String id){
    items[documentIdKey] = id;
  }

  void setCollectionName(String name){
    items[collectionNameKey] = name;
  }

  void put(String key, dynamic value) {
    items[key] = value;
    itemsToUpdate[key] = value;
  }

  void putItemInList(String key, dynamic value, {bool add = true}) {
    List list = items[key] ?? [];
    if (add) {
      list.add(value);
    } else {
      list.remove(value);
    }
    items[key] = list;
    itemsToUpdate[key] =
    add ? FieldValue.arrayUnion([value]) : FieldValue.arrayRemove([value]);
  }

  void incrementIntValue(String key, int value) {
    num item = items[key] ?? 0;
    item = item + value;
    items[key] = item;
    itemsToUpdate[key] = FieldValue.increment(value);
  }

  void remove(String key) {
    items.remove(key);
    itemsToUpdate[key] = null;
  }

  dynamic get(String key) {
    return items[key];
  }

  int getInt(String key) {
    dynamic value = items[key];
    return value is! num ? 0 : (int.parse(value.toString()));
  }

  String getString(String key) {
    dynamic value = items[key];

    return value == null || value is! String ? "" : value.toString();
  }

  bool getBoolean(String key) {
    dynamic value = items[key];
    return value == null || value is! bool ? false : value;
  }

  List getList(String key) {
    dynamic value = items[key];
    return value == null || value is! List ? [] : List.from(value);
  }

  Map getMap(String key) {
    dynamic value = items[key];
    return value == null || value is! Map
        ? <String, String>{}
        : Map.from(value);
  }

  void saveItem(
    String collectionName, {
    Function(String? error)? onComplete,
  }) async {
    FirebaseFirestore.instance
        .collection(collectionName).add(items,)
        .then((value) async {
      onComplete!(null);
    }, onError: (e) async {
      onComplete!("Error occurred, check your internet and try again");
    }).timeout(const Duration(seconds: 10));
  }

  void saveItemWithDocumentId(
    String collectionName, {
    required String documentId,
    Function(String? error)? onComplete,
    required bool mergeData
  }) async {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .set(items,SetOptions(merge: mergeData))
        .then((value) async {
      onComplete!(null);
    }, onError: (e) async {
      onComplete!("Error occurred, check your internet and try again");
    }).timeout(const Duration(seconds: 10));
  }

  void updateItems({String? collectionName, String? documentId,
    Function(String? error)? onComplete}) async {

      collectionName = collectionName ?? items[collectionNameKey];
      documentId = documentId ?? items[documentIdKey];
      if(collectionName==null)throw "collectionName not specified";
      if(documentId==null)throw "documentId not specified";

      try {
        dynamic firestore = FirebaseFirestore.instance;
        await firestore.runTransaction((transaction) async {

          DocumentReference itemRef = firestore.collection(collectionName).doc(documentId);

          DocumentSnapshot snapshot = await transaction.get(itemRef);

          if (!snapshot.exists) throw "snapshot does not exist";

          transaction.update(itemRef, itemsToUpdate);

          }, timeout: const Duration(seconds: 30));
        onComplete!(null);
      } catch (e) {
        onComplete!(e.toString());
      }
  }


  void deleteItem({String? collectionName,String? documentId}) {
    collectionName = collectionName ?? items[collectionNameKey];
    documentId = documentId ?? items[documentIdKey];
    if(collectionName==null)throw "collection name not specified";
    if(documentId==null)throw "documentId not specified";

    FirebaseFirestore.instance.collection(collectionName).doc(documentId).delete();

    for (var mapItem in items.entries) {
      var mapValue = mapItem.value;
      if (mapValue is String) {
        String key = mapItem.key;
        if (key.startsWith("ref")) {
          FirebaseStorage.instance.ref(mapValue).delete();
        }
      } else if (mapValue is List && mapItem.key.startsWith("ref")) {
        for (String ref in mapValue) {
          FirebaseStorage.instance.ref(ref).delete();
        }
      } else if (mapValue is List) {
        List mediaFiles = mapValue;
        for (int i = 0; i < mediaFiles.length; i++) {
          dynamic media = mediaFiles[i];
          if (media is! Map) continue;
          for (var item in media.entries) {
            var key = item.key;
            var value = item.value;
            if (value == null) continue;
            if (key.startsWith("ref")) {
              FirebaseStorage.instance.ref(value).delete();
            }
          }
        }
      }
    }

  }
}



