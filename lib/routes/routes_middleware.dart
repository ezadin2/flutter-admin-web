import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../data/repositories/authentication/authentication_repository.dart';

class TRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    print("-------------------------Middleware called------------------");
    return AuthenthicationRepository.instance.isAuthenticated
        ? null
        : RouteSettings(name: TRoutes.login);
  }
}
