import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/request_service.dart';
import '../services/application_service.dart';

class BrowseRequestsScreen extends StatefulWidget {
  const BrowseRequestsScreen({super.key});

  @override
  State<BrowseRequestsScreen> createState() => _BrowseRequestsScreenState();
}

class _BrowseRequestsScreenState extends State<BrowseRequestsScreen> {
  final RequestService _requestService = RequestService();
  final ApplicationService _applicationService = ApplicationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedFilter = 'All';
  
  // Controllers for apply dialog
  final TextEditingController _proposalController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedRequestId = '';

  @override
  void dispose() {
    _proposalController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF2F3FD),
                    ),
                    child: const Icon(Icons.person_outline, size: 20, color: primaryColor),
                  ),
                  Text(
                    'Browse Requests',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                  const Icon(Icons.notifications_outlined, color: primaryColor),
                ],
              ),
            ),
            
            // Search and Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search requests...',
                        prefixIcon: Icon(Icons.search, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', _selectedFilter == 'All'),
                        _buildFilterChip('Nearby', _selectedFilter == 'Nearby'),
                        _buildFilterChip('Urgent', _selectedFilter == 'Urgent'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Request List from Firebase
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _requestService.getActiveRequests(),
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
                          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
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
                            'Be the first to post a request!',
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
                  final currentUserId = _auth.currentUser?.uid ?? '';
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      final data = request.data() as Map<String, dynamic>;
                      
                      final isOwnRequest = data['userId'] == currentUserId;
                      
                      return _buildBrowseCard(
                        requestId: request.id,
                        title: data['title'] ?? 'No title',
                        location: data['location'] ?? 'Unknown location',
                        budget: data['budget'] ?? 'N/A',
                        urgency: data['urgency'] ?? '',
                        description: data['description'] ?? '',
                        category: data['category'] ?? 'General',
                        isOwnRequest: isOwnRequest,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    const primaryColor = Color(0xFF005BBF);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD8E2FF) : const Color(0xFFF2F3FD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryColor : Colors.transparent),
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

  Widget _buildBrowseCard({
    required String requestId,
    required String title,
    required String location,
    required String budget,
    required String urgency,
    required String description,
    required String category,
    required bool isOwnRequest,
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
          return Colors.orange;
        case 'electrician':
          return Colors.amber;
        case 'cleaning':
          return Colors.blue;
        case 'moving':
          return Colors.purple;
        case 'tutoring':
          return Colors.green;
        case 'design':
          return Colors.pink;
        default:
          return primaryColor;
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: getCategoryColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(getCategoryIcon(), color: getCategoryColor()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    budget,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  if (urgency.isNotEmpty && urgency != 'Flexible') ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: urgency == 'ASAP' ? Colors.red[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        urgency,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: urgency == 'ASAP' ? Colors.red : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
                ),
              ),
              const Spacer(),
              if (isOwnRequest)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Your Request',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    _showApplyDialog(context, requestId: requestId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFfe6a34),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Apply Now'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showApplyDialog(BuildContext context, {required String requestId}) {
  _selectedRequestId = requestId;
  _proposalController.clear();
  _priceController.clear();
  
  bool isLoading = false;
  bool isSubmitted = false;
  
  // Check if already applied
  _checkIfAlreadyApplied(requestId).then((alreadyApplied) {
    if (alreadyApplied && context.mounted) {
      isSubmitted = true;
      setState(() {});
    }
  });
  
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Apply for this job'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSubmitted)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You have already applied to this request',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!isSubmitted) ...[
                    TextField(
                      controller: _proposalController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Why are you the right person?',
                        hintText: 'Describe your skills and experience...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Your proposed price',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isSubmitted || isLoading
                    ? null
                    : () async {
                        // Validate inputs
                        if (_proposalController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please tell why you are suitable')),
                          );
                          return;
                        }
                        
                        final price = double.tryParse(_priceController.text.trim());
                        if (price == null || price <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid price')),
                          );
                          return;
                        }
                        
                        // Set loading state
                        setState(() {
                          isLoading = true;
                        });
                        
                        try {
                          final success = await _applicationService.applyToRequest(
                            requestId: _selectedRequestId,
                            proposal: _proposalController.text.trim(),
                            proposedPrice: price,
                          );
                          
                          if (success && context.mounted) {
                            setState(() {
                              isLoading = false;
                              isSubmitted = true;
                            });
                            
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Application submitted successfully!'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            
                            // Close dialog after 1.5 seconds
                            Future.delayed(const Duration(milliseconds: 1500), () {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            });
                          } else if (context.mounted) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Failed to apply. You may have already applied.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubmitted ? Colors.green : const Color(0xFFfe6a34),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 40),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : isSubmitted
                        ? const Text('✓ Submitted')
                        : const Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  );
}

// Add this helper method to check if already applied
Future<bool> _checkIfAlreadyApplied(String requestId) async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return false;
  
  final existing = await _applicationService.hasApplied(requestId);
  return existing;
}
}