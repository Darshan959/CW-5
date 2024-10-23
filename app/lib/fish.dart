import 'package:flutter/material.dart';

class Fish extends StatefulWidget {
  final Color color;
  final double speed;

  Fish({required this.color, required this.speed});

  @override
  _FishState createState() => _FishState();
}

class _FishState extends State<Fish> with SingleTickerProviderStateMixin {
  double positionX = 0;
  double positionY = 0;
  double deltaX = 1;
  double deltaY = 1;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(seconds: widget.speed.toInt()), vsync: this);
    _controller.repeat();
    _controller.addListener(() {
      _moveFish();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _moveFish() {
    setState(() {
      positionX += deltaX;
      positionY += deltaY;

      if (positionX >= 300 || positionX <= 0) {
        deltaX = -deltaX;
      }
      if (positionY >= 300 || positionY <= 0) {
        deltaY = -deltaY;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: positionX,
      top: positionY,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ),
      ),
    );
  }
}
