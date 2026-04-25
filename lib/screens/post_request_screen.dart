import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  String _selectedCategory = 'Plumbing';
  String _selectedUrgency = 'Today';

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
          onPressed: () {},
        ),
        title: Text(
          'Skill Rent',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w900,
            color: primaryColor,
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
                  _buildSectionLabel('Description'),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe your need...',
                      filled: true,
                      fillColor: const Color(0xFFF2F3FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                      _buildCategoryChip('+ More'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel('Estimated Budget'),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.attach_money),
                      hintText: '0.00',
                      filled: true,
                      fillColor: const Color(0xFFF2F3FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel('Location'),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      suffixIcon: const Icon(Icons.my_location, color: primaryColor),
                      hintText: 'Enter address or zip code',
                      filled: true,
                      fillColor: const Color(0xFFF2F3FD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  _buildSectionLabel('Add Photos (Optional)'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC1C6D6), style: BorderStyle.none),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_outlined, color: onSurfaceVariant),
                        const SizedBox(height: 4),
                        Text(
                          'Upload photo',
                          style: GoogleFonts.inter(fontSize: 12, color: onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Post Request'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
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
