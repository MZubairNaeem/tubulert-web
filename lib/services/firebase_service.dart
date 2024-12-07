import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> fetchUsers(String userType) async {
    var snapshot = await _firestore
        .collection('users')
        .where('userType', isEqualTo: userType)
        .get();

    return snapshot.docs;
  }
}
