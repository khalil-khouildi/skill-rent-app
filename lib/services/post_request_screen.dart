import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/request_service.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  String _selectedCategory = 'Plumbing';
  String _selectedUrgency = 'Today';
  
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  
  bool _isLoading = false;
  
  final RequestService _requestService = RequestService();

  @override
  void dispose() {
    _descriptionController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _postRequest() async {
    // Validate fields
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a title');
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showError('Please describe your need');
      return;
    }
    if (_budgetController.text.trim().isEmpty) {
      _showError('Please enter a budget');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      _showError('Please enter a location');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    bool success = await _requestService.postRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      budget: _budgetController.text.trim(),
      location: _locationController.text.trim(),
      urgency: _selectedUrgency,
    );
    
    setState(() {
      _isLoading = false;
    });
    
    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Request posted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      _budgetController.clear();
      _locationController.clear();
      
      // Go back to home after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } else if (mounted) {
      _showError('Failed to post request. Please try again.');
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);
    const onSurfaceVariant = Color(0xFF414754);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Post Request',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What do you need?',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Post your request and get offers from skilled professionals nearby.',
              style: GoogleFonts.inter(color: onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E2EC)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Field
                  _buildSectionLabel('Title'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Fix leaking kitchen sink',
                      filled: true,
                      fillColor: const Color(0xFFF2F3FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Description Field
                  _buildSectionLabel('Description'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe your need in detail...',
                      filled: true,
                      fillColor: const Color(0xFFF2F3FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Category
                  _buildSectionLabel('Category'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryChip('Plumbing'),
                      _buildCategoryChip('Electrician'),
                      _buildCategoryChip('Cleaning'),
                      _buildCategoryChip('Moving'),
                      _buildCategoryChip('Tutoring'),
                      _buildCategoryChip('Design'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Budget
                  _buildSectionLabel('Estimated Budget'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _budgetController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.attach_money),
                      hintText: 'e.g., \$50 - \$80 or \$150 fixed',
                      filled: true,
                      fillColor: const Color(0xFFF2F3FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Location
                  _buildSectionLabel('Location'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      hintText: 'Enter address or neighborhood',
                      filled: true,
                      fillColor: const Color(0xFFF2F3FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Urgency
                  _buildSectionLabel('Urgency'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildUrgencyButton('Flexible'),
                        _buildUrgencyButton('Today'),
                        _buildUrgencyButton('ASAP'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _postRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Post Request'),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD8E2FF) : const Color(0xFFF2F3FD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF005BBF) : Colors.transparent),
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

  Widget _buildUrgencyButton(String label) {
    bool isSelected = _selectedUrgency == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedUrgency = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF005BBF) : const Color(0xFF414754),
            ),
          ),
        ),
      ),
    );
  }
}