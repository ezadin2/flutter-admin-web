
import 'package:ecommerce_admin_panel/features/shop/models/order_model.dart';

import '../../features/authentication/models/address_model.dart';
import '../../utils/constants/enums.dart';
import '../../utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
List<OrderModel>? orders;
List<AddressModel>? addresses;
  UserModel({
     this.id,
     this.firstName = '',
     this.lastName = '',
     this.username = '',
    required this.email,
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
     this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static UserModel empty() => UserModel(email:'');

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role':role.name.toString(),
      'CreatedAt':createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    AppRole? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        username: data['UserName'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        role: _determineRole(data['Role']),
        createdAt: data['CreatedAt']?.toDate() ?? DateTime.now(),
        updatedAt: data['UpdatedAt']?.toDate() ?? DateTime.now(),
      );
    } else {
      return empty();
    }
  }

  static AppRole _determineRole(String? roleString) {
    if (roleString == null) return AppRole.user;

    // Convert to lowercase for case-insensitive comparison
    final lowerRole = roleString.toLowerCase();

    if (lowerRole == AppRole.admin.name.toLowerCase()) {
      return AppRole.admin;
    } else if (lowerRole == AppRole.delivery.name.toLowerCase()) {
      return AppRole.delivery;
    } else {
      return AppRole.user;
    }
  }
}
