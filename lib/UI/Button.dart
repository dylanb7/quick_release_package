part of '../quick_release_package.dart';

Widget button(String text, Function click, BuildContext context,
    {double borderRad = 25.0, double buttonElevation = 15, Color backgroundColor, Color textColor}) {
  return ElevatedButton(
      onPressed: click,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            final Color background = backgroundColor ?? Theme.of(context).primaryColorDark;
            if (states.contains(MaterialState.pressed))
              return background.withOpacity(0.6);
            if (states.contains(MaterialState.disabled))
              return background.withOpacity(0.4);
            return background;
          }),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
            final TextStyle style =
                TextStyle(color: textColor ?? Theme.of(context).primaryColor, fontSize: 30);
            if (states.contains(MaterialState.pressed))
              return style.apply(color: style.color.withOpacity(0.8));
            if (states.contains(MaterialState.disabled))
              return style.apply(color: style.color.withOpacity(0.6));
            return style;
          }),
          alignment: Alignment.center,
          elevation: MaterialStateProperty.resolveWith<double>((states) {
            if (states.contains(MaterialState.pressed))
              return buttonElevation / 2;
            if (states.contains(MaterialState.disabled)) return 0;
            return buttonElevation;
          }),
          shadowColor: MaterialStateProperty.all<Color>(
              Theme.of(context).primaryColorDark),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRad))),
          ),
          splashFactory: NoSplash.splashFactory),
      child: Text(
        text,
        style: TextStyle(color: textColor ?? Theme.of(context).primaryColor, fontSize: 30),
      ));
}
