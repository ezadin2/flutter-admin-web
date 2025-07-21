import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/features/authentication/models/address_model.dart';
import 'package:ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';

import '../../../utils/formatters/formatter.dart';

class UserModel {
  final String? id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;

  DateTime? createdAt;
  DateTime? updatedAt;
  List<OrderModel>? order;
  List<AddressModel>? address;

  UserModel({
    this.id,
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    required this.email,
    this.phoneNumber = '',
    this.profilePicture = '',
    this.createdAt,
    this.updatedAt,
    this.role = AppRole.user,
  });

  String get fullName => '$firstName $lastName';
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAt => TFormatter.formatDate(updatedAt);

  // static List<String> nameParts(String fullName) => fullName.split(" ");
  //
  // static String generateUsername(String fullName) {
  //   List<String> nameParts = fullName.split("_");
  //   String firstName = nameParts[0].toLowerCase();
  //   String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";
  //
  //   String camelCaseUsername = "$firstName${lastName.isNotEmpty ? "_$lastName" : ""}";
  //   String usernameWithPrefix = "cwt_$camelCaseUsername";
  //   return usernameWithPrefix;
  // }

  static UserModel empty() => UserModel(
        email: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
      'Role': role.name.toString()
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      return UserModel(
        id: document.id,
        firstName: data.containsKey('FirstName') ? data['FirstName'] ?? '' : '',
        lastName: data.containsKey('LastName') ? data['LastName'] ?? '' : '',
        username: data.containsKey('UserName') ? data['UserName'] ?? '' : '',
        email: data.containsKey('Email') ? data['Email'] ?? '' : '',
        phoneNumber:
            data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
        profilePicture: data.containsKey('ProfilePicture')
            ? data['ProfilePicture'] ?? ''
            : '',
        role: data.containsKey('Role')
            ? (data['Role'] ?? AppRole.user) == AppRole.admin.name.toString()
                ? AppRole.admin
                : AppRole.user
            : AppRole.user,
        createdAt: data.containsKey('CreatedAt')
            ? data['CreatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
        updatedAt: data.containsKey('UpdatedAt')
            ? data['UpdatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
      );
    } else {
      return UserModel.empty();
    }
  }
}
