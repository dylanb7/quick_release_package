part of 'quick_release_package.dart';


//pricing: map<String(Portion) : double(cost)>
mixin MenuObj {

  Uint8List _bytes;

  String get getName;

  String get description;

  String get getMealType;

  String get mealCategory;

  List<String> sizes();

  double getCost(String portion);

  String getID();

  Image getWidget() {
    if(this._bytes == null || this._bytes.isEmpty)
      return null;
    return Image.memory(this._bytes, fit: BoxFit.fill);
  }

  //exclude image
  Map<String, String> toMap();

}

mixin MenuDeserializer {

  MenuObj fromMap(Map<String, dynamic> map);

}