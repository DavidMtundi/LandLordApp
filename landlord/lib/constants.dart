import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;


final List<String> imgList = [
  "assets/images/Electronics.jpg",
  "assets/images/Home.jpg",
  "assets/images/Dressing.jpg",
  "assets/images/Services.jpg"
];

int userid = 2;

//lets define the custom fontsize and the container sizes for different screens
late double customfontsize;
late double customcontainerheight;
late double custombuttonwidth;
late double custombuttonheight;
late double customscreenwidth;
late double customscreenheight;

double CustomHeight(context, height) {
  double defaultvalue = MediaQuery.of(context).size.height;
  return (height * defaultvalue) / 785;
}

double customdividewidth(context, width) {
  double defaultvalue = MediaQuery.of(context).size.width;
  return (defaultvalue / 360) * (defaultvalue / width);
}

double customdivideheight(context, height) {
  double defaultvalue = MediaQuery.of(context).size.height;
  return (defaultvalue / 785) * (defaultvalue / height);
}

double CustomWidth(context, width) {
  double defaultvalue = MediaQuery.of(context).size.width;
  return (width * defaultvalue) / 360;
}

double customfont(context, font) {
  double defaultvalue = MediaQuery.of(context).size.width;
  return (font * defaultvalue) / 360;
}

