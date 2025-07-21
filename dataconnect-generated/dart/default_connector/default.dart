library default_connector;

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart'; // Add this import
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class ConnectorConfig {
  final String region;
  final String bucketName;
  final String databaseName;

  ConnectorConfig(this.region, this.bucketName, this.databaseName);
}

enum CallerSDKType {
  generated,
  admin,
}

class FirebaseDataConnect {
  final ConnectorConfig connectorConfig;
  final CallerSDKType sdkType;

  FirebaseDataConnect({required this.connectorConfig, required this.sdkType});

  static FirebaseDataConnect instanceFor({
    required ConnectorConfig connectorConfig,
    required CallerSDKType sdkType,
  }) {
    return FirebaseDataConnect(connectorConfig: connectorConfig, sdkType: sdkType);
  }
}

class DefaultConnector {
  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'default',
    'ecommerceadminpanel',
  );

  DefaultConnector({required this.dataConnect});

  static DefaultConnector get instance {
    return DefaultConnector(
      dataConnect: FirebaseDataConnect.instanceFor(
        connectorConfig: connectorConfig,
        sdkType: CallerSDKType.generated,
      ),
    );
  }

  FirebaseDataConnect dataConnect;
}