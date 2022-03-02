import 'package:flutter/material.dart';
import 'package:landlord/constants.dart';

class SubmitButton extends StatefulWidget {
  final String title;
  final Function act;
  final Color? colorprovided;
  final bool resizableheight;
  SubmitButton(
      {Key? key,
      this.colorprovided,
      required this.title,
      required this.act,
      this.resizableheight = false})
      : super(key: key);

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.resizableheight
          ? const EdgeInsets.only(top: 2, left: 5, bottom: 1, right: 2)
          : EdgeInsets.only(
              top: CustomHeight(context, 24.0),
              left: CustomWidth(context, 24.0),
              right: CustomWidth(context, 24.0)),
      child: Container(
        width: customdividewidth(context, 1),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: widget.resizableheight
                      ? BorderRadius.circular(5)
                      : BorderRadius.circular(customfont(context, 30.0)),
                ),
                color: widget.colorprovided ?? Theme.of(context).primaryColor,
                onPressed: () => widget.act(),
                child: Container(
                  padding: widget.resizableheight
                      ? const EdgeInsets.all(1)
                      : EdgeInsets.symmetric(
                          vertical: CustomHeight(context, 15),
                          horizontal: CustomWidth(context, 10),
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
