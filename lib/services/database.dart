import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorator_app/models/my_user.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference employeeCollectionReference =
      FirebaseFirestore.instance.collection('employee');

  MyUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return MyUserData(
      name: snapshot.get('name'),
      uid: uid,
      email: snapshot.get('email'),
      phoneNumber: snapshot.get('phoneNumber'),
    );
  }

  Future<dynamic> updateUserData(
      {String? name, String? phoneNumber, String? email}) async {
    return await employeeCollectionReference.doc(uid!).set({
      'name': name,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'email': email,
    });
  }

  Stream<MyUserData?> get userData {
    return employeeCollectionReference.doc(uid).snapshots().map(_userDataFromSnapshot);
  } 
}
