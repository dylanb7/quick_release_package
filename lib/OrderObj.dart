part of 'quick_release_package.dart';

mixin OrderObj {

  String get userID;

  //List of menuObj ids
  List<String> get orderContents;

  //menuObj id : item modification
  Map<String, Modification> get modifications;

  String get orderStatus;

  Map<String, dynamic> toMap();

}

mixin OrderDeserializer {

  OrderObj fromMap(Map<String, dynamic> map);

}

mixin Modification {

  double get cost;

  String get portion;

  String get specialRequest;

  List<String> get addOns;

  List<String> removals;

  Map<String, dynamic> toMap();

}

mixin ModificationDeserializer {

  Modification fromMap(Map<String, dynamic> map);

}

mixin addOn {

}
