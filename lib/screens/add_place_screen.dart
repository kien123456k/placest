import 'dart:io';

import 'package:Placest/models/place.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/location_input.dart';
import '../widgets/image_input.dart';
import '../providers/great_places.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;
  bool _titleValidation = true;
  bool _imageValidation = true;
  bool _locationValidation = true;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
    setState(() {
      _imageValidation = true;
    });
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    setState(() {
      _locationValidation = true;
    });
  }

  void _savePlace() {
    if (_titleController.text.isEmpty) {
      _titleValidation = false;
    }
    if (_pickedImage == null) {
      _imageValidation = false;
    }
    if (_pickedLocation == null) {
      _locationValidation = false;
    }
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      setState(() {});
      return;
    }
    Provider.of<GreatPleaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        errorText:
                            _titleValidation ? null : 'Title can\'t be empty',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _titleValidation = true;
                        });
                      },
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    if (!_imageValidation)
                      Text(
                        'Image is required',
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_selectPlace),
                    if (!_locationValidation)
                      Text(
                        'Location is required',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            onPressed: _savePlace,
            elevation: 1,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
