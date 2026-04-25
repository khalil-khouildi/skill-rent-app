import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

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
            // Top Bar
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
                        image: const DecorationImage(
                          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBOq_8q6JaZZNgBnAydAnVPOQ1hifVTweOsANEFNApbcFBDACxid9WMIKaF8MLoV72kf9l6RRqPLWOQkL9faDQJxDifFIvY0QePlXsBdboYYAI5hqD2rXAYjZu4K9onCAYJOVOwqVRrbQowHvGADUgMq8ka9dCvw66dwRnLevEmYoOshGiMHPdvw5gs8o_OxfdvuCTX1JPsN0ozYkCLt1TArP-Wc5S2tBcDgXY7y6jE3c5puhFvuYcqye-9pxRqV1JUgFjr4hQ2P7dr'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Hi, Alex 👋',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: onBackground,
                      ),
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
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E2EC)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for skills, services...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF727785)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        'Search',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('🔧', 'Repair'),
                  _buildCategoryChip('📚', 'Tutoring'),
                  _buildCategoryChip('🎨', 'Design'),
                  _buildCategoryChip('🚗', 'Transport'),
                  _buildCategoryChip('➕', 'More'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Active Requests
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
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRequestCard(
              'Plumbing',
              'Fix leaking kitchen sink',
              '\$50 - \$80',
              '3 applicants',
              true,
            ),
            const SizedBox(height: 16),
            _buildRequestCard(
              'Design',
              'Logo design for bakery',
              '\$150',
              'Awaiting bids',
              false,
            ),
            const SizedBox(height: 32),
            // Nearby Freelancers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nearby Freelancers',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: onBackground,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Map View'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFreelancerCard(
                    'Sarah J.',
                    'Graphic Design',
                    '4.9',
                    '120 reviews',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBagvesyTno9E8ogG_G-dGj_Voj5a7A1ZfciiDQjUalB9GgEdH4AZYUwFUon93VcLvD5lb4YcA_NHSr7x7APl5j3v96fVb70plUx-_1LcdIhuraWFISW0tN8rR0VXbtpQVH9puoxYWxGloyachd41X5u3sDRCXzfaSkxNDjJb4Lpkeo7ubGE8ZC50aoDz52sswVqHrKpkUdOJQRQGXiA-VpjoyPwFWh6lCg0OCPrDfj6TukJ8z0gYZ-tTUD8xam9RrSxmazYDbOkCB7',
                  ),
                  const SizedBox(width: 16),
                  _buildFreelancerCard(
                    'Michael T.',
                    'Handyman',
                    '4.8',
                    '85 reviews',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAQBBK5H9L41RhJedjc290nnQUZMsP-NHc8mAt5qq0bFCl8Zapqj-tCQrGedxP3XDOXUCu9-UXNEe2m_M_wXQat4rZt9-zVf24fIahq8C490hTo2L8w8llNR49Eyw9iOBBh-Rp2VZRFa7ld6QyaMblu8Q3IFYUprmff303DbT4Mr7lPjJa7XISXgzW2gKXom8gk3AOfccWXlyQdcH1J2Sj_sqBhlXVkjlB3ITesVBRD2oPU4tAImrclafxavgm0-z6M-M46Kq2iRnuA',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String emoji, String label) {
    return Container(
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
    );
  }

  Widget _buildRequestCard(String category, String title, String price, String status, bool hasApplicants) {
    const primaryColor = Color(0xFF005BBF);
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
                  Icon(
                    hasApplicants ? Icons.groups : Icons.hourglass_empty,
                    size: 18,
                    color: hasApplicants ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(hasApplicants ? 'Review' : 'Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFreelancerCard(String name, String skill, String rating, String reviews, String imageUrl) {
    return Container(
      width: 240,
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
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
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
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
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
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2F3FD),
              foregroundColor: const Color(0xFF005BBF),
              elevation: 0,
              minimumSize: const Size(double.infinity, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View Profile'),
          ),
        ],
      ),
    );
  }
}
