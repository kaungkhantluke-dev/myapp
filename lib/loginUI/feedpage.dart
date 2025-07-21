import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background circles
            Positioned(
              top: -screenHeight * 0.5,
              right: -screenWidth * 0.2,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: screenWidth * 1.0,
              ),
            ),
            Positioned(
              top: screenHeight * 0.05,
              right: -screenWidth * 0.1,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: screenWidth * 0.15,
              ),
            ),
            Positioned(
              bottom: -screenHeight * 0.6,
              left: -screenWidth * 0.07,
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: screenWidth * 1.0,
              ),
            ),
            Positioned(
              bottom: -screenHeight * 0.07,
              left: screenWidth * 0.09,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: screenWidth * 0.15,
              ),
            ),

            // Feed content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: screenWidth * 0.85,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feed Page',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Add your feed content here
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
