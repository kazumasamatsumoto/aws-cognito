import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PickerSample extends StatefulWidget {
  @override
  _PickerSampleState createState() => _PickerSampleState();
}

class _PickerSampleState extends State<PickerSample> {
  File _image;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body: Container(
        width: 160,
        height: 100,
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: _image == null
              ? Center(child: Text('+'))
              : Image.file(
                  _image,
                  width: 100.0,
                  height: 100.0,
                ),
        ),
      ),
      // body: Center(
      //   child: _image == null ? Text('No image selected') : Image.file(_image),
      // ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: getImageFromCamera,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: getImageFromGallery,
              child: Icon(Icons.photo_library),
            ),
          ),
        ],
      ),
    );
  }
}
