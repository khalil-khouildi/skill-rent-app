import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabChip('All Requests', true),
                    _buildTabChip('Active', false),
                    _buildTabChip('Completed', false),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildRequestCard(
                context,
                'Fix leaking kitchen sink',
                '2 hours ago',
                'Waiting applicants',
                'Need a plumber to fix a persistent leak under the kitchen sink. Suspect it\'s the P-trap.',
                '\$50 - \$80',
                Icons.plumbing,
                const Color(0xFFFFDBCB),
                const Color(0xFF341100),
                Colors.orange[100]!,
                Colors.orange[800]!,
              ),
              const SizedBox(height: 16),
              _buildRequestCard(
                context,
                'Logo Design for Cafe',
                '1 day ago',
                '3 applicants',
                'Looking for a minimalist logo design for a new modern coffee shop opening downtown.',
                '\$150 fixed',
                Icons.design_services,
                const Color(0xFFD8E2FF),
                const Color(0xFF001A41),
                Colors.blue[100]!,
                Colors.blue[800]!,
                hasApplicants: true,
              ),
              const SizedBox(height: 16),
              _buildRequestCard(
                context,
                'React Developer for 1 week',
                '3 days ago',
                'In progress',
                'Need an experienced React dev to help finish a dashboard UI. Connecting to existing APIs.',
                '\$40/hr',
                Icons.laptop_mac,
                const Color(0xFFE0E2EC),
                const Color(0xFF191C23),
                Colors.green[100]!,
                Colors.green[800]!,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabChip(String label, bool isSelected) {
    const primaryColor = Color(0xFF005BBF);
    return Container(
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
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    String title,
    String time,
    String status,
    String description,
    String price,
    IconData icon,
    Color bg,
    Color text,
    Color statusBg,
    Color statusText, {
    bool hasApplicants = false,
  }) {
    return Container(
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
              // Icon - fixed width to prevent overflow
              SizedBox(
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Icon(icon, color: text, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              // Title and time - Expanded to take remaining space
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
                    Text(
                      time,
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status badge - flexible width
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    status,
                    style: GoogleFonts.inter(fontSize: 10, color: statusText, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  price,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF005BBF)),
                ),
              ),
              if (hasApplicants)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/applicants');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005BBF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Review'),
                )
              else
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