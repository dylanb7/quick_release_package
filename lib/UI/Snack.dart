part of '../quick_release_package.dart';

final flushKey = GlobalKey();

showSnack(String message, BuildContext context, {int seconds = 4, double margin = 8, double borderRad = 8, bool hasBorder = true}) async {
  while(flushKey.currentState.mounted)
    await Future.delayed(Duration(milliseconds: 100));
  Flushbar(
    key: flushKey,
    messageText: Text(
      message,
      style: Theme.of(context).textTheme.headline1,
      textAlign: TextAlign.center,
    ),
    backgroundColor: Theme.of(context).bannerTheme.backgroundColor,
    duration: Duration(seconds: seconds),
    flushbarStyle: FlushbarStyle.FLOATING,
    borderColor: hasBorder ? Theme.of(context).accentColor : Colors.transparent,
    borderWidth: hasBorder ? 2 : 0,
    borderRadius: BorderRadius.circular(borderRad),
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.all(margin),
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  )..show(context);
}