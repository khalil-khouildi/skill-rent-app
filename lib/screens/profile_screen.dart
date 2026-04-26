import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isEditing = false;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _newSkillController = TextEditingController();

  Map<String, dynamic> _userData = {};
  List<String> _skills = [];
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadReviews();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _newSkillController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final doc = await _firestore.collection('users').doc(userId).get();
        if (doc.exists && mounted) {
          setState(() {
            _userData = doc.data() as Map<String, dynamic>;
            _nameController.text = _userData['fullName'] ?? '';
            _bioController.text = _userData['bio'] ?? '';
            _locationController.text = _userData['location'] ?? '';
            _skills = List<String>.from(_userData['skills'] ?? []);
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadReviews() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Query reviews where this user is the freelancer
      // We removed orderBy to avoid needing a composite index in Firestore, we will sort locally.
      final reviewsSnapshot = await _firestore
          .collection('reviews')
          .where('freelancerId', isEqualTo: userId)
          .get();

      final List<Map<String, dynamic>> loadedReviews = [];

      for (var doc in reviewsSnapshot.docs) {
        final reviewData = doc.data();
        
        // Get client info
        final clientId = reviewData['clientId'];
        String clientName = 'User';
        
        if (clientId != null) {
          final clientDoc = await _firestore.collection('users').doc(clientId).get();
          if (clientDoc.exists) {
            clientName = clientDoc.data()?['fullName'] ?? 'User';
          }
        }
        
        loadedReviews.add({
          'id': doc.id,
          'clientId': clientId,
          'clientName': clientName,
          'comment': reviewData['comment'] ?? '',
          'rating': reviewData['rating'] ?? 0.0,
          'requestTitle': reviewData['requestTitle'] ?? '',
          'createdAt': reviewData['createdAt'],
        });
      }

      // Sort locally by createdAt descending
      loadedReviews.sort((a, b) {
        final Timestamp? timeA = a['createdAt'] as Timestamp?;
        final Timestamp? timeB = b['createdAt'] as Timestamp?;
        if (timeA == null && timeB == null) return 0;
        if (timeA == null) return 1;
        if (timeB == null) return -1;
        return timeB.compareTo(timeA);
      });

      if (mounted) {
        setState(() {
          _reviews = loadedReviews;
        });
      }
    } catch (e) {
      print('Error loading reviews: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final updates = {
          'fullName': _nameController.text.trim(),
          'bio': _bioController.text.trim(),
          'location': _locationController.text.trim(),
          'skills': _skills,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(userId).update(updates);

        // Update AuthProvider
        final authProvider = context.read<AuthProvider>();
        await authProvider.updateProfile(updates);

        // Update local data
        _userData['fullName'] = _nameController.text.trim();
        _userData['bio'] = _bioController.text.trim();
        _userData['location'] = _locationController.text.trim();
        _userData['skills'] = _skills;

        if (mounted) {
          setState(() {
            _isEditing = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addSkill() async {
    final newSkill = _newSkillController.text.trim();
    if (newSkill.isEmpty) return;

    if (_skills.contains(newSkill)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Skill already exists!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _skills.add(newSkill);
      _newSkillController.clear();
    });
  }

  Future<void> _removeSkill(String skill) async {
    setState(() {
      _skills.remove(skill);
    });
  }

  void _showAddSkillDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Skill'),
        content: TextField(
          controller: _newSkillController,
          decoration: const InputDecoration(
            hintText: 'e.g., Flutter, Python, UI Design',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            _addSkill();
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addSkill();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005BBF),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAllReviews() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Reviews',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _reviews.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_outline, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No reviews yet',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Complete missions to get reviews',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        return _buildReviewCard(
                          review['clientName'] ?? 'User',
                          review['requestTitle'] ?? 'Service',
                          review['comment'] ?? '',
                          (review['rating'] ?? 0).toString(),
                          '',
                          review['createdAt'] as Timestamp?,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout();

                if (mounted) {
                  Navigator.pop(context); // Close loading
                  Navigator.pushReplacementNamed(context, '/welcome');
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context); // Close loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, {String suffix = ''}) {
    return Column(
      children: [
        Text(
          '$value$suffix',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF005BBF),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildReviewCard(
    String name,
    String service,
    String comment,
    String rating,
    String avatarUrl,
    Timestamp? createdAt,
  ) {
    String formattedDate = '';
    if (createdAt != null) {
      final date = createdAt.toDate();
      formattedDate = '${date.day}/${date.month}/${date.year}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E2EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFF2F3FD),
                child: const Icon(Icons.person, size: 20, color: Color(0xFF005BBF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      service,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (formattedDate.isNotEmpty)
                      Text(
                        formattedDate,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);
    const onBackground = Color(0xFF191C23);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9F9FF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Calculate average rating
    double averageRating = 0;
    if (_reviews.isNotEmpty) {
      final totalRating = _reviews.fold(0.0, (sum, review) => sum + (review['rating'] as num).toDouble());
      averageRating = totalRating / _reviews.length;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF191C23),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Cover and Avatar
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, primaryColor.withOpacity(0.7)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: 20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: const Color(0xFFF2F3FD),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _userData['avatarUrl'] != null &&
                              _userData['avatarUrl'].toString().isNotEmpty
                          ? Image.network(
                              _userData['avatarUrl'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 50),
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Color(0xFF005BBF),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Edit Button or Save Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_isEditing)
                        ElevatedButton.icon(
                          onPressed: _updateProfile,
                          icon: const Icon(Icons.save, size: 18),
                          label: const Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _isEditing = true);
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit Profile'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: const BorderSide(color: Color(0xFFD8E2FF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Name
                  if (_isEditing)
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      _userData['fullName'] ?? 'User Name',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: onBackground,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E2FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _userData['role']?.toString().toUpperCase() ?? 'CLIENT',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  if (_isEditing)
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        prefixIcon: const Icon(Icons.location_on, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  else if (_userData['location'] != null &&
                      _userData['location'].toString().isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _userData['location'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Stats Card with Real Data
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          _userData['missionsCompleted']?.toString() ?? '0',
                          'Missions',
                        ),
                        _buildStat(
                          averageRating.toStringAsFixed(1),
                          'Rating',
                          suffix: '⭐',
                        ),
                        _buildStat(
                          _userData['successRate']?.toString() ?? '0',
                          'Success',
                          suffix: '%',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Bio
                  Text(
                    'About',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isEditing)
                    TextField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Tell others about yourself...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  else
                    Text(
                      _userData['bio']?.isNotEmpty == true
                          ? _userData['bio']
                          : 'No bio added yet. Tap edit to add a bio.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Skills Section
                  Text(
                    'Skills',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_skills.isEmpty && !_isEditing)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F3FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No skills added yet. Tap edit to add your skills.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._skills.map((skill) => _buildSkillChip(
                            skill,
                            isAction: _isEditing,
                            onDelete: _isEditing ? () => _removeSkill(skill) : null,
                          )),
                      if (_isEditing)
                        _buildSkillChip(
                          '+ Add Skill',
                          isAction: true,
                          onTap: _showAddSkillDialog,
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Recent Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Reviews',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_reviews.isNotEmpty)
                        TextButton(
                          onPressed: _showAllReviews,
                          child: Text(
                            'View All (${_reviews.length})',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Display recent reviews (max 2)
                  if (_reviews.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0E2EC)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.star_outline, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'No reviews yet',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Complete missions to receive reviews',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        ..._reviews.take(2).map((review) => _buildReviewCard(
                          review['clientName'] ?? 'User',
                          review['requestTitle'] ?? 'Service',
                          review['comment'] ?? '',
                          (review['rating'] ?? 0).toString(),
                          '',
                          review['createdAt'] as Timestamp?,
                        )),
                        if (_reviews.length > 2)
                          Center(
                            child: TextButton(
                              onPressed: _showAllReviews,
                              child: Text(
                                'Show ${_reviews.length - 2} more reviews...',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 32),

                  // Member Since
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Member since ${_userData['createdAt'] is Timestamp 
                              ? '${(_userData['createdAt'] as Timestamp).toDate().day}/${(_userData['createdAt'] as Timestamp).toDate().month}/${(_userData['createdAt'] as Timestamp).toDate().year}'
                              : 'Recently'}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(
    String label, {
    bool isAction = false,
    VoidCallback? onDelete,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isAction ? Colors.transparent : const Color(0xFFD8E2FF),
          borderRadius: BorderRadius.circular(20),
          border: isAction
              ? Border.all(color: Colors.grey[300]!, style: BorderStyle.solid)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isAction ? Colors.grey[600] : const Color(0xFF001A41),
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.close, size: 14, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}