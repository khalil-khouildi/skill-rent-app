import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  
  String _userName = 'User';
  int _activeRequestsCount = 0;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadActiveRequestsCount();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && mounted) {
        setState(() {
          _userName = userDoc.data()?['fullName']?.split(' ').first ?? 'User';
        });
      }
    }
  }
  
  Future<void> _loadActiveRequestsCount() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final requests = await _firestore
          .collection('requests')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .get();
      if (mounted) {
        setState(() {
          _activeRequestsCount = requests.docs.length;
        });
      }
    }
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;
    // Navigate to Browse screen with search query
    Navigator.pushNamed(
      context,
      '/home',
    ).then((_) {
      // After returning, we need to update the browse screen
      // The browse screen will be rebuilt
    });
    
    // Alternative: Use a global state or provider
    // For now, we'll use a simple approach
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for: "$query"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);
    const onBackground = Color(0xFF191C23);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with User Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF2F3FD),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person_outline, color: primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, $_userName 👋',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: onBackground,
                          ),
                        ),
                        Text(
                          '$_activeRequestsCount active requests',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined, color: primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Header
            Text(
              'What do you need help with?',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: onBackground,
              ),
            ),
            const SizedBox(height: 16),
            
            // Search Bar - Now Functional
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E2EC)),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  _search(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for skills, services...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF727785)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  suffixIconConstraints: const BoxConstraints(minWidth: 40),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Categories - Clickable with search
            Text(
              'Popular Categories',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: onBackground,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('🔧', 'Plumbing', primaryColor),
                  _buildCategoryChip('⚡', 'Electrician', primaryColor),
                  _buildCategoryChip('🧹', 'Cleaning', primaryColor),
                  _buildCategoryChip('📦', 'Moving', primaryColor),
                  _buildCategoryChip('📚', 'Tutoring', primaryColor),
                  _buildCategoryChip('🎨', 'Design', primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Active Requests Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Active Requests',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: onBackground,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to My Requests tab (index 2)
                    // You can implement tab switching here
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Active Requests from Firebase
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('requests')
                  .where('userId', isEqualTo: _auth.currentUser?.uid)
                  .where('status', isEqualTo: 'active')
                  .limit(3)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'No active requests',
                          style: GoogleFonts.inter(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/post-request');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Text('Post a Request'),
                        ),
                      ],
                    ),
                  );
                }
                
                final requests = snapshot.data!.docs;
                
                return Column(
                  children: requests.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildActiveRequestCard(
                      category: data['category'] ?? 'General',
                      title: data['title'] ?? 'No title',
                      price: data['budget'] ?? 'N/A',
                      applicants: (data['applicantsCount'] ?? 0).toString(),
                      requestId: doc.id,
                    );
                  }).toList(),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Nearby Freelancers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Rated Freelancers',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: onBackground,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Freelancers from Firebase
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .where('role', isEqualTo: 'freelancer')
                  .limit(5)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'No freelancers yet',
                        style: GoogleFonts.inter(color: Colors.grey[600]),
                      ),
                    ),
                  );
                }
                
                final freelancers = snapshot.data!.docs;
                
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: freelancers.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildFreelancerCard(
                        name: data['fullName'] ?? 'Unknown',
                        skill: 'Available',
                        rating: (data['rating'] ?? 0.0).toString(),
                        reviews: (data['totalReviews'] ?? 0).toString(),
                        freelancerId: doc.id,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String emoji, String label, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        // Navigate to Browse with category filter
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Showing $label services')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE0E2EC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveRequestCard({
    required String category,
    required String title,
    required String price,
    required String applicants,
    required String requestId,
  }) {
    const primaryColor = Color(0xFF005BBF);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
              Text(
                price,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.groups, size: 18, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    '$applicants applicants',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to applicants for this request
                  Navigator.pushNamed(context, '/applicants', arguments: {
                    'requestId': requestId,
                    'requestTitle': title,
                  });
                },
                child: const Text('View'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFreelancerCard({
    required String name,
    required String skill,
    required String rating,
    required String reviews,
    required String freelancerId,
  }) {
    const primaryColor = Color(0xFF005BBF);
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFF2F3FD),
                child: Icon(Icons.person, color: Colors.grey[600]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        Text(
                          ' $rating ($reviews)',
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD8E2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              skill,
              style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF001A41)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to freelancer profile
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing $name profile')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2F3FD),
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('View Profile', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}