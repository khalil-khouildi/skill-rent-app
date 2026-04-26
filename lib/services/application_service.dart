import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Apply to a request
  Future<bool> applyToRequest({
    required String requestId,
    required String proposal,
    required double proposedPrice,
  }) async {
    try {
      final userId = _auth.currentUser!.uid;
      
      print('📝 Submitting application for request: $requestId');
      
      // Get user data for the name
      final userData = await _firestore.collection('users').doc(userId).get();
      final userName = userData.data()?['fullName'] ?? 'User';
      
      // Check if already applied to this request
      final existingApplication = await _firestore
          .collection('applications')
          .where('requestId', isEqualTo: requestId)
          .where('freelancerId', isEqualTo: userId)
          .get();
      
      if (existingApplication.docs.isNotEmpty) {
        print('❌ Already applied to this request');
        return false;
      }
      
      // Create the application document
      DocumentReference docRef = _firestore.collection('applications').doc();
      
      await docRef.set({
        'id': docRef.id,
        'requestId': requestId,
        'freelancerId': userId,
        'freelancerName': userName,
        'proposal': proposal,
        'proposedPrice': proposedPrice,
        'status': 'pending', // pending, accepted, rejected
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      print('✅ Application saved with ID: ${docRef.id}');
      
      // Increment applicants count on the request
      final requestRef = _firestore.collection('requests').doc(requestId);
      await requestRef.update({
        'applicantsCount': FieldValue.increment(1),
      });
      
      print('✅ Applicants count incremented');
      return true;
    } catch (e) {
      print('❌ Error applying: $e');
      return false;
    }
  }
  
  // Get all applications for a specific request (for the client)
  Stream<QuerySnapshot> getApplicationsForRequest(String requestId) {
    print('🔍 Fetching applications for request: $requestId');
    return _firestore
        .collection('applications')
        .where('requestId', isEqualTo: requestId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  
  // Get all applications submitted by the current freelancer
  Stream<QuerySnapshot> getMyApplications() {
    final userId = _auth.currentUser!.uid;
    print('🔍 Fetching my applications for user: $userId');
    return _firestore
        .collection('applications')
        .where('freelancerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  
  // Accept an application (client action)
  Future<bool> acceptApplication(String applicationId, String requestId) async {
    try {
      print('📝 Accepting application: $applicationId');
      
      // Update the application status to accepted
      await _firestore.collection('applications').doc(applicationId).update({
        'status': 'accepted',
      });
      
      // Reject all other pending applications for this request
      final otherApps = await _firestore
          .collection('applications')
          .where('requestId', isEqualTo: requestId)
          .where('status', isEqualTo: 'pending')
          .get();
      
      for (var app in otherApps.docs) {
        if (app.id != applicationId) {
          await app.reference.update({'status': 'rejected'});
          print('📝 Rejected application: ${app.id}');
        }
      }
      
      // Update the request status to in_progress
      await _firestore.collection('requests').doc(requestId).update({
        'status': 'in_progress',
      });
      
      print('✅ Application accepted successfully');
      return true;
    } catch (e) {
      print('❌ Error accepting application: $e');
      return false;
    }
  }
  
  // Reject an application (client action)
  Future<bool> rejectApplication(String applicationId) async {
    try {
      print('📝 Rejecting application: $applicationId');
      
      await _firestore.collection('applications').doc(applicationId).update({
        'status': 'rejected',
      });
      
      print('✅ Application rejected successfully');
      return true;
    } catch (e) {
      print('❌ Error rejecting application: $e');
      return false;
    }
  }
  
  // Get application by ID
  Future<Map<String, dynamic>?> getApplication(String applicationId) async {
    try {
      final doc = await _firestore.collection('applications').doc(applicationId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ Error getting application: $e');
      return null;
    }
  }
  
  // Check if user has already applied to a request
  Future<bool> hasApplied(String requestId) async {
    try {
      final userId = _auth.currentUser!.uid;
      final result = await _firestore
          .collection('applications')
          .where('requestId', isEqualTo: requestId)
          .where('freelancerId', isEqualTo: userId)
          .get();
      
      return result.docs.isNotEmpty;
    } catch (e) {
      print('❌ Error checking application: $e');
      return false;
    }
  }
}