import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/post_request_screen.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }
  
  // RUN THIS ONCE TO UPDATE ALL FREELANCER STATS
  // After running, you can comment or remove this line
  await updateAllFreelancerStats();
  
  runApp(const MyApp());
}

// TEMPORARY FUNCTION - Run once to update all freelancer stats
// After running successfully, you can delete this function
Future<void> updateAllFreelancerStats() async {
  try {
    print('📊 Starting stats update for all freelancers...');
    
    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'freelancer')
        .get();
    
    print('📊 Found ${users.docs.length} freelancers');
    
    int updatedCount = 0;
    
    for (var user in users.docs) {
      final userId = user.id;
      final userName = user.data()['fullName'] ?? 'Unknown';
      
      // Get all reviews for this freelancer
      final reviews = await FirebaseFirestore.instance
          .collection('reviews')
          .where('freelancerId', isEqualTo: userId)
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
      await user.reference.update({
        'missionsCompleted': totalReviews,
        'rating': averageRating,
        'totalReviews': totalReviews,
        'successRate': successRate,
      });
      
      updatedCount++;
      print('✅ Updated $userName: missions=$totalReviews, rating=${averageRating.toStringAsFixed(1)}, success=$successRate%');
    }
    
    print('✅✅✅ Successfully updated $updatedCount freelancers! ✅✅✅');
  } catch (e) {
    print('❌ Error updating stats: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Skill Rent',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEC5B13)),
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MainScreen(),
          '/post-request': (context) => const PostRequestScreen(),
        },
      ),
    );
  }
}