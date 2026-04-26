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
      
      final userData = await _firestore.collection('users').doc(userId).get();
      final userName = userData.data()?['fullName'] ?? 'User';
      
      // Check if already applied
      final existingApplication = await _firestore
          .collection('applications')
          .where('requestId', isEqualTo: requestId)
          .where('freelancerId', isEqualTo: userId)
          .get();
      
      if (existingApplication.docs.isNotEmpty) {
        print('❌ Already applied to this request');
        return false;
      }
      
      DocumentReference docRef = _firestore.collection('applications').doc();
      
      await docRef.set({
        'id': docRef.id,
        'requestId': requestId,
        'freelancerId': userId,
        'freelancerName': userName,
        'proposal': proposal,
        'proposedPrice': proposedPrice,
        'status': 'pending',
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
  
  // Get applications for a specific request
  Stream<QuerySnapshot> getApplicationsForRequest(String requestId) {
    print('🔍 Fetching applications for request: $requestId');
    return _firestore
        .collection('applications')
        .where('requestId', isEqualTo: requestId)
        .snapshots();
  }
  
  // Get freelancer's applications
  Stream<QuerySnapshot> getMyApplications() {
    final userId = _auth.currentUser!.uid;
    print('🔍 Fetching my applications for user: $userId');
    return _firestore
        .collection('applications')
        .where('freelancerId', isEqualTo: userId)
        .snapshots();
  }
  
  // Accept an application
Future<bool> acceptApplication(
  String applicationId, 
  String requestId, 
  String freelancerId, 
  String freelancerName
) async {
  try {
    print('📝 Accepting application: $applicationId');
    print('📝 Freelancer ID: $freelancerId');
    print('📝 Freelancer Name: $freelancerName');
    
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
    
    // IMPORTANT: Update the request with the accepted freelancer info
    final requestRef = _firestore.collection('requests').doc(requestId);
    
    // First, check what's currently in the request
    final requestDoc = await requestRef.get();
    print('📝 Current request data: ${requestDoc.data()}');
    
    // Update the request
    await requestRef.update({
      'status': 'in_progress',
      'acceptedFreelancerId': freelancerId,
      'acceptedFreelancerName': freelancerName,
    });
    
    // Verify the update worked
    final updatedDoc = await requestRef.get();
    print('📝 Updated request data: ${updatedDoc.data()}');
    print('✅ Request updated - Status: in_progress');
    print('✅ Accepted freelancer ID: $freelancerId');
    print('✅ Accepted freelancer name: $freelancerName');
    
    return true;
  } catch (e) {
    print('❌ Error accepting application: $e');
    return false;
  }
}
  
  // Reject an application
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
  
  // Check if user has already applied
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