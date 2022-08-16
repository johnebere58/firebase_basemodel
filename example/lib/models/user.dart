import 'package:firebase_basemodel/firebase_basemodel.dart';

class User extends FirebaseBasemodel{

    User();

    User.fromDocumentSnapshot({required super.doc}) : super.fromDocumentSnapshot();

    User.fromMap({required super.items}) : super.fromMap();

    String getName() => getString('name');

    int getAge() => getInt('age');

    void setName(String name) => put('name', name);

    void setAge(int age) => put('age', age);

}
