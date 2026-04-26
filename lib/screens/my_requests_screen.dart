import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/request_service.dart';
import 'applicants_screen.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final RequestService _requestService = RequestService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedTab = 'All';
  
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
                      
                      return _buildRequestCard(
                        context,
                        requestId: request.id,  // Pass the document ID
                        title: data['title'] ?? 'No title',
                        time: _formatTime(data['createdAt']),
                        status: data['status'] ?? 'active',
                        description: data['description'] ?? '',
                        price: data['budget'] ?? 'N/A',
                        category: data['category'] ?? 'General',
                        hasApplicants: (data['applicantsCount'] ?? 0) > 0,
                        statusBg: data['status'] == 'active' ? Colors.orange[100]! : Colors.green[100]!,
                        statusText: data['status'] == 'active' ? Colors.orange[800]! : Colors.green[800]!,
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
    required String requestId,  // Add this parameter
    required String title,
    required String time,
    required String status,
    required String description,
    required String price,
    required String category,
    required bool hasApplicants,
    required Color statusBg,
    required Color statusText,
  }) {
    const primaryColor = Color(0xFF005BBF);
    
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
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  status == 'active' ? 'Active' : 'Completed',
                  style: GoogleFonts.inter(fontSize: 10, color: statusText, fontWeight: FontWeight.bold),
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
              if (hasApplicants && status == 'active')
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
              else if (status == 'active')
                TextButton(
                  onPressed: () {},
                  child: const Text('Edit Request'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}