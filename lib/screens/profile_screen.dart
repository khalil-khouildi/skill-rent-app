import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';  // Add this
import '../providers/auth_provider.dart';  // Add this

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);
    const onBackground = Color(0xFF191C23);

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
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBrnAgLDAGrbEBSv_RTkqgdNpqox-v2Wh5I5PjPve_AhUaJKlEc_scxGPZwLMUsEp8dx93C94qB99YbBh_7f9BGIt9nHNDLsvo4UhDGLeGIc6diMxfsB2ehR9hEExl27Hdg3bSNAaUbUjbldF6OvfIKOuF9mchItt8ugYT5NDGZRYnem9ZQYhL4d3RPs4PdaBSDPha3dJzd_z0ikdWkigx-vAwzXyMxOCOl85aRZXp-3xQxBIe_oEPlhYzaGHPXGvknqUsMfMIdoVGD'),
                      fit: BoxFit.cover,
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
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCc1F7G3rxvr2auU1AzSpdpLXsS367-erVwHeNmZZhmYtxlG8thxTR42Zj_LJSrq_hiX78HWyHGR2DOX6kAxVnN8NYXcPoexRXFSws7uOebP8SLBtJflMJFV1v3KC-g8-1QqaCBSkgXKOAIRcLy9cW_ksC7IO6XTHeCHHnQkkn5MLOuG133vZ-o6Ztg6JzwrPtQl3aw2gJrLLHau6eUehj9z3GYBObSmTL7cUWvzGoOZfslwJMMz8TiVSc7lKgAuvSi7wCRkRtV8D39'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Johnson',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: onBackground,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'San Francisco, CA',
                                style: GoogleFonts.inter(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: const BorderSide(color: Color(0xFFD8E2FF)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Stats Card
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
                        _buildStat('12', 'Missions'),
                        _buildStat('4.9 ⭐', 'Rating'),
                        _buildStat('98%', 'Success'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'About',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Passionate mobile developer and UI designer. I love turning complex problems into simple, beautiful, and intuitive designs. Always learning new tech.',
                    style: GoogleFonts.inter(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Skills',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSkillChip('Flutter'),
                      _buildSkillChip('UI/UX Design'),
                      _buildSkillChip('Mathematics'),
                      _buildSkillChip('+ Add Skill', isAction: true),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Recent Reviews', 'View All'),
                  const SizedBox(height: 16),
                  _buildReviewCard(
                    'Sarah M.',
                    'Mobile App Design',
                    'Alex did an amazing job on our Flutter app UI. Delivery was fast and results exceeded expectations.',
                    '5.0',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCYk_9wNWJlZ506xqaL0a-Mf7EasXnHX_x0_RShOedXHRZiaiNIMxEUQHzRlpraARAm7pCRf_p40JCwtKzesJzc8QUZ15V0fxNpFQRiGK3monpdAJOFqH_UOquB1962j0DIvQdVsuL4Kr7cfu_g2TM_g3ee7pTmoFYLJ8I0HojP5OWw6pIiD5us9BMXgCI77h6TiN8T145GiVEDoAb0fgdaR40sDniGU5Gl30IgWwUeb0hpz50dbiR3nhPHgr-vGCZpqtOgzSyuKeFG',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF005BBF),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String label, {bool isAction = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isAction ? Colors.transparent : const Color(0xFFD8E2FF),
        borderRadius: BorderRadius.circular(20),
        border: isAction ? Border.all(color: Colors.grey[300]!, style: BorderStyle.solid) : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isAction ? Colors.grey[600] : const Color(0xFF001A41),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: () {}, child: Text(action)),
      ],
    );
  }

  Widget _buildReviewCard(String name, String service, String comment, String rating, String avatarUrl) {
    return Container(
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
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatarUrl)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  Text(service, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              const Spacer(),
              Row(
                children: List.generate(5, (index) => const Icon(Icons.star, size: 14, color: Colors.orange)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700], height: 1.4),
          ),
        ],
      ),
    );
  }

  // This method is NOW inside the class
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/welcome');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}