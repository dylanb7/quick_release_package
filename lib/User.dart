part of 'quick_release_package.dart';

mixin User {

  String get userID;

  Map<String, dynamic> toMap();

}

mixin UserDeserializer {

  User fromMap(Map<String, dynamic> data);

}