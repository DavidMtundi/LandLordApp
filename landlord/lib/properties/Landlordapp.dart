import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandlordApp {
  static const String appName = "TenantManagement";
  static SharedPreferences? preferences;
  static User? user = FirebaseAuth.instance.currentUser;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static String collectionUser = "landlords";
  static String collectionOrders = "orders";
  static String usercartList = "usercart";
  static String subcollectionAddress = "useraddress";
  static String userphone = "phone";
  static String isuser = "isuser";

  static const String userName = "name";
  static const String userEmail = "email";
  static const String userUID = "uid";
  static const String userPhotoUrl = "photourl";
  static const String userAvatarurl = "url";

  static const String addressId = "addressId";
  static const String totalamount = "totalAmount";
  static const String productId = "productid";
  static const String paymentdetails = "paymentdetails";
  static const String ordertime = "ordertime";
  static const String issuccess = "issuccess";

  static String currentuserPhotUrl = "";
}
