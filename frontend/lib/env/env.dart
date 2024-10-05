import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/env/.env', useConstantCase: true)
final class Env {
  @EnviedField()
  static const String openaiApiKey = _Env.openaiApiKey;
}
