import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedSvgImage extends StatefulWidget {
  final String imagePath;
  const AnimatedSvgImage({super.key, required this.imagePath});

  @override
  _AnimatedSvgImageState createState() => _AnimatedSvgImageState();
}

class _AnimatedSvgImageState extends State<AnimatedSvgImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: SvgPicture.asset(
            widget.imagePath,
            width: width*(2/3),
            height: width*(2/3),
          ),
        );
      },
    );
  }
}
