import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'create_game_screen.dart';
import 'join_game_screen.dart';
import 'game_screen.dart';
import '../services/game_session.dart';
import '../services/app_strings.dart';
import '../services/language_controller.dart';
import '../widgets/app_settings_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _checkingSession = true;
  bool _autoRejoinFailed = false;

  @override
  void initState() {
    super.initState();

    LanguageController.language.addListener(
      _languageChanged,
    );

    _checkSavedSession();
  }

  void _languageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    LanguageController.language.removeListener(
      _languageChanged,
    );

    super.dispose();
  }

  Future<void> _checkSavedSession() async {
    final session = await GameSession.load();

    if (!mounted) {
      return;
    }

    if (session == null) {
      setState(() {
        _checkingSession = false;
      });

      return;
    }

    try {
      final supabase =
          Supabase.instance.client;

      final result = await supabase.rpc(
        'get_game_state',
        params: {
          'p_game_id': session['gameId'],
        },
      );

      final data =
          Map<String, dynamic>.from(
        result as Map,
      );

      final playerData =
          Map<String, dynamic>.from(
        data['player'] as Map,
      );

      final inviteCode =
          data['invite_code'] as String? ?? '';

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GameScreen(
            gameId:
                session['gameId'] as String,
            playerId:
                playerData['id'] as String,
            playerNumber:
                playerData['player_number']
                    as int,
            startingPlayerName:
                playerData['name'] as String,
            inviteCode: inviteCode,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      final errorText =
          error.toString();

      if (errorText.contains(
        'You are not a player in this game.',
      )) {
        await GameSession.clear();

        if (!mounted) {
          return;
        }

        setState(() {
          _checkingSession = false;
          _autoRejoinFailed = false;
        });

        return;
      }

      setState(() {
        _checkingSession = false;
        _autoRejoinFailed = true;
      });
    }
  }

  Future<void> _retryAutoRejoin() async {
    if (_checkingSession) {
      return;
    }

    setState(() {
      _checkingSession = true;
      _autoRejoinFailed = false;
    });

    await _checkSavedSession();
  }

  Future<void> _forgetSavedGame() async {
    await GameSession.clear();

    if (!mounted) {
      return;
    }

    setState(() {
      _autoRejoinFailed = false;
    });
  }

  void _showSettings() {
    showAppSettingsDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark =
        theme.brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 12,
              child: IconButton(
                onPressed: _showSettings,
                tooltip:
                    AppStrings.t('settings'),
                icon: const Icon(
                  Icons.settings_outlined,
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 450,
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),

                      Container(
                        width: 90,
                        height: 90,
                        decoration:
                            BoxDecoration(
                          color: colors.primary
                              .withValues(
                            alpha: isDark
                                ? 0.18
                                : 0.12,
                          ),
                          shape:
                              BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 48,
                          color:
                              colors.primary,
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      Text(
                        AppStrings.t(
                          'app_name',
                        ),
                        style:
                            const TextStyle(
                          fontSize: 36,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        AppStrings.t(
                          'tagline',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: colors
                              .onSurfaceVariant,
                        ),
                      ),

                      if (_checkingSession) ...[
                        const SizedBox(
                          height: 42,
                        ),
                        CircularProgressIndicator(
                          color:
                              colors.primary,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppStrings.t(
                            'rejoining',
                          ),
                          style: TextStyle(
                            color: colors
                                .onSurfaceVariant,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(
                          height: 50,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          height: 58,
                          child:
                              ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CreateGameScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                            ),
                            label: Text(
                              AppStrings.t(
                                'create_game',
                              ),
                              style:
                                  const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  colors.primary,
                              foregroundColor:
                                  colors.onPrimary,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          height: 58,
                          child:
                              OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const JoinGameScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.group_add,
                            ),
                            label: Text(
                              AppStrings.t(
                                'join_game',
                              ),
                              style:
                                  const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            style:
                                OutlinedButton
                                    .styleFrom(
                              foregroundColor:
                                  colors.primary,
                              side: BorderSide(
                                color: colors
                                    .primary
                                    .withValues(
                                  alpha: 0.65,
                                ),
                                width: 2,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),
                              ),
                            ),
                          ),
                        ),

                        if (_autoRejoinFailed)
                          ...[
                            const SizedBox(
                              height: 28,
                            ),

                            Container(
                              width:
                                  double.infinity,
                              padding:
                                  const EdgeInsets
                                      .all(
                                18,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: colors
                                    .surface,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  18,
                                ),
                                border:
                                    Border.all(
                                  color: colors
                                      .primary
                                      .withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    AppStrings.t(
                                      'auto_rejoin_failed',
                                    ),
                                    textAlign:
                                        TextAlign
                                            .center,
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 14,
                                  ),

                                  SizedBox(
                                    width: double
                                        .infinity,
                                    height: 48,
                                    child:
                                        ElevatedButton(
                                      onPressed:
                                          _retryAutoRejoin,
                                      style:
                                          ElevatedButton
                                              .styleFrom(
                                        backgroundColor:
                                            colors
                                                .primary,
                                        foregroundColor:
                                            colors
                                                .onPrimary,
                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        AppStrings.t(
                                          'try_again',
                                        ),
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  TextButton(
                                    onPressed:
                                        _forgetSavedGame,
                                    child: Text(
                                      AppStrings.t(
                                        'forget_saved_game',
                                      ),
                                      style:
                                          TextStyle(
                                        color: colors
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                      ],

                      const SizedBox(
                        height: 40,
                      ),

                      Text(
                        AppStrings.t(
                          'made_for_two',
                        ),
                        style: TextStyle(
                          color: colors
                              .onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}