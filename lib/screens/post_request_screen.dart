import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/request_service.dart';
import '../services/ai_service.dart';
import 'location_picker_screen.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  String _selectedCategory = 'Plumbing';
  String _selectedUrgency = 'Today';
  LatLng? _selectedLocation;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  bool _isLoading = false;
  
  final RequestService _requestService = RequestService();
  final AIService _aiService = AIService();
  bool _isAiLoading = false;

  Future<void> _generateWithAI() async {
    final TextEditingController promptController = TextEditingController();
    
    // Show dialog to get user prompt
    final String? userPrompt = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF005BBF)),
            const SizedBox(width: 10),
            Text('Générer avec l\'IA', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Décrivez brièvement ce dont vous avez besoin (ex: fuite lavabo, peinture salon)'),
            const SizedBox(height: 16),
            TextField(
              controller: promptController,
              decoration: InputDecoration(
                hintText: 'Mots-clés...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, promptController.text),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005BBF), foregroundColor: Colors.white),
            child: const Text('Générer'),
          ),
        ],
      ),
    );

    if (userPrompt != null && userPrompt.isNotEmpty) {
      setState(() => _isAiLoading = true);
      
      final result = await _aiService.generateRequestDetails(userPrompt);
      
      setState(() => _isAiLoading = false);

      if (result != null) {
        setState(() {
          _titleController.text = result['title'] ?? '';
          _descriptionController.text = result['description'] ?? '';
        });
      } else {
        _showError('L\'IA n\'a pas pu générer les détails. Réessayez.');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialLocation: _selectedLocation,
        ),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _selectedLocation = result['location'];
        _locationController.text = result['address'] ?? 'Position sélectionnée';
      });
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Request posted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      _titleController.clear();
      _descriptionController.clear();
      _budgetController.clear();
      _locationController.clear();
      
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
                  // AI Generation Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isAiLoading ? null : _generateWithAI,
                      icon: _isAiLoading 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.auto_awesome, size: 18),
                      label: Text(_isAiLoading ? 'Génération...' : 'Générer avec l\'IA ✨'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TITLE FIELD - ADDED!
                  _buildSectionLabel('Title *'),
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
                  
                  // Description
                  _buildSectionLabel('Description *'),
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
                  _buildSectionLabel('Category *'),
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
                  _buildSectionLabel('Estimated Budget *'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _budgetController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.attach_money),
                      hintText: 'e.g., \$50 - \$80',
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
                  _buildSectionLabel('Location *'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _locationController,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Sélectionnez un lieu sur la carte',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            filled: true,
                            fillColor: const Color(0xFFF2F3FD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _selectLocationOnMap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005BBF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        child: const Icon(Icons.map, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Urgency
                  _buildSectionLabel('Urgency *'),
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