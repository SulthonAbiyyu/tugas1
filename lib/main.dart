import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundPainter(_rotationController.value),
                child: Container(),
              );
            },
          ),
          
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Header Section dengan Row
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildHeaderSection(),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // About Section
                    _buildAnimatedSection(
                      delay: 200,
                      child: _buildAboutSection(),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Skills Section dengan Row & Column
                    _buildAnimatedSection(
                      delay: 400,
                      child: _buildSkillsSection(),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Projects Section dengan Row
                    _buildAnimatedSection(
                      delay: 600,
                      child: _buildProjectsSection(),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Contact Section dengan Row
                    _buildAnimatedSection(
                      delay: 800,
                      child: _buildContactSection(),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.blue.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Profile Image dengan animasi pulse
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.95, end: 1.05),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            onEnd: () {
              setState(() {});
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Matchaby',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      color: Colors.purpleAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Flutter Developer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Indonesia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.purpleAccent,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'About Me',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Hai, Saya Muhammad Sulthon Abiyyu, Panggil Saja Abi, Saya Saat Ini Sedang Berkuliah Di Universitas Muhammadiyah Sidoarjo.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    final skills = [
      {'name': 'React Native', 'level': 0.5, 'icon': Icons.phone_android},
      {'name': 'JavaScript', 'level': 0.85, 'icon': Icons.code},
      {'name': 'UI/UX', 'level': 0.8, 'icon': Icons.design_services},
      {'name': 'MySql', 'level': 0.75, 'icon': Icons.cloud},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Skills',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Skills dengan Row & Column
          Column(
            children: skills.map((skill) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              skill['icon'] as IconData,
                              color: Colors.cyanAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              skill['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${((skill['level'] as double) * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: skill['level'] as double),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: value,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.cyanAccent,
                            ),
                            minHeight: 8,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    final projects = [
      {
        'title': 'E-Commerce App',
        'desc': 'Modern shopping app',
        'image': 'assets/images/projects1.jpg',
        'color': Colors.purple,
      },
      {
        'title': 'Social Media',
        'desc': 'Connect with friends',
        'image': 'assets/images/projects2.jpg',
        'color': Colors.blue,
      },
      {
        'title': 'Fitness Tracker',
        'desc': 'Track your health',
        'image': 'assets/images/projects3.jpg',
        'color': Colors.green,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Projects',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Projects Grid menggunakan Row & Column
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildProjectCard(projects[0]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProjectCard(projects[1]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildProjectCard(projects[2]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (project['color'] as Color).withOpacity(0.3),
              (project['color'] as Color).withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (project['color'] as Color).withOpacity(0.3),
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                project['image'] as String,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: (project['color'] as Color).withOpacity(0.2),
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.white30,
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project['desc'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    final contacts = [
      {'icon': Icons.email, 'text': 'fake@email.com', 'color': Colors.red},
      {'icon': Icons.phone, 'text': '+62 812-0000-0000', 'color': Colors.green},
      {'icon': Icons.link, 'text': 'github.com/sulthonabiyyu', 'color': Colors.purple},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.3),
            Colors.deepOrange.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.contact_mail,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Contact',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Contact Items dengan Row
          Column(
            children: contacts.map((contact) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (contact['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        contact['icon'] as IconData,
                        color: contact['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        contact['text'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Animated circles
    for (int i = 0; i < 5; i++) {
      final angle = (animationValue * 2 * math.pi) + (i * math.pi / 2.5);
      final x = size.width / 2 + math.cos(angle) * (size.width / 3);
      final y = size.height / 2 + math.sin(angle) * (size.height / 3);

      paint.color = [
        Colors.purple.withOpacity(0.1),
        Colors.blue.withOpacity(0.1),
        Colors.cyan.withOpacity(0.1),
        Colors.pink.withOpacity(0.1),
        Colors.orange.withOpacity(0.1),
      ][i];

      canvas.drawCircle(Offset(x, y), 100 + (i * 20), paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => true;
}