import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Stack(
        children: [
          Image.asset(
            "assets/icons/searchBanner.jpeg",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 48,
            top: 68,
            child: SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter text",
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFF7F7F7F)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  prefixIcon: Image.asset("assets/icons/search.png"),
                  suffixIcon: Image.asset("assets/icons/cam.png"),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  focusColor: Colors.black,
                ),
              ),
            ),
          ),
          // Bell and message icons removed
        ],
      ),
    );
  }
}
