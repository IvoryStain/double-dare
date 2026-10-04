import 'package:shared_preferences/shared_preferences.dart';

class GameSession {
  static const String _gameIdKey = 'game_id';
  static const String _playerIdKey = 'player_id';
  static const String _playerNumberKey = 'player_number';
  static const String _playerNameKey = 'player_name';

  static Future<void> save({
    required String gameId,
    required String playerId,
    required int playerNumber,
    required String playerName,
  }) async {
    final prefs = SharedPreferencesAsync();

    await prefs.setString(_gameIdKey, gameId);
    await prefs.setString(_playerIdKey, playerId);
    await prefs.setInt(_playerNumberKey, playerNumber);
    await prefs.setString(_playerNameKey, playerName);
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = SharedPreferencesAsync();

    final gameId = await prefs.getString(_gameIdKey);
    final playerId = await prefs.getString(_playerIdKey);
    final playerNumber = await prefs.getInt(_playerNumberKey);
    final playerName = await prefs.getString(_playerNameKey);

    if (gameId == null ||
        playerId == null ||
        playerNumber == null ||
        playerName == null) {
      return null;
    }

    return {
      'gameId': gameId,
      'playerId': playerId,
      'playerNumber': playerNumber,
      'playerName': playerName,
    };
  }

  static Future<void> clear() async {
    final prefs = SharedPreferencesAsync();

    await prefs.remove(_gameIdKey);
    await prefs.remove(_playerIdKey);
    await prefs.remove(_playerNumberKey);
    await prefs.remove(_playerNameKey);
  }
}