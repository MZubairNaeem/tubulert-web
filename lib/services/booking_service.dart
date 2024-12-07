import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch booking history for a specific patient or doctor
  Future<List<Map<String, dynamic>>> getBookingHistory(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('booking_history')
          .where('user_id', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error fetching booking history: $e");
      return [];
    }
  }
}
