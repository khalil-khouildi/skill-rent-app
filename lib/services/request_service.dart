import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Post a new request
  Future<bool> postRequest({
    required String title,
    required String description,
    required String category,
    required String budget,
    required String location,
    required String urgency,
  }) async {
    try {
      String userId = _auth.currentUser!.uid;
      
      DocumentReference docRef = _firestore.collection('requests').doc();
      
      await docRef.set({
        'id': docRef.id,
        'userId': userId,
        'title': title,
        'description': description,
        'category': category,
        'budget': budget,
        'location': location,
        'urgency': urgency,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'applicantsCount': 0,
      });
      
      print('✅ Request posted: $title');
      return true;
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }

  // Get all active requests - WITHOUT orderBy to avoid index requirement
  Stream<QuerySnapshot> getActiveRequests() {
    print('🔍 Fetching active requests from Firebase');
    return FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'active')
        .snapshots();  // Removed orderBy temporarily
  }
    // Get user's own requests
  Stream<QuerySnapshot> getUserRequests(String userId) {
    print('🔍 Fetching requests for user: $userId');
    return FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}