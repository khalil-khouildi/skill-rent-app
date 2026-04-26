import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userData;
  
  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isAuthenticated => _user != null;
  String get userId => _user?.uid ?? '';
  String get userRole => _userData?['role'] ?? '';
  String get userName => _userData?['fullName'] ?? '';
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userData = null;
        notifyListeners();
      }
    });
  }
  
  Future<void> _loadUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(_user!.uid).get().timeout(const Duration(seconds: 10));
        if (doc.exists) {
          _userData = doc.data() as Map<String, dynamic>;
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
      notifyListeners();
    }
  }
  
  Future<bool> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ).timeout(const Duration(seconds: 10));
      _user = result.user;
      await _loadUserData();
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      
      // Check if user exists in Firestore
      DocumentSnapshot doc = await _firestore.collection('users').doc(result.user!.uid).get();
      if (!doc.exists) {
        // Create new user profile
        await _firestore.collection('users').doc(result.user!.uid).set({
          'uid': result.user!.uid,
          'fullName': result.user!.displayName ?? 'Google User',
          'email': result.user!.email ?? '',
          'role': '',
          'createdAt': FieldValue.serverTimestamp(),
          'avatarUrl': result.user!.photoURL ?? '',
          'rating': 0.0,
          'totalReviews': 0,
          'bio': '',
          'location': '',
          'missionsCompleted': '0',
          'successRate': '0',
        });
      }
      
      _user = result.user;
      await _loadUserData();
      notifyListeners();
      return true;
    } catch (e) {
      print('Google Sign-In error: $e');
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'fullName': fullName,
        'email': email.trim(),
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'avatarUrl': '',
        'rating': 0.0,
        'totalReviews': 0,
        'bio': '',
        'location': '',
        'missionsCompleted': '0',
        'successRate': '0',
      });
      
      _user = result.user;
      await _loadUserData();
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print('Registration error: ${e.message}');
      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }
  
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _userData = null;
    notifyListeners();
  }
  
  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
    await _loadUserData();
    notifyListeners();
  }
}