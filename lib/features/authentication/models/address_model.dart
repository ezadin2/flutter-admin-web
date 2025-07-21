import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';

class AddressModel {
  String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final double latitude;
  final double longitude;
  final DateTime? dateTime;
  bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.dateTime,
    this.selectedAddress = true,
  });

  String get formattedphoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static AddressModel empty() => AddressModel(
    id: '',
    name: '',
    phoneNumber: '',
    street: '',
    city: '',
    state: '',
    postcode: '',
    country: '',
    latitude: 0.0,
    longitude: 0.0,
  );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Street': street,
      'City': city,
      'State': state,
      'PostalCode': postcode,
      'Country': country,
      'Latitude': latitude,
      'Longitude': longitude,
      'DateTime': DateTime.now(),
      'SelectedAddress': selectedAddress,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic>? data) {
    data ??= {}; // Handle null map
    return AddressModel(
      id: data['Id']?.toString() ?? '',
      name: data['Name']?.toString() ?? '',
      phoneNumber: data['PhoneNumber']?.toString() ?? '',
      street: data['Street']?.toString() ?? '',
      city: data['City']?.toString() ?? '',
      state: data['State']?.toString() ?? '',
      postcode: data['PostalCode']?.toString() ?? '',
      country: data['Country']?.toString() ?? '',
      latitude: _parseDouble(data['Latitude']),
      longitude: _parseDouble(data['Longitude']),
      selectedAddress: data['SelectedAddress'] as bool? ?? true,
      dateTime: _parseDateTime(data['DateTime']),
    );
  }

  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return AddressModel.fromMap(snapshot.data() as Map<String, dynamic>?);
  }

  @override
  String toString() {
    return '$street, $city, $state, $postcode, $country';
  }

  // Helper methods
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}