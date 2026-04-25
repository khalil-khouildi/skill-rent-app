import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Post your need',
      description: "Describe what you need help with. It's quick, easy, and completely free.",
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAo02-sft44s114mFpBbxNu2LrLDNb25-A9ONUO5WKxOySguJ8Hj85gxqZV7-kzJDkTWRe20MZiA5_dYRmr_B_MDOR67J_kn-1zfYuP8CToF2ZnZjVeD_pFK2ABwYV4-z-pq1Un3FFfrvlzmzMYwfQdL9laznZZbiCpnGh8H0quDMLVzPkqozNkEjphnSwbTeRL8b289LCVq9QCHa4jMwljdNNZ7MbsmTi75M37Zd9yHJwBh985DyyZ9jv5bWcfMpj-0alv8rtN462q',
    ),
    OnboardingData(
      title: 'Get applicants',
      description: "Review offers from skilled professionals ready to help.",
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBj-it1Wk3hHqx5CzfdOZeqKctf0F3jGWrISNxvWVGxJ9ajUMcn78SPas0wrQhZ5SbcoqhMIYCwFjDeqy1dewtwlZnWtYSh1He-7RQlunNe_fVgOz5shxdpfD9o-crHSpj_v_LiNe9oPhmAdWPyrFP3pZMgsOf6BzopXBjYr-ZGaFQBCIe9SnrrNytWXHNImtWuQVyriuqBtOZI8FSJ4uvAaRqaSJmMguBW55uBGPg5LiGcGp3MCM7IdqWdyRpbMhoL2ilmDxSRiICU',
    ),
    OnboardingData(
      title: 'Get it done',
      description: "Choose the best fit and watch your task get completed smoothly.",
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDqczdzU1S-zLbasSZ4N_xkcM5EEZ05MjgG78RLX1iKWz89HdN77Jc3ChBXnBF9toyWudZ54tCjQMzL5PPcJv-7A2HD411Xxje0qQPaAFxqWH6i3NEfY4pdc5TLq2PVkCnleVky7ShvK8R3zz4OVNPJNU5NDffs4hO97JkCuczRDkQME4RQSWRSkOIMnZdYj9xuWTctNjNC5myE61hXkdBXmg8G6U5CydidqyxgzL271vCJYRHq97FOo0VrjEivC4-6PRhTr3H_eSa2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC5B13);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: NetworkImage(_pages[index].imageUrl),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          _pages[index].title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.publicSans(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF221610),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _pages[index].description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.publicSans(
                            fontSize: 18,
                            color: const Color(0xFF221610).withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? primaryColor : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/welcome');
                        },
                        child: Text(
                          'Skip',
                          style: GoogleFonts.publicSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pushReplacementNamed(context, '/welcome');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                              style: GoogleFonts.publicSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imageUrl;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
