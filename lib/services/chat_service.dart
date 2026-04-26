import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create or get existing chat between two users
  Future<String> getOrCreateChat(String otherUserId, String otherUserName) async {
    final currentUserId = _auth.currentUser!.uid;
    final currentUser = _auth.currentUser!;
    String currentUserName = currentUser.displayName ?? 'User';
    
    // Try to get current user name from Firestore if not available
    if (currentUserName == 'User') {
      final userDoc = await _firestore.collection('users').doc(currentUserId).get();
      currentUserName = userDoc.data()?['fullName'] ?? 'User';
    }
    
    // Check if chat already exists
    final existingChat = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();
    
    for (var doc in existingChat.docs) {
      final participants = doc['participants'] as List;
      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }
    
    // Create new chat
    final newChatRef = _firestore.collection('chats').doc();
    await newChatRef.set({
      'id': newChatRef.id,
      'participants': [currentUserId, otherUserId],
      'participantNames': {
        currentUserId: currentUserName,
        otherUserId: otherUserName,
      },
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    return newChatRef.id;
  }

  // Send a message
  Future<void> sendMessage(String chatId, String message) async {
    final currentUserId = _auth.currentUser!.uid;
    
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': currentUserId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
    
    // Update last message in chat
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get messages stream for a chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get user's chats - WITHOUT orderBy to avoid index requirement
  Stream<QuerySnapshot> getUserChats() {
    final currentUserId = _auth.currentUser!.uid;
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots();  // Removed orderBy temporarily
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatId) async {
    final currentUserId = _auth.currentUser!.uid;
    
    final unreadMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('read', isEqualTo: false)
        .get();
    
    for (var message in unreadMessages.docs) {
      await message.reference.update({'read': true});
    }
  }

  // Get unread count for a chat
  Future<int> getUnreadCount(String chatId) async {
    final currentUserId = _auth.currentUser!.uid;
    
    final unreadMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isNotEqualTo: currentUserId)
        .where('read', isEqualTo: false)
        .get();
    
    return unreadMessages.docs.length;
  }

  // Get other participant info
  Future<Map<String, dynamic>> getOtherParticipant(String chatId) async {
    final currentUserId = _auth.currentUser!.uid;
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    final participants = chatDoc['participants'] as List;
    final otherUserId = participants.firstWhere((id) => id != currentUserId);
    
    final userDoc = await _firestore.collection('users').doc(otherUserId).get();
    return userDoc.data() as Map<String, dynamic>;
  }
}