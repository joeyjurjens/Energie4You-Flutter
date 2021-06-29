import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:camera/camera.dart';
import 'package:energie4you/widgets/app_bar_container.dart';
import 'package:energie4you/Screens/picture_taken_screen.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final mediaSize = MediaQuery.of(context).size;
            final scale = 1 / (_controller.value.aspectRatio * mediaSize.aspectRatio);
            return ClipRect(
              clipper: MediaSizeClipper(mediaSize),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: CameraPreview(_controller),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            XFile image = await _controller.takePicture();
            final documentsDirectory = await getApplicationDocumentsDirectory();
            final imagePath = documentsDirectory.path + "/" + image.hashCode.toString();
            image.saveTo(imagePath);

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// Clipper that allows the camera to be full screen with no weird stretches!
class MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const MediaSizeClipper(this.mediaSize);
  
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }
  
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}