import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'SkillRent',
          style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: primaryColor),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.grey)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Stay connected with your experts and clients.',
                  style: GoogleFonts.inter(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildMessageItem(
                  'Ahmed',
                  'I\'ll be there in 15 minutes to fix the plumbing.',
                  '10:42 AM',
                  true,
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBVCjHfZMiuAQY6KqlccfVgzTfYlbShK0FwvYRWKrmWvJaWppMLdmmgYIdb24zAvaHgU52r9ANnuP9FamqP4uf2QkZrHTljI7rt1sX5uSbUx80NBTZcWTD33osw2qzV8QFDtQClM3BzSv0QiEcXAYhNmBIzp9Ck2A69e_Z-3W9nkWlRr7TEDVTcQ92e7KQ_0REVUuBqZnk6ZhnpEdDDRoSiB9F9qtvVe9p-28UjX0X3wY2YzQm9v-rF9vohuTJPo_8GrapADO0TaXlB',
                ),
                const SizedBox(height: 12),
                _buildMessageItem(
                  'Sara',
                  'Thanks for the design files! Looks great.',
                  'Yesterday',
                  false,
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBH5muSqkfpz05QJTFeb7CONs1BYBJ_dm47zImzzpRu7uC1xgGVjN8gSPB-DOk5FXadpWM_z3pgeWucwIQb6UNXoZOjiPDkuiynoEIpRVj20gG7edtfUIbH0pN212TL8JjFoc_HzovvqqH6uBFs-2DSpJu6crn2pj_ev9Q5DqMqLPQEm3mFG_nqX0IOYMIW1_EZDXUFzcR60-bUrOJONJR9wvHBrA_F9S6kp9tsAip309MBxDBvF6APdcF4rhTLEBqWQBcC1peMwhZT',
                ),
                const SizedBox(height: 12),
                _buildMessageItem(
                  'Karim',
                  'Can we reschedule our meeting to tomorrow?',
                  'Tuesday',
                  true,
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAJvNgUorVfV99r47jk44bHsiL6jg7W-h_LhtnqT-dzCK9RL5sNCAtRsM9V8-7gOaM6oegE8994lzXc4k80qpvSj8cuR6c5TAyQZppQM611_wumUqQPMiT51T7y26zr0J1IK-Vl8IRyofOFTy36SHL3dofnotwn9u6NC5P5i80RYrwd92HAeqSJ36usCrHYxQuWaaE4Y690R1W1LkaEdv_EiHkvZ8ZEEMMhYAmrLux16TOKGgDJQYxasu3bXwE9-pZqvhmOhsixQOkw',
                ),
                const SizedBox(height: 12),
                _buildMessageItem(
                  'Emma',
                  'Payment received. Thank you!',
                  'Mon',
                  false,
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBHacCehP03aVCFUind2YXjXkKprMA2AuUePAtyzdw7WguACXgR5gSA0_1D8QKNfSK-gKPaGuKidk8zJZxODgeMFBJ2jQkBDObdK0TWR_Nwq56LxqMWC-J8TPxoBm7DanrgR3CCIW8jIaI_3-nmscCHk8RdJfGQOUWt7TXVi0HJUuQ4KLb6A7-_xpN6KQJOif2HyCj2mDYws-VHT7Qp8xOmELH555fx9qRxndjJpNHrA3ZIov4gmoX_Ru_YeNF6xIVFte4idVZBXRoR',
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(String name, String lastMessage, String time, bool isUnread, String avatarUrl) {
    return Container(
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
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 28, backgroundImage: NetworkImage(avatarUrl)),
              if (isUnread)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF005BBF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isUnread ? const Color(0xFF005BBF) : Colors.grey,
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isUnread ? Colors.black : Colors.grey[600],
                    fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
