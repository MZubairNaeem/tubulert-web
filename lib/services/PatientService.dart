import 'package:cloud_firestore/cloud_firestore.dart';

class PatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add patient data to Firestore
  Future<void> addPatient(String doctorId, String name, String gender,
      String dateAdded, int age, String medicalHistory) async {
    try {
      await _firestore.collection('patients').add({
        'doctor_id': doctorId,
        'name': name,
        'gender': gender,
        'date_added': dateAdded,
        'age': age,
        'medical_history': medicalHistory,
      });
      print("Patient added successfully!");
    } catch (e) {
      print("Error adding patient: $e");
    }
  }

  // Method to fetch the list of patients for a specific doctor
  Future<List<Map<String, dynamic>>> getPatients(String doctorId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('patients')
          .where('doctor_id', isEqualTo: doctorId)
          .get();

      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error fetching patients: $e");
      return [];
    }
  }
}
