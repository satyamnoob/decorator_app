import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {


  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('employee');
}
