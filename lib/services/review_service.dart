import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Leave a review for a freelancer
  Future<bool> leaveReview({
    required String requestId,
    required String freelancerId,
    required double rating,
    required String comment,
  }) async {
    try {
      final clientId = _auth.currentUser!.uid;
      final clientData = await _firestore.collection('users').doc(clientId).get();
      final clientName = clientData.data()?['fullName'] ?? 'Client';
      
      final requestDoc = await _firestore.collection('requests').doc(requestId).get();
      final requestTitle = requestDoc.data()?['title'] ?? 'Service';
      
      // Check if review already exists
      final existingReview = await _firestore
          .collection('reviews')
          .where('requestId', isEqualTo: requestId)
          .get();
      
      if (existingReview.docs.isNotEmpty) {
        print('❌ Review already exists');
        return false;
      }
      
      // Create review
      await _firestore.collection('reviews').add({
        'requestId': requestId,
        'requestTitle': requestTitle,
        'freelancerId': freelancerId,
        'clientId': clientId,
        'clientName': clientName,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Update freelancer stats (missions = review count, success = rating percentage)
      await _updateFreelancerStats(freelancerId);
      
      // Mark request as completed
      await _firestore.collection('requests').doc(requestId).update({
        'status': 'completed',
      });
      
      print('✅ Review saved, request completed, stats updated');
      return true;
    } catch (e) {
      print('❌ Error leaving review: $e');
      return false;
    }
  }
  
  // Update freelancer's stats (missions = total reviews, success = average rating percentage)
  Future<void> _updateFreelancerStats(String freelancerId) async {
    try {
      // Get all reviews for this freelancer
      final reviews = await _firestore
          .collection('reviews')
          .where('freelancerId', isEqualTo: freelancerId)
          .get();
      
      final totalReviews = reviews.docs.length;
      
      // Calculate average rating
      double totalRating = 0;
      for (var review in reviews.docs) {
        totalRating += review['rating'] as double;
      }
      
      final averageRating = totalReviews > 0 ? totalRating / totalReviews : 0;
      
      // Success rate = (average rating / 5) * 100
      final successRate = averageRating > 0 ? (averageRating / 5 * 100).round() : 0;
      
      // Update the user document
      await _firestore.collection('users').doc(freelancerId).update({
        'missionsCompleted': totalReviews,
        'rating': averageRating,
        'totalReviews': totalReviews,
        'successRate': successRate,
      });
      
      print('✅ Updated freelancer stats: missions=$totalReviews, rating=$averageRating, success=$successRate%');
    } catch (e) {
      print('❌ Error updating freelancer stats: $e');
    }
  }
  
  // Get reviews for a freelancer
  Stream<QuerySnapshot> getFreelancerReviews(String freelancerId) {
    return _firestore
        .collection('reviews')
        .where('freelancerId', isEqualTo: freelancerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
  
  // Check if a request already has a review
  Future<bool> hasReview(String requestId) async {
    final existing = await _firestore
        .collection('reviews')
        .where('requestId', isEqualTo: requestId)
        .get();
    
    return existing.docs.isNotEmpty;
  }
}