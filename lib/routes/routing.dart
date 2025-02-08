import 'package:flutter/material.dart';
import '../screens/adoption_timelines.dart';
import '../screens/listing.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.petListScreen:
        return MaterialPageRoute(builder: (_) => PetListScreen());
      case Routes.adoptedPetsTimelineScreen:
        return MaterialPageRoute(builder: (_) => AdoptedPetsTimelineScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('404 Page Not Found')),
          ),
        );
    }
  }
}
