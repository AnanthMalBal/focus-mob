import 'package:flutter/material.dart';
import 'package:focusontime/screens/colors.dart';

class LogoLoader extends StatelessWidget {
  final double size;
  final String logoPath;
  final Color loaderColor;

  const LogoLoader({
    Key? key,
    this.size = 80.0, // Default size for the loader
    this.logoPath = 'images/focus_topnav.jpg', // Default logo path
    this.loaderColor = AppColors.primaryColor, // Default loader color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
  child: Container(
    width: size + 20, // Slightly larger than the loader
    height: size + 20,
    decoration: BoxDecoration(
      color: Colors.white, // Background color
      borderRadius: BorderRadius.circular(10), // Rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(10), // Add some spacing inside the box
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center, // ✅ Ensures perfect centering
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
              ),
            ),
            Positioned.fill( // ✅ Ensures logo is properly centered
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "images/focus_topnav.jpg",
                  width: size * 0.5, // ✅ 50% of the loader size
                  height: size * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
    // return Center(
    //   child: SizedBox(
    //     width: size,
    //     height: size,
    //     child: Stack(
    //       alignment: Alignment.center, // ✅ Ensures perfect centering
    //       children: [
    //         SizedBox(
    //           width: size,
    //           height: size,
    //           child: CircularProgressIndicator(
    //             strokeWidth: 6,
    //             valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
    //           ),
    //         ),
    //         Positioned.fill( // ✅ Ensures logo is properly centered
    //           child: Align(
    //             alignment: Alignment.center,
    //             child: Image.asset(
    //               "images/focus_topnav.jpg",
    //               width: size * 0.5, // ✅ 50% of the loader size
    //               height: size * 0.5,
    //               fit: BoxFit.contain,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}