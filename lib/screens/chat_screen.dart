import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF005BBF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDQGQmn-DfHRhwYbsAbeaMa4LPTNimMMUGSitrCbqC_bHB6rAhovET4emV-p0nWZUSNn5jbxbzmtsvnwe4dzqbF5Ur0WIY4JATGHFHQPVqQ7b0o0MyJe4-o-fpqIWHgS5As_SGibek7-nU_tdkOM2A3alUxE5wmlhfjCXzjqKIFNLArSOVuxG0K1qu7qQBXdA9gTBCG6M_otHRlIJcxSMhHJka0NjMd26UjoNjWRhVG2C8CNHAfmqFK-Kh7UFNxELQvzZyA3pxBXBUp'),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahmed',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Active mission',
                    style: GoogleFonts.inter(fontSize: 10, color: Colors.orange[800], fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Colors.grey)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.grey)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildDateDivider('Today'),
                _buildSystemMessage(Icons.check_circle, 'Ahmed accepted your request', Colors.green),
                _buildSystemMessage(Icons.payments, 'Payment secured', Colors.orange),
                const SizedBox(height: 24),
                _buildIncomingMessage(
                  'Hi there! I\'m ready to start working on the plumbing issue. Could you confirm the exact address again?',
                  '10:42 AM',
                ),
                const SizedBox(height: 16),
                _buildOutgoingMessage(
                  'Great! Yes, it\'s 123 Main St, Apt 4B. The main valve is under the sink.',
                  '10:45 AM',
                ),
                const SizedBox(height: 16),
                _buildIncomingMessage(
                  'Perfect, I\'ll be there in about 20 minutes.',
                  '10:46 AM',
                ),
              ],
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String label) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3FD),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSystemMessage(IconData icon, String text, Color color) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E2EC)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingMessage(String text, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDQGQmn-DfHRhwYbsAbeaMa4LPTNimMMUGSitrCbqC_bHB6rAhovET4emV-p0nWZUSNn5jbxbzmtsvnwe4dzqbF5Ur0WIY4JATGHFHQPVqQ7b0o0MyJe4-o-fpqIWHgS5As_SGibek7-nU_tdkOM2A3alUxE5wmlhfjCXzjqKIFNLArSOVuxG0K1qu7qQBXdA9gTBCG6M_otHRlIJcxSMhHJka0NjMd26UjoNjWRhVG2C8CNHAfmqFK-Kh7UFNxELQvzZyA3pxBXBUp'),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F3FD),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Text(
                  text,
                  style: GoogleFonts.inter(fontSize: 14, height: 1.4),
                ),
              ),
              const SizedBox(height: 4),
              Text(time, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildOutgoingMessage(String text, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF005BBF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  text,
                  style: GoogleFonts.inter(fontSize: 14, height: 1.4, color: Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 14, color: Color(0xFF005BBF)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline, color: Colors.grey)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3FD),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.inter(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(color: Color(0xFF005BBF), shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
