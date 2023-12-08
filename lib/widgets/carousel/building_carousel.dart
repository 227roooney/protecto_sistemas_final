import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key, required this.id});

  final String id;

  @override
  State<StatefulWidget> createState() {
    return _ImageCarouselState();
  }
}

class _ImageCarouselState extends State<ImageCarousel> {
  List<String> imageUrls = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadImageUrls();
  }

  Future<void> _loadImageUrls() async {
    try {
      final storage = FirebaseStorage.instance;
      var listResult = await storage.ref('buildings/${widget.id}/').listAll();

      for (var item in listResult.items) {
        var url = await item.getDownloadURL();
        imageUrls.add(url);
      }

      setState(() {});
    } catch (e) {
      print('Error loading image URLs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 230.0,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 215.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageUrls.map((url) {
              int index = imageUrls.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Color.fromARGB(255, 255, 255, 255)
                      : Colors.grey.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}