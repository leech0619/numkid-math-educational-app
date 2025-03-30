import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../controller/arcade_controller.dart';
import '../controller/comparing_controller.dart';
import '../controller/composing_controller.dart';
import '../controller/counting_controller.dart';
import '../controller/ordering_controller.dart';
import '../utils/audio_service.dart';

/// Returns a list of providers for the app.
List<SingleChildWidget> appProviders = [
  Provider<AudioService>(create: (_) => AudioService()),
  ChangeNotifierProvider(create: (_) => CountingController()),
  ChangeNotifierProvider(create: (_) => ComparingController()),
  ChangeNotifierProvider(create: (_) => OrderingController()),
  ChangeNotifierProvider(create: (_) => ComposingController()),
  ChangeNotifierProvider(create: (_) => ArcadeController()),
];
