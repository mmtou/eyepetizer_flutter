import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Photo extends StatefulWidget {
  final List urls;

  Photo(this.urls);

  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  PageController pageController = PageController(initialPage: 0);

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(widget.urls[index]),
                  initialScale: PhotoViewComputedScale.contained,
                );
              },
              itemCount: widget.urls.length,
              backgroundDecoration: BoxDecoration(color: Colors.black),
              pageController: pageController,
              onPageChanged: onPageChanged,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Text(
                    '$index / ${widget.urls.length}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  onPageChanged(index) {
    setState(() {
      this.index = index + 1;
    });
  }
}
