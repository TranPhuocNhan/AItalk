import 'package:flutter/material.dart';

class TypeIndicator extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _TypeIndicatorState();
}

class _TypeIndicatorState extends State<TypeIndicator> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(_animation),
        SizedBox(width: 5),
        _buildDot(_animation),
        SizedBox(width: 5),
        _buildDot(_animation),
      ],
    );
  }

  Widget _buildDot(Animation<double> animation) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      ),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}