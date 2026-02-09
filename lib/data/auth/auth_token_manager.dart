import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuthTokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final SharedPreferences _sharedPreferences;

  AuthTokenManager(this._sharedPreferences);

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _sharedPreferences.setString(_accessTokenKey, accessToken);
    await _sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  String? getAccessToken() {
    return _sharedPreferences.getString(_accessTokenKey);
  }

  String? getRefreshToken() {
    return _sharedPreferences.getString(_refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _sharedPreferences.remove(_accessTokenKey);
    await _sharedPreferences.remove(_refreshTokenKey);
  }
}
