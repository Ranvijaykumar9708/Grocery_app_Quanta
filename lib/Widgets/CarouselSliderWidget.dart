import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({super.key});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> with SingleTickerProviderStateMixin {
  final List<String> imgList = [
    "assets/4.jpg",
    "assets/6.jpg",
    "assets/9.jpg",
    "assets/04.jpg",
    "assets/7.jpg",
    "assets/6.jpg",
    "assets/5.jpg",
  ];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height * 0.4;

    return CarouselSlider.builder(
      itemCount: imgList.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return AnimatedBuilder(
          animation: _animationController, 
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imgList[index],
                    width: screenWidth,
                    height: screenHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      },
      options: CarouselOptions(
        height: screenHeight,
        aspectRatio: 16 / 9,
        viewportFraction: 1.0, 
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false, 
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}
