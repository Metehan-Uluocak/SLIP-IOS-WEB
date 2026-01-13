import '../models/user.dart';
import '../models/leak.dart';
import '../models/source.dart';
import '../models/platform.dart';

@Deprecated('Use backend API instead. Remove this file after API integration.')
class MockData {
  static final List<User> users = const [];
  static final List<Leak> leaks = const [];
  static final List<Source> sources = const [];
  static final List<Platform> platforms = const [];
  static const String defaultPassword = '';
}
