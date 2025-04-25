import 'package:bouncy/screens/datatablescreen.dart';
import 'package:bouncy/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickanimate/quickanimate.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin{

  // Animation controller to handle the animations.
  late AnimationController _controller;
  late Animation<Offset> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize the animation controller with a duration of 500 milliseconds.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
    );

    // Bounce animation (vertical movement) from Offset(0, 0) to Offset(0, 5).
    _bounceAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Scale animation from size 1.0 (original size) to 1.2 (20% larger).
    _scaleAnimation = Tween<double>(
      begin: 1.0,  
      end: 1.2,    
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Make the animation repeat in reverse.
    _controller.repeat(reverse: true);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // GestureDetector to handle user taps.
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  PageTransitionAnimation(
                    mode: PageTransitionMode.fade,
                    curve: Curves.fastOutSlowIn,
                    page: Mainscreen(size: _size,)
                  )
                );
              },
              child: AnimatedBuilder(
                animation: _controller, 
                builder: (context, child){
                  return Transform.translate(
                    offset: _bounceAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Image(
                  image: const AssetImage("assets/image.png"),
                  height: 300.h,
                )
              ),
            ),

            // Button to navigate to the DataTable screen.
            TextButton(
              onPressed: (){
                Navigator.push(
                  context,
                  PageTransitionAnimation(
                    mode: PageTransitionMode.fade,
                    curve: Curves.fastOutSlowIn,
                    page: const Datatablescreen()
                  )
                );
              }, 
              child: const Text(
                "Visualize collected data",
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}