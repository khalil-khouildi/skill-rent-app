import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/request_service.dart';
import '../services/review_service.dart';
import 'applicants_screen.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final RequestService _requestService = RequestService();
  final ReviewService _reviewService = ReviewService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedTab = 'All';

  Future<void> _completeRequest(String requestId, String freelancerId, String freelancerName) async {
    print('📝 Completing request: $requestId for freelancer: $freelancerName');
    
    final review = await _showRatingDialog(context, freelancerName);
    if (review != null && context.mounted) {
      final success = await _reviewService.leaveReview(
        requestId: requestId,
        freelancerId: freelancerId,
        rating: review['rating']!,
        comment: review['comment']!,
      );
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Request completed! Thank you for your review.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to complete request'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> _showRatingDialog(BuildContext context, String freelancerName) async {
  double rating = 5;
  final TextEditingController commentController = TextEditingController();
  
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Complete Request with $freelancerName'),
          content: SingleChildScrollView(  // Wrap with SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How was your experience?', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Wrap(  // Use Wrap instead of Row to prevent overflow
                  alignment: WrapAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          rating = (index + 1).toDouble();
                        });
                      },
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 32,  // Reduced from 40
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Write a review (optional)',
                    hintText: 'Share your experience with this freelancer...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'rating': rating,
                  'comment': commentController.text.trim(),
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005BBF),
              ),
              child: const Text('Complete'),
            ),
          ],
        );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);
    final userId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Requests',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/post-request');
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabChip('All', _selectedTab == 'All'),
                    _buildTabChip('Active', _selectedTab == 'Active'),
                    _buildTabChip('In Progress', _selectedTab == 'In Progress'),
                    _buildTabChip('Completed', _selectedTab == 'Completed'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _requestService.getUserRequests(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No requests yet',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to create your first request',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final requests = snapshot.data!.docs;
                  
                  List<QueryDocumentSnapshot> filteredRequests = [];
                  for (var request in requests) {
                    final data = request.data() as Map<String, dynamic>;
                    final status = data['status'] ?? 'active';
                    
                    if (_selectedTab == 'All') {
                      filteredRequests.add(request);
                    } else if (_selectedTab == 'Active' && status == 'active') {
                      filteredRequests.add(request);
                    } else if (_selectedTab == 'In Progress' && status == 'in_progress') {
                      filteredRequests.add(request);
                    } else if (_selectedTab == 'Completed' && status == 'completed') {
                      filteredRequests.add(request);
                    }
                  }
                  
                  if (filteredRequests.isEmpty) {
                    return Center(
                      child: Text(
                        'No ${_selectedTab.toLowerCase()} requests',
                        style: GoogleFonts.inter(color: Colors.grey[600]),
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = filteredRequests[index];
                      final data = request.data() as Map<String, dynamic>;
                      
                      // Debug print to see what data we have
                      print('📊 Request data: ${data.keys}');
                      print('📊 Status: ${data['status']}');
                      print('📊 Accepted Freelancer ID: ${data['acceptedFreelancerId']}');
                      
                      return _buildRequestCard(
                        context,
                        requestId: request.id,
                        title: data['title'] ?? 'No title',
                        time: _formatTime(data['createdAt']),
                        status: data['status'] ?? 'active',
                        description: data['description'] ?? '',
                        price: data['budget'] ?? 'N/A',
                        category: data['category'] ?? 'General',
                        hasApplicants: (data['applicantsCount'] ?? 0) > 0,
                        acceptedFreelancerId: data['acceptedFreelancerId'],
                        acceptedFreelancerName: data['acceptedFreelancerName'],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return 'Just now';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildTabChip(String label, bool isSelected) {
    const primaryColor = Color(0xFF005BBF);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD8E2FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryColor : const Color(0xFFC1C6D6)),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFF001A41) : const Color(0xFF414754),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context, {
    required String requestId,
    required String title,
    required String time,
    required String status,
    required String description,
    required String price,
    required String category,
    required bool hasApplicants,
    String? acceptedFreelancerId,
    String? acceptedFreelancerName,
  }) {
    const primaryColor = Color(0xFF005BBF);
    
    print('🔴 Building card for status: $status, acceptedId: $acceptedFreelancerId');
    
    IconData getCategoryIcon() {
      switch (category.toLowerCase()) {
        case 'plumbing':
          return Icons.plumbing;
        case 'electrician':
          return Icons.electrical_services;
        case 'cleaning':
          return Icons.cleaning_services;
        case 'moving':
          return Icons.local_shipping;
        case 'tutoring':
          return Icons.school;
        case 'design':
          return Icons.design_services;
        default:
          return Icons.build;
      }
    }
    
    Color getCategoryColor() {
      switch (category.toLowerCase()) {
        case 'plumbing':
          return const Color(0xFFFFDBCB);
        case 'electrician':
          return const Color(0xFFFFF0DB);
        case 'cleaning':
          return const Color(0xFFD8E2FF);
        case 'moving':
          return const Color(0xFFE0E2EC);
        default:
          return const Color(0xFFF2F3FD);
      }
    }

    String getStatusText() {
      switch (status) {
        case 'active': return 'Active';
        case 'in_progress': return 'In Progress';
        case 'completed': return 'Completed';
        default: return 'Active';
      }
    }

    Color getStatusBgColor() {
      switch (status) {
        case 'active': return Colors.orange[100]!;
        case 'in_progress': return Colors.blue[100]!;
        case 'completed': return Colors.green[100]!;
        default: return Colors.orange[100]!;
      }
    }

    Color getStatusTextColor() {
      switch (status) {
        case 'active': return Colors.orange[800]!;
        case 'in_progress': return Colors.blue[800]!;
        case 'completed': return Colors.green[800]!;
        default: return Colors.orange[800]!;
      }
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: getCategoryColor(), shape: BoxShape.circle),
                child: Icon(getCategoryIcon(), color: primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: getStatusBgColor(), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  getStatusText(),
                  style: GoogleFonts.inter(fontSize: 10, color: getStatusTextColor(), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: primaryColor),
              ),
              // View Applicants button for active requests
              if (status == 'active' && hasApplicants)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplicantsScreen(
                          requestId: requestId,
                          requestTitle: title,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View Applicants'),
                )
              // Edit button for active requests with no applicants
              else if (status == 'active')
                TextButton(
                  onPressed: () {},
                  child: const Text('Edit Request'),
                )
              // COMPLETE BUTTON - THIS IS WHAT YOU NEED
              else if (status == 'in_progress')
                ElevatedButton(
                  onPressed: () {
                    if (acceptedFreelancerId != null) {
                      _completeRequest(requestId, acceptedFreelancerId, acceptedFreelancerName ?? 'Freelancer');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error: No freelancer assigned')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Complete'),
                )
              // Completed badge
              else if (status == 'completed')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Completed',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}