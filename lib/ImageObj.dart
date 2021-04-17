part of 'quick_release_package.dart';

class ImageObj {

  final String _id;

  final Uint8List _bytes;

  ImageObj(this._bytes, this._id);

  Uint8List get bytes => _bytes;

  String get id => _id;

}