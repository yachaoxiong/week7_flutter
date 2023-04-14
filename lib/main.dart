import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Multimedia App')),
        body: MultimediaApp(),
      ),
    );
  }
}

class MultimediaApp extends StatefulWidget {
  @override
  _MultimediaAppState createState() => _MultimediaAppState();
}

class _MultimediaAppState extends State<MultimediaApp> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.network(
        'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4');
    await _videoController!.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        Text('Image from the Internet', style: TextStyle(fontSize: 18)),
        CachedNetworkImage(
          imageUrl: 'https://picsum.photos/250?image=9',
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        SizedBox(height: 16),
        Text('Take a picture using the camera', style: TextStyle(fontSize: 18)),
        ElevatedButton.icon(
          onPressed: _takePicture,
          icon: Icon(Icons.camera_alt),
          label: Text('Take Picture'),
        ),
        if (_image != null) Image.file(_image!),
        SizedBox(height: 16),
        Text('Play and pause a video', style: TextStyle(fontSize: 18)),
        if (_videoController != null && _videoController!.value.isInitialized)
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _videoController!.play();
                setState(() {});
              },
              icon: Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: () {
                _videoController!.pause();
                setState(() {});
              },
              icon: Icon(Icons.pause),
            ),
          ],
        ),
      ],
    );
  }
}
