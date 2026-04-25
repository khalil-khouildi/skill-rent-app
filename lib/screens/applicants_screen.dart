import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicantsScreen extends StatelessWidget {
  const ApplicantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);

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
          'Applicants',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E2EC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Plumbing',
                      style: GoogleFonts.inter(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Fix Leaking Kitchen Sink Pipe',
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Budget: \$80 - \$120 • Needed by tomorrow',
                    style: GoogleFonts.inter(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '3 people applied',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.sort, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Best Match',
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildApplicantCard(
              context,
              'Michael Chen',
              '4.9',
              '124',
              '1.2km away',
              'I can help you with this right away. I have 10 years of plumbing experience and carry all necessary tools for under-sink repairs.',
              '\$95',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuACT5XlXD_biKIdhbgvk8hmCuafCIg2C4EZtMIskQZh9E8IcIeKqVNYEvhsxhprq4Tti1J3JFDnJVlHi8KpphXk6_bCqP21DaGuyFaKDcBzXUdUmEvcIQop08DdcVKepumFV1ujApnIMtKTg49nG0z7dP42Q22N8OnuJPr2iY-yZPjJ-WqyKs0mcyi5VMsINYGBnUXyhVfWKRrtzpuqXQsmM58xCrtBD1PZcY0cEuM4di4X0FD5eHlRK0gedNpmnUvxsqG4AJ5pjzW8',
              isAccepted: true,
            ),
            const SizedBox(height: 16),
            _buildApplicantCard(
              context,
              'Sarah Jenkins',
              '4.7',
              '86',
              '3.5km away',
              'Available tomorrow morning. Sounds like a standard P-trap issue, I keep replacement parts stocked in my van.',
              '\$110',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCA63d5PYpQ_BWT0QTdckllwi45L9GZamLZFwA0fR1CEV-vZHmGKnSBMISQdNelea0ZJ1bmtVAw5fAYxvLZLyVnKKLU2sx9rBjM3Q7uQkpsVeLkYfIWwuOGAM755QpagV0FolAzKqcziBTHaPlZW3BM37P0PoRb_Kuz-mX40EIu-HVoBi6B-fBQKbZMuilFvAYBwzm0CE8XkSj8tqhSuLNnAxOb-PmwtnXwmtSGwt3v3N-NSkN1DGVmG-4zf38YtkelbNw5qmG6vG-u',
            ),
            const SizedBox(height: 16),
            _buildApplicantCard(
              context,
              'David Barnes',
              '4.2',
              '12',
              '5.8km away',
              'I can fix it by the weekend. I usually do bigger jobs but have an opening on Saturday afternoon if you can wait.',
              '\$80',
              'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantCard(
    BuildContext context,
    String name,
    String rating,
    String reviews,
    String distance,
    String message,
    String price,
    String avatarUrl, {
    bool isAccepted = false,
  }) {
    const primaryColor = Color(0xFF005BBF);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isAccepted ? primaryColor : const Color(0xFFE0E2EC), width: isAccepted ? 2 : 1),
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
          if (isAccepted)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Accepted',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 28, backgroundImage: NetworkImage(avatarUrl)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        Text(' $rating ($reviews)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on, color: Colors.grey, size: 16),
                        Text(' $distance', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Proposed', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                  Text(price, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD8E2FF)),
            ),
            child: Text(
              '"$message"',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[800], fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('View Profile'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (isAccepted) {
                      Navigator.pushNamed(context, '/chat');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAccepted ? primaryColor : const Color(0xFFEC5B13),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isAccepted ? 'Message' : 'Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
