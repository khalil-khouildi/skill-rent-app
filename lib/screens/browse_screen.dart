import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowseRequestsScreen extends StatelessWidget {
  const BrowseRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);
    const onBackground = Color(0xFF191C23);

    return SafeArea(
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
                    image: DecorationImage(
                      image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBrk3VcqOz0NBDvm56UFLeVSlkSu8d_Fx7fkiYuAGwxEsjfy1-2idX539BNRdfQWt5WXz_Ck5jEKJyaOEyRFjOCh5E3ljP-Fr4F_iIoR1R9wkEy2sHkyrodziYOaieEz-w3bugYdT36wrMIBPSAFhvicl7AbP1ywxreYQnkfISKHEINEvSuIsq41Y1k8pOJ7I4MOsCkZRE3IScz72ed-yjWIITCucuV1KSnYpR31zQMbPVairriV0PxQAsPhNJAbtcptj4HLDGIXXRt'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  'Skill Rent',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                    letterSpacing: -1,
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search requests...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: const Icon(Icons.tune, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', true),
                      _buildFilterChip('Nearby', false),
                      _buildFilterChip('High Budget', false),
                      _buildFilterChip('Urgent', false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Request List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildBrowseCard(
                  'Emergency Pipe Repair',
                  'Brooklyn, 2.5km',
                  '\$150-250',
                  'Urgent',
                  'Sarah J.',
                  '4.9',
                  '12 reviews',
                  Icons.plumbing,
                  Colors.orange[100]!,
                  Colors.orange[700]!,
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuD7yngHcpC5AXH9fhZwjFkPEgC28H3w7MbhqlLtlVzaS8akew1uoPtr6ahRYeUEPIpSCEFV9L-dGm_AzlgvwIEr7UJy8s0GwRqTXoDACxE7g3nF3iOUfhtbMzv7zWSP1fXVDbNxwmoiVdAKXlz40jsaTfNyAM8c5xJkc4w5vct_4WhU9_bbVy39kBV6XCvQ29nS-26EgH22BoTmZ-tZE_rKZ9_3gyItKwMowvJVtYn1w9W26aDm7y0o9Mv4FaWX8XrumTRH_I1Ea4bE',
                ),
                const SizedBox(height: 16),
                _buildBrowseCard(
                  'Interior Painting',
                  'Queens, 5.1km',
                  '\$400-600',
                  'Flexible',
                  'Michael R.',
                  '5.0',
                  '3 reviews',
                  Icons.brush,
                  Colors.blue[100]!,
                  Colors.blue[700]!,
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAuZug3ozDkW9NHKK4wI3wUJZJab2giDshpCWcwYfX6NV2Z95cWZfbmx0S9sHaLfVjt4j4gGGO8aaLF0KJWR9rePsN_qLPKmBO1T1oAJDhfTFjl5ThvX_UjM5VBRsezFJLVgmdqNKyGXPoIoV0TQz_k6gl7PFMQCVTd8tUF0UOahEmESpWrDsM4miPJ_ejU-MPl75TH22TFeKWBANBVg2YI1mmAo4FqJgcBBBjz55Sj5aHjmcxmyKBxgzJXrfjK_o7AUfqQMoasNn7a',
                ),
                const SizedBox(height: 16),
                _buildBrowseCard(
                  'Assemble IKEA Furniture',
                  'Manhattan, 1.2km',
                  '\$80-120',
                  '',
                  'Amanda L.',
                  'New Client',
                  '',
                  Icons.chair,
                  Colors.purple[100]!,
                  Colors.purple[700]!,
                  'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                ),
                const SizedBox(height: 80), // Space for bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    const primaryColor = Color(0xFF005BBF);
    return Container(
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
    );
  }

  Widget _buildBrowseCard(
    String title,
    String location,
    String budget,
    String tag,
    String clientName,
    String rating,
    String reviews,
    IconData icon,
    Color iconBg,
    Color iconColor,
    String avatarUrl,
  ) {
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
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
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        Text(
                          ' $location',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
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
                      color: const Color(0xFF005BBF),
                    ),
                  ),
                  if (tag.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName,
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        reviews.isEmpty ? rating : '$rating ($reviews)',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
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
}
