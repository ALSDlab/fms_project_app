import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/env/.env', obfuscate: true, useConstantCase: true)
abstract class Env {
  // GOOGLE_MAP_API_KEY
  @EnviedField()
  static String googleMapApiKey = _Env.googleMapApiKey;
}
