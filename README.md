# Firebase Basemodel

A implementation of Firebase firebase_basemodel

## Getting Started
This is a simple plugin to implement firebase functions in your flutter project

[![Buy Me A Coffee](https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png "Buy Me A Coffee")](https://www.buymeacoffee.com/johnebere58 "Buy Me A Coffee")

## Installation
To use this plugin, add `firebase_basemodel` as a dependency in your pubspec.yaml file.

```
dependencies:
  flutter:
    sdk: flutter

dialogpack:
  git:
    url: git://github.com/johnebere58/firebase_basemodel.git
    ref: master # branch name

```

## Usage to save new data
To save a new data to your firebase collection simply to this

```
 User user = User();
    user.setName('John');
    user.setAge(19);
    user.saveItem('userCollection',onComplete: (error){
      //handle result
    });
```

## Usage to update data in firebase collection
To save a new data to your firebase collection simply to this

```
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
    
```





This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

