part of '../quick_release_package.dart';

mixin BitesManager {

  Future<bool> logOrder(String userID, OrderObj order);

  Stream<OrderObj> orderListener(String adminID);

  Stream<MenuObj> getMenuItems(List<String> ids, MenuDeserializer deserializer) async* {
    Map<String, Map<String, dynamic>> items = {};
    _getImages(ids).listen((event) async* {
      final String name = event.id;
      if(items.containsKey(name))
        yield deserializer.fromMap(items[name]..addAll({DBConstants.IMAGE : event.bytes}));
      else
        items[name] = {DBConstants.IMAGE : event._bytes};
    });
    _getMenuItemData(ids).listen((event) async* {
      final String name = event[DBConstants.ID];
      if(items.containsKey(name))
        yield deserializer.fromMap(event..addAll(items[name]));
      else
        items[name] = event;
    });
  }

  Stream<ImageObj> _getImages(List<String> ids) async* {
   for(String id in ids)
     yield await getImage(id);
  }

  Stream<Map<String, String>> _getMenuItemData(List<String> ids) async* {
    for(String id in ids)
      yield await getMenuItem(id);
  }

  Future<ImageObj> getImage(String id);

  Future<Map<String, String>> getMenuItem(String id);

}

