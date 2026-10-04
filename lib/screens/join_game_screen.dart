import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'game_screen.dart';
import '../services/game_session.dart';
import '../services/app_strings.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() =>
      _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _codeController =
      TextEditingController();

  bool _joiningGame = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinGame() async {
    final playerName = _nameController.text.trim();
    final gameCode =
        _codeController.text.trim().toUpperCase();

    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.t('please_enter_name'),
          ),
        ),
      );

      return;
    }

    if (gameCode.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.t('please_enter_code'),
          ),
        ),
      );

      return;
    }

    setState(() {
      _joiningGame = true;
    });

    try {
      final supabase = Supabase.instance.client;

      final result = await supabase.rpc(
        'join_game',
        params: {
          'p_invite_code': gameCode,
          'p_player_name': playerName,
        },
      );

      final data = Map<String, dynamic>.from(
        result as Map,
      );

      final gameId = data['game_id'] as String;
      final playerId = data['player_id'] as String;
      final playerNumber =
          data['player_number'] as int;
      final savedName =
          data['player_name'] as String;

      await GameSession.save(
        gameId: gameId,
        playerId: playerId,
        playerNumber: playerNumber,
        playerName: savedName,
      );

      if (!mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(
            gameId: gameId,
            playerId: playerId,
            playerNumber: playerNumber,
            startingPlayerName: savedName,
            inviteCode: gameCode,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '''${AppStrings.t('could_not_join')}: $error''',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _joiningGame = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.t('join_game')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(24, 20, 24, 40),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              Icon(
                Icons.favorite,
                color: colors.primary,
                size: 52,
              ),

              const SizedBox(height: 20),

              Text(
                AppStrings.t('join_your_partner'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                AppStrings.t('join_description'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: colors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _nameController,
                textCapitalization:
                    TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: AppStrings.t('your_name'),
                  hintText: AppStrings.t('enter_name'),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _codeController,
                textCapitalization:
                    TextCapitalization.characters,
                maxLength: 5,
                decoration: InputDecoration(
                  labelText: AppStrings.t('game_code'),
                  hintText: 'ABCDE',
                  counterText: '',
                  prefixIcon:
                      const Icon(Icons.tag),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(
                    alpha: isDark ? 0.12 : 0.08,
                  ),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppStrings.t('join_info'),
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      _joiningGame ? null : _joinGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                  child: _joiningGame
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onPrimary,
                          ),
                        )
                      : Text(
                          AppStrings.t('join_game_button'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
