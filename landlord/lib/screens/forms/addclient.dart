//should contain the drop down and everything
import 'package:flutter/material.dart';
import 'package:landlord/responsive.dart';

class AddClient extends StatelessWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Responsive(mobile: addclientmobile(), desktop: addclientdesktop());
  }
}
Widget addclientmobile(){
  return Scaffold(

  );
}
Widget addclientdesktop(){
  return Container(

  );
}



// ignore: must_be_immutable


