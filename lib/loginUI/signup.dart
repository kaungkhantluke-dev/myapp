import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -70,
            top: -380,
            child: CircleAvatar(backgroundColor: Colors.black54, radius: 400),
          ),
          Positioned(
            right: -55,
            top: 40,
            child: CircleAvatar(backgroundColor: Colors.white, radius: 48),
          ),
          Positioned(
            left: 35,
            bottom: -380,
            child: CircleAvatar(backgroundColor: Colors.black54, radius: 400),
          ),
          Positioned(
            left: 55,
            bottom: -65,
            child: CircleAvatar(backgroundColor: Colors.white, radius: 68),
          ),
          Positioned(
            top: 200,
            right: 60,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(5, 5),
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              width: 320,
              height: 420,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Enter your email',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Enter password',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Re-enter password',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      elevation: 8,
                    ),
                    onPressed: () {},
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
