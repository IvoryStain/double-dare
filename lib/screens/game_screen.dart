import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dare_card.dart';

import '../services/app_strings.dart';

import '../services/game_session.dart';

import '../services/language_controller.dart';
import '../services/sound_service.dart';

import '../widgets/app_settings_dialog.dart';

import '../widgets/dare_card_widget.dart';

import '../widgets/player_hand.dart';

import 'home_screen.dart';

class GameScreen extends StatefulWidget {
  final String gameId;

  final String playerId;

  final int playerNumber;

  final String startingPlayerName;

  final String inviteCode;

  const GameScreen({
    super.key,

    required this.gameId,

    required this.playerId,

    required this.playerNumber,

    required this.startingPlayerName,

    required this.inviteCode,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _LaneState {
  final List<DareCard> hand;

  final DareCard? receivedDare;

  final int receivedDareCount;

  final DareCard? lastSentDare;

  final List<Map<String, dynamic>> playedCards;

  final int deckCount;

  final int sentToday;

  final int dailyLimit;

  const _LaneState({
    required this.hand,

    required this.receivedDare,

    required this.receivedDareCount,

    required this.lastSentDare,

    required this.playedCards,

    required this.deckCount,

    required this.sentToday,

    required this.dailyLimit,
  });

  static const empty = _LaneState(
    hand: [],

    receivedDare: null,

    receivedDareCount: 0,

    lastSentDare: null,

    playedCards: [],

    deckCount: 0,

    sentToday: 0,

    dailyLimit: 1,
  );
}

class _GameScreenState extends State<GameScreen> {
  bool _loading = true;

  bool _actionInProgress = false;

  bool _handOpen = false;

  bool _gameEnded = false;

  bool _drawingCard = false;

  bool _incomingRevealShowing = false;

  final Set<String> _revealedIncomingCardIds = <String>{};

  final PageController _modeController = PageController();

  String _inviteCode = '';

  String _playerName = '';

  int _modeIndex = 0;

  int? _selectedCardIndex;

  _LaneState _sweet = _LaneState.empty;

  _LaneState _spicy = _LaneState.empty;

  bool _sweetEnabled = false;

  bool _spicyEnabled = false;

  RealtimeChannel? _gameChannel;

  Timer? _reloadTimer;

  List<String> get _enabledModes {
    final modes = <String>[];

    if (_sweetEnabled) modes.add('sweet');

    if (_spicyEnabled) modes.add('spicy');

    return modes;
  }

  String get _currentModeKey {
    final modes = _enabledModes;

    if (modes.isEmpty) return 'sweet';

    final safeIndex = _modeIndex.clamp(0, modes.length - 1);

    return modes[safeIndex];
  }

  bool get _isSweet => _currentModeKey == 'sweet';

  String get _currentModeLabel =>
      _isSweet ? AppStrings.t('sweet') : AppStrings.t('spicy');

  _LaneState get _currentLane => _isSweet ? _sweet : _spicy;

  bool _laneHasContent(_LaneState lane) {
    return lane.hand.isNotEmpty ||
        lane.receivedDare != null ||
        lane.receivedDareCount > 0 ||
        lane.lastSentDare != null ||
        lane.playedCards.isNotEmpty ||
        lane.deckCount > 0;
  }

  @override
  void initState() {
    super.initState();

    LanguageController.language.addListener(_languageChanged);

    _inviteCode = widget.inviteCode;

    _playerName = widget.startingPlayerName;

    _initialiseGameScreen();
  }

  Future<void> _initialiseGameScreen() async {
    await _loadRevealedIncomingCardIds();

    if (!mounted) return;

    await _loadGame();

    if (!mounted) return;

    _subscribeToGame();
  }

  String get _incomingRevealStorageKey =>
      'revealed_received_${widget.gameId}_${widget.playerId}';

  Future<void> _loadRevealedIncomingCardIds() async {
    final prefs = await SharedPreferences.getInstance();

    final ids =
        prefs.getStringList(_incomingRevealStorageKey) ?? const <String>[];

    _revealedIncomingCardIds
      ..clear()
      ..addAll(ids);
  }

  Future<void> _saveRevealedIncomingCardIds() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _incomingRevealStorageKey,

      _revealedIncomingCardIds.toList(),
    );
  }

  void _languageChanged() {
    if (mounted) setState(() {});
  }

  void _subscribeToGame() {
    _gameChannel = Supabase.instance.client
        .channel('game-${widget.gameId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,

          schema: 'public',

          table: 'game_cards',

          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,

            column: 'game_id',

            value: widget.gameId,
          ),

          callback: (_) => _scheduleGameReload(),
        )
        .subscribe();
  }

  void _scheduleGameReload() {
    _reloadTimer?.cancel();

    _reloadTimer = Timer(const Duration(milliseconds: 250), () {
      if (mounted) _loadGame();
    });
  }

  DareCard? _cardFrom(dynamic value) {
    if (value == null) return null;

    final data = Map<String, dynamic>.from(value as Map);

    return DareCard(
      id: data['id'] as String,

      category: data['category'] as String? ?? '',

      title: data['title'] as String? ?? AppStrings.t('dare'),

      text: data['text'] as String? ?? '',
    );
  }

  List<DareCard> _handFrom(dynamic value) {
    final items = List<dynamic>.from(value as List? ?? const []);

    return items.map((item) => _cardFrom(item)!).toList();
  }

  List<Map<String, dynamic>> _playedFrom(dynamic value) {
    final items = List<dynamic>.from(value as List? ?? const []);

    return items.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  _LaneState _laneFrom(Map<String, dynamic> data) {
    return _LaneState(
      hand: _handFrom(data['hand']),

      receivedDare: _cardFrom(data['received_dare']),

      receivedDareCount: data['received_dare_count'] as int? ?? 0,

      lastSentDare: _cardFrom(data['last_sent_dare']),

      playedCards: _playedFrom(data['played_cards']),

      deckCount: data['deck_count'] as int? ?? 0,

      sentToday: data['sent_today'] as int? ?? 0,

      dailyLimit: data['daily_limit'] as int? ?? 1,
    );
  }

  Future<void> _loadGame() async {
    if (_gameEnded) return;

    try {
      final result = await Supabase.instance.client.rpc(
        'get_game_state',

        params: {'p_game_id': widget.gameId},
      );

      final data = Map<String, dynamic>.from(result as Map);

      final playerData = Map<String, dynamic>.from(data['player'] as Map);

      final sweetData = Map<String, dynamic>.from(data['sweet'] as Map);

      final spicyData = Map<String, dynamic>.from(data['spicy'] as Map);

      final loadedSweet = _laneFrom(sweetData);

      final loadedSpicy = _laneFrom(spicyData);

      final loadedSweetEnabled = _laneHasContent(loadedSweet);

      final loadedSpicyEnabled = _laneHasContent(loadedSpicy);

      final loadedPlayerName =
          playerData['name'] as String? ?? widget.startingPlayerName;

      if (!mounted) return;

      setState(() {
        _inviteCode = data['invite_code'] as String? ?? widget.inviteCode;

        _playerName = loadedPlayerName;

        _sweet = loadedSweet;

        _spicy = loadedSpicy;

        _sweetEnabled = loadedSweetEnabled;

        _spicyEnabled = loadedSpicyEnabled;

        final enabledCount =
            (loadedSweetEnabled ? 1 : 0) + (loadedSpicyEnabled ? 1 : 0);

        if (enabledCount <= 1 || _modeIndex >= enabledCount) {
          _modeIndex = 0;
        }

        _loading = false;
      });

      final allPlayed = <Map<String, dynamic>>[
        ...loadedSweet.playedCards.map((e) => {...e, '_mode': 'sweet'}),

        ...loadedSpicy.playedCards.map((e) => {...e, '_mode': 'spicy'}),
      ];

      allPlayed.sort((a, b) {
        final at =
            DateTime.tryParse(a['sent_at'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);

        final bt =
            DateTime.tryParse(b['sent_at'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);

        return bt.compareTo(at);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_maybeRevealIncomingCards(allPlayed, loadedPlayerName));
        }
      });
    } catch (error) {
      if (!mounted) return;

      if (error.toString().contains('You are not a player in this game.')) {
        await _handleGameEndedByPartner();

        return;
      }

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.t('could_not_load')}: $error'),

          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  Future<void> _maybeRevealIncomingCards(
    List<Map<String, dynamic>> playedCards,

    String currentPlayerName,
  ) async {
    if (_incomingRevealShowing || !mounted) return;

    final unseen = playedCards.where((item) {
      final id = item['id'] as String?;

      return id != null &&
          id.isNotEmpty &&
          item['recipient_name'] == currentPlayerName &&
          item['status'] == 'received' &&
          !_revealedIncomingCardIds.contains(id);
    }).toList();

    if (unseen.isEmpty) return;

    _incomingRevealShowing = true;

    try {
      for (final item in unseen.reversed) {
        if (!mounted) return;

        final mode = item['_mode'] as String? ?? 'sweet';

        final target = _enabledModes.indexOf(mode);

        if (target < 0) {
          continue;
        }

        if (_modeIndex != target) {
          setState(() {
            _modeIndex = target;

            _handOpen = false;

            _selectedCardIndex = null;
          });

          if (_modeController.hasClients) {
            await _modeController.animateToPage(
              target,

              duration: const Duration(milliseconds: 260),

              curve: Curves.easeOutCubic,
            );
          }
        }

        final cardId = item['id'] as String;

        final card = DareCard(
          id: cardId,

          category: item['category'] as String? ?? '',

          title: item['title'] as String? ?? AppStrings.t('dare'),

          text: item['text'] as String? ?? '',
        );

        await _showIncomingCardSlapReveal(card, mode);

        _revealedIncomingCardIds.add(cardId);

        await _saveRevealedIncomingCardIds();
      }
    } finally {
      _incomingRevealShowing = false;
    }
  }

  Future<void> _showIncomingCardSlapReveal(
    DareCard card,

    String modeLabel,
  ) async {
    if (!mounted) return;

    await showGeneralDialog<void>(
      context: context,

      barrierDismissible: false,

      barrierLabel: AppStrings.t('new_dare'),

      barrierColor: Colors.black.withValues(alpha: 0.68),

      transitionDuration: const Duration(milliseconds: 120),

      pageBuilder: (_, __, ___) =>
          _IncomingCardSlapReveal(card: card, modeLabel: modeLabel),
    );
  }

  Future<void> _handleGameEndedByPartner() async {
    if (_gameEnded) return;

    _gameEnded = true;

    await GameSession.clear();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),

      (_) => false,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(AppStrings.t('game_ended'))));
  }

  Future<void> _sendSelectedCard() async {
    final lane = _currentLane;

    if (_selectedCardIndex == null ||
        _actionInProgress ||
        _selectedCardIndex! >= lane.hand.length) {
      return;
    }

    if (lane.sentToday >= lane.dailyLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$_currentModeLabel ${AppStrings.t('daily_limit_reached')}.',
          ),
        ),
      );

      return;
    }

    setState(() => _actionInProgress = true);

    try {
      final selected = lane.hand[_selectedCardIndex!];

      await Supabase.instance.client.rpc(
        'send_dare',

        params: {'p_game_id': widget.gameId, 'p_card_id': selected.id},
      );

      await SoundService.playSend();

      if (!mounted) return;

      setState(() {
        _selectedCardIndex = null;

        _handOpen = false;
      });

      await _loadGame();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppStrings.t('dare_sent'))));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.t('could_not_send')}: $error'),

          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _drawCard() async {
    final lane = _currentLane;

    if (_actionInProgress ||
        _drawingCard ||
        lane.hand.length >= 3 ||
        lane.deckCount <= 0) {
      return;
    }

    final mode = _currentModeKey;

    setState(() => _drawingCard = true);

    try {
      final result = await Supabase.instance.client.rpc(
        'draw_card',

        params: {'p_game_id': widget.gameId, 'p_mode': mode},
      );

      final data = Map<String, dynamic>.from(result as Map);

      final card = DareCard(
        id: data['id'] as String,

        category: data['category'] as String? ?? '',

        title: data['title'] as String? ?? AppStrings.t('dare'),

        text: data['text'] as String? ?? '',
      );

      if (!mounted) return;

      await SoundService.playCardDraw();

      if (!mounted) return;

      await _showDrawnCardReveal(card, mode);

      if (!mounted) return;

      await _loadGame();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.t('could_not_draw')}: $error'),

          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _drawingCard = false);
    }
  }

  Future<void> _showDrawnCardReveal(DareCard card, String modeLabel) async {
    await showGeneralDialog<void>(
      context: context,

      barrierDismissible: false,

      barrierLabel: AppStrings.t('drawn_card'),

      barrierColor: Colors.black.withValues(alpha: 0.62),

      transitionDuration: const Duration(milliseconds: 250),

      pageBuilder: (_, __, ___) =>
          _DrawnCardReveal(card: card, modeLabel: modeLabel),
    );
  }

  Future<void> _resolveDare() async {
    final card = _currentLane.receivedDare;

    if (card == null || _actionInProgress) return;

    setState(() => _actionInProgress = true);

    try {
      await Supabase.instance.client.rpc(
        'resolve_dare',

        params: {'p_game_id': widget.gameId, 'p_card_id': card.id},
      );

      await SoundService.playResolve();

      if (!mounted) return;

      await _loadGame();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.t('could_not_resolve')}: $error'),

          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  void _selectCard(int index) {
    if (!_actionInProgress) setState(() => _selectedCardIndex = index);
  }

  void _closeHand() {
    setState(() {
      _handOpen = false;

      _selectedCardIndex = null;
    });
  }

  void _showLastSentDare() {
    final card = _currentLane.lastSentDare;

    if (card == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppStrings.t('no_sent_dare'))));

      return;
    }

    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title: Text('$_currentModeLabel - ${AppStrings.t('your_sent_dare')}'),

        content: DareCardWidget(card: card),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: Text(AppStrings.t('close')),
          ),
        ],
      ),
    );
  }

  void _showPlayedCards() {
    final cards = _currentLane.playedCards;

    if (cards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$_currentModeLabel: ${AppStrings.t('no_played_cards')}',
          ),
        ),
      );

      return;
    }

    int page = 0;

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final colors = Theme.of(context).colorScheme;

          return SafeArea(
            child: FractionallySizedBox(
              heightFactor: 0.88,

              child: Material(
                color: colors.surface,

                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),

                clipBehavior: Clip.antiAlias,

                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 10, 8),

                      child: Row(
                        children: [
                          const Icon(Icons.history),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              '$_currentModeLabel ${AppStrings.t('played_cards').toUpperCase()}',

                              style: const TextStyle(
                                fontSize: 14,

                                fontWeight: FontWeight.bold,

                                letterSpacing: 1.4,
                              ),
                            ),
                          ),

                          Text('${page + 1} / ${cards.length}'),

                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),

                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    Expanded(
                      child: PageView.builder(
                        itemCount: cards.length,

                        onPageChanged: (i) => setSheetState(() => page = i),

                        itemBuilder: (_, i) {
                          final item = cards[i];

                          final card = DareCard(
                            id: item['id'] as String? ?? '',

                            category: item['category'] as String? ?? '',

                            title:
                                item['title'] as String? ??
                                AppStrings.t('dare'),

                            text: item['text'] as String? ?? '',
                          );

                          return Padding(
                            padding: const EdgeInsets.all(24),

                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: DareCardWidget(card: card),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  '${item['sender_name'] ?? AppStrings.t('player')} → ${item['recipient_name'] ?? AppStrings.t('player')}',

                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,

                                    color: colors.onSurfaceVariant,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  item['status'] == 'resolved'
                                      ? 'Resolved'
                                      : 'Waiting for response',

                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showGameMenu() {
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      builder: (_) => SafeArea(
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainer,

          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),

          clipBehavior: Clip.antiAlias,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 10, 8),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppStrings.t('game_menu'),

                        style: const TextStyle(
                          fontSize: 13,

                          fontWeight: FontWeight.bold,

                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () => Navigator.pop(context),

                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              ListTile(
                leading: const Icon(Icons.tag, color: Colors.pink),

                title: Text(AppStrings.t('game_code')),

                subtitle: Text(_inviteCode),

                trailing: const Icon(Icons.chevron_right),

                onTap: () {
                  Navigator.pop(context);

                  _showGameCode();
                },
              ),

              ListTile(
                leading: Icon(
                  _isSweet
                      ? Icons.favorite_outline
                      : Icons.local_fire_department,

                  color: _isSweet ? Colors.pink : Colors.deepOrange,
                ),

                title: Text(
                  '$_currentModeLabel ${AppStrings.t('played_cards')}',
                ),

                subtitle: Text(
                  '${_currentLane.playedCards.length} ${AppStrings.t('played')}',
                ),

                trailing: const Icon(Icons.chevron_right),

                onTap: () {
                  Navigator.pop(context);

                  _showPlayedCards();
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,

                  color: Colors.pink,
                ),

                title: Text(AppStrings.t('settings')),

                trailing: const Icon(Icons.chevron_right),

                onTap: () {
                  Navigator.pop(context);

                  showAppSettingsDialog(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),

                title: Text(
                  AppStrings.t('leave_game'),

                  style: const TextStyle(color: Colors.redAccent),
                ),

                subtitle: Text(AppStrings.t('delete_game_description')),

                onTap: () {
                  Navigator.pop(context);

                  _showLeaveGameWarning();
                },
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showGameCode() {
    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title: Text(AppStrings.t('game_code')),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Text(
              _inviteCode,

              style: TextStyle(
                fontSize: 36,

                fontWeight: FontWeight.bold,

                letterSpacing: 8,

                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 12),

            Text(AppStrings.t('code_help'), textAlign: TextAlign.center),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: Text(AppStrings.t('close')),
          ),
        ],
      ),
    );
  }

  void _showLeaveGameWarning() {
    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title: Text(AppStrings.t('leave_game_question')),

        content: Text(AppStrings.t('leave_warning')),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: Text(AppStrings.t('cancel')),
          ),

          TextButton(
            onPressed: _actionInProgress
                ? null
                : () {
                    Navigator.pop(context);

                    _leaveAndDeleteGame();
                  },

            child: Text(
              AppStrings.t('leave_delete'),

              style: const TextStyle(
                color: Colors.redAccent,

                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _leaveAndDeleteGame() async {
    if (_actionInProgress) return;

    setState(() => _actionInProgress = true);

    try {
      await Supabase.instance.client.rpc(
        'leave_game',

        params: {'p_game_id': widget.gameId},
      );

      await GameSession.clear();

      if (!mounted) return;

      _gameEnded = true;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),

        (_) => false,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.t('could_not_delete')}: $error')),
      );
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  void _onModeChanged(int index) {
    setState(() {
      _modeIndex = index;

      _handOpen = false;

      _selectedCardIndex = null;
    });
  }

  @override
  void dispose() {
    LanguageController.language.removeListener(_languageChanged);

    _reloadTimer?.cancel();

    _modeController.dispose();

    if (_gameChannel != null) {
      Supabase.instance.client.removeChannel(_gameChannel!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.pink)),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),

                Expanded(
                  child: _enabledModes.length <= 1
                      ? _buildLanePage(_currentLane, _currentModeKey)
                      : PageView(
                          controller: _modeController,

                          onPageChanged: _onModeChanged,

                          children: _enabledModes.map((mode) {
                            return _buildLanePage(
                              mode == 'sweet' ? _sweet : _spicy,

                              mode,
                            );
                          }).toList(),
                        ),
                ),

                _buildBottomBar(),
              ],
            ),

            if (_handOpen) _buildHandDrawer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = Theme.of(context).colorScheme;

    final accent = _isSweet ? Colors.pink : Colors.deepOrange;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),

      child: Row(
        children: [
          SizedBox(
            width: 92,

            child: Row(
              children: [
                IconButton(
                  onPressed: _showGameMenu,

                  icon: const Icon(Icons.menu),
                ),

                Icon(Icons.favorite, color: accent, size: 21),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),

                  child: Row(
                    key: ValueKey(_currentModeLabel),

                    mainAxisAlignment: MainAxisAlignment.center,

                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        _isSweet
                            ? Icons.favorite_outline
                            : Icons.local_fire_department,

                        size: 18,

                        color: accent,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        _currentModeLabel,

                        style: TextStyle(
                          fontSize: 17,

                          fontWeight: FontWeight.w900,

                          letterSpacing: 1.8,

                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  _isSweet
                      ? AppStrings.t('romantic_adventurous')
                      : AppStrings.t('naughty_extreme'),

                  style: TextStyle(
                    fontSize: 10,

                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 92,

            child: Text(
              '${_currentLane.deckCount} ${AppStrings.t('cards_left')}',

              textAlign: TextAlign.right,

              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanePage(_LaneState lane, String mode) {
    return Column(
      children: [
        if (_enabledModes.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4),

            child: Text(
              mode == 'sweet'
                  ? 'Swipe left for Spicy →'
                  : '← Swipe right for Sweet',

              style: TextStyle(
                fontSize: 11,

                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

        Expanded(
          child: lane.receivedDare == null
              ? _buildEmptyState(mode)
              : _buildReceivedDareCard(
                  lane.receivedDare!,

                  lane.receivedDareCount,

                  mode,
                ),
        ),
      ],
    );
  }

  Widget _buildReceivedDareCard(DareCard card, int count, String mode) {
    final colors = Theme.of(context).colorScheme;

    final accent = mode == 'sweet' ? Colors.pink : Colors.deepOrange;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),

      child: Column(
        children: [
          Text(
            mode == 'sweet'
                ? AppStrings.t('your_sweet_dare')
                : AppStrings.t('your_spicy_dare'),

            style: TextStyle(
              fontSize: 12,

              fontWeight: FontWeight.bold,

              color: accent,

              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: 320,

            height: 390,

            child: Stack(
              alignment: Alignment.center,

              clipBehavior: Clip.none,

              children: [
                ...List.generate(count > 1 ? count - 1 : 0, (index) {
                  final layer = index + 1;

                  const rotations = [-0.055, 0.045, -0.032, 0.060, -0.042];

                  const xs = [-10.0, 12.0, -7.0, 9.0, -13.0];

                  const ys = [8.0, 12.0, 16.0, 20.0, 24.0];

                  final p = (layer - 1) % rotations.length;

                  return Transform.translate(
                    offset: Offset(xs[p], ys[p]),

                    child: Transform.rotate(
                      angle: rotations[p],

                      child: Container(
                        width: 260,

                        height: 330,

                        decoration: BoxDecoration(
                          color: colors.surface,

                          borderRadius: BorderRadius.circular(22),

                          border: Border.all(color: colors.outlineVariant),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),

                              blurRadius: 10,

                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).reversed,

                DareCardWidget(card: card),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _actionInProgress ? null : _resolveDare,

                  child: Text(AppStrings.t('refuse')),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: _actionInProgress ? null : _resolveDare,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,

                    foregroundColor: Colors.white,
                  ),

                  child: Text(AppStrings.t('accept')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String mode) {
    final isSweet = mode == 'sweet';

    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              isSweet
                  ? Icons.favorite_border
                  : Icons.local_fire_department_outlined,

              size: 58,

              color: isSweet
                  ? Colors.pink.withValues(alpha: 0.6)
                  : Colors.deepOrange.withValues(alpha: 0.65),
            ),

            const SizedBox(height: 20),

            Text(
              isSweet
                  ? AppStrings.t('no_sweet_dare')
                  : AppStrings.t('no_spicy_dare'),

              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              isSweet
                  ? AppStrings.t(
                      'Romantic and Adventurous dares will appear here.',
                    )
                  : AppStrings.t('Naughty and Extreme dares will appear here.'),

              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 15, color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final lane = _currentLane;

    final canDraw = lane.hand.length < 3 && lane.deckCount > 0;

    final limitReached = lane.sentToday >= lane.dailyLimit;

    final accent = _isSweet ? Colors.pink : Colors.deepOrange;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),

            blurRadius: 12,

            offset: const Offset(0, -3),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$_playerName · ${lane.sentToday}/${lane.dailyLimit} $_currentModeLabel ${AppStrings.t('sent_today')}',

                  style: TextStyle(
                    fontSize: 12,

                    fontWeight: FontWeight.w600,

                    color: limitReached
                        ? Colors.redAccent
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              if (lane.lastSentDare != null)
                TextButton(
                  onPressed: _showLastSentDare,

                  child: Text(AppStrings.t('last_sent')),
                ),
            ],
          ),

          if (canDraw) ...[
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: _actionInProgress || _drawingCard ? null : _drawCard,

                icon: _drawingCard
                    ? const SizedBox(
                        width: 20,

                        height: 20,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,

                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),

                label: Text(
                  _drawingCard
                      ? AppStrings.t('drawing')
                      : (_isSweet
                            ? AppStrings.t('draw_sweet_card')
                            : AppStrings.t('draw_spicy_card')),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 9),
          ],

          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: _actionInProgress || _drawingCard
                  ? null
                  : () {
                      setState(() {
                        _handOpen = true;

                        _selectedCardIndex = null;
                      });
                    },

              icon: const Icon(Icons.style),

              label: Text(
                '${_isSweet ? AppStrings.t('sweet_hand') : AppStrings.t('spicy_hand')} (${lane.hand.length}/3)',
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: accent,

                foregroundColor: Colors.white,

                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandDrawer() {
    final lane = _currentLane;

    final accent = _isSweet ? Colors.pink : Colors.deepOrange;

    final limitReached = lane.sentToday >= lane.dailyLimit;

    return Positioned(
      left: 0,

      right: 0,

      bottom: 0,

      height: MediaQuery.of(context).size.height * 0.60,

      child: Material(
        elevation: 20,

        color: Colors.transparent,

        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,

            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 10, 0),

                child: Row(
                  children: [
                    Icon(
                      _isSweet
                          ? Icons.favorite_outline
                          : Icons.local_fire_department,

                      color: accent,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        _isSweet
                            ? AppStrings.t('sweet_hand')
                            : AppStrings.t('spicy_hand'),

                        style: const TextStyle(
                          fontSize: 14,

                          fontWeight: FontWeight.bold,

                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    Text('${lane.hand.length}/3'),

                    IconButton(
                      onPressed: _closeHand,

                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: PlayerHand(
                  cards: lane.hand,

                  selectedIndex: _selectedCardIndex,

                  onCardSelected: _selectCard,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),

                child: Column(
                  children: [
                    if (limitReached)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),

                        child: Text(
                          '$_currentModeLabel ${AppStrings.t('daily_limit_reached')}',

                          style: const TextStyle(
                            color: Colors.redAccent,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed:
                            _selectedCardIndex == null ||
                                _actionInProgress ||
                                limitReached
                            ? null
                            : _sendSelectedCard,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,

                          foregroundColor: Colors.white,

                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),

                        child: _actionInProgress
                            ? const SizedBox(
                                width: 20,

                                height: 20,

                                child: CircularProgressIndicator(
                                  strokeWidth: 2,

                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isSweet
                                    ? AppStrings.t('send_sweet_dare')
                                    : AppStrings.t('send_spicy_dare'),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncomingCardSlapReveal extends StatefulWidget {
  final DareCard card;

  final String modeLabel;

  const _IncomingCardSlapReveal({required this.card, required this.modeLabel});

  @override
  State<_IncomingCardSlapReveal> createState() =>
      _IncomingCardSlapRevealState();
}

class _IncomingCardSlapRevealState extends State<_IncomingCardSlapReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _flight;

  late final Animation<double> _scale;

  late final Animation<double> _details;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1050),
    );

    _flight = CurvedAnimation(
      parent: _controller,

      curve: const Interval(0, 0.62, curve: Curves.easeOutCubic),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.14, end: 0.94), weight: 58),

      TweenSequenceItem(tween: Tween(begin: 0.94, end: 1.035), weight: 24),

      TweenSequenceItem(tween: Tween(begin: 1.035, end: 1.0), weight: 18),
    ]).animate(_controller);

    _details = CurvedAnimation(
      parent: _controller,

      curve: const Interval(0.62, 1, curve: Curves.easeOut),
    );

    _controller.forward();

    Future<void>.delayed(const Duration(milliseconds: 520), () {
      if (!mounted) return;

      HapticFeedback.mediumImpact();
      unawaited(SoundService.playIncomingSlap());
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isSweet = widget.modeLabel == 'sweet';

    final accent = isSweet ? Colors.pink : Colors.deepOrange;

    return Material(
      color: Colors.transparent,

      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,

          builder: (_, __) {
            final f = _flight.value;

            final impact = math.sin(
              (((_controller.value - 0.48) / 0.30).clamp(0.0, 1.0)) * math.pi,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(
                        size.width * 0.78 * (1 - f),

                        -size.height * 0.52 * (1 - f),
                      ),

                      child: Transform.rotate(
                        angle: -0.28 * (1 - f),

                        child: Transform.scale(
                          scale: _scale.value,

                          child: Container(
                            padding: const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.28 + 0.12 * impact,
                                  ),

                                  blurRadius: 26 + 20 * impact,

                                  spreadRadius: 2 + 4 * impact,

                                  offset: const Offset(0, 12),
                                ),

                                BoxShadow(
                                  color: accent.withValues(
                                    alpha: 0.30 * impact,
                                  ),

                                  blurRadius: 44 * impact,

                                  spreadRadius: 10 * impact,
                                ),
                              ],
                            ),

                            child: DareCardWidget(card: widget.card),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 24,

                  right: 24,

                  top: 22,

                  child: FadeTransition(
                    opacity: _details,

                    child: Text(
                      isSweet
                          ? AppStrings.t('new_sweet_dare')
                          : AppStrings.t('new_spicy_dare'),

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: accent,

                        fontSize: 13,

                        fontWeight: FontWeight.bold,

                        letterSpacing: 2.2,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 24,

                  right: 24,

                  bottom: 26,

                  child: FadeTransition(
                    opacity: _details,

                    child: ElevatedButton(
                      onPressed: _controller.isCompleted
                          ? () => Navigator.pop(context)
                          : null,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,

                        foregroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),

                      child: Text(AppStrings.t('back_to_table')),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DrawnCardReveal extends StatefulWidget {
  final DareCard card;

  final String modeLabel;

  const _DrawnCardReveal({required this.card, required this.modeLabel});

  @override
  State<_DrawnCardReveal> createState() => _DrawnCardRevealState();
}

class _DrawnCardRevealState extends State<_DrawnCardReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _drop;

  late final Animation<double> _fold;

  late final Animation<double> _scale;

  late final Animation<double> _glow;

  late final Animation<double> _details;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(milliseconds: 1500),
    );

    _drop = CurvedAnimation(
      parent: _controller,

      curve: const Interval(0, 0.48, curve: Curves.easeOutBack),
    );

    _fold = CurvedAnimation(
      parent: _controller,

      curve: const Interval(0.28, 0.76, curve: Curves.easeOutCubic),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.72, end: 1.06), weight: 78),

      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 22),
    ]).animate(_controller);

    _glow = CurvedAnimation(
      parent: _controller,

      curve: const Interval(0.68, 1, curve: Curves.easeOut),
    );

    _details = CurvedAnimation(
      parent: _controller,

      curve: const Interval(0.78, 1, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final isSweet = widget.modeLabel == 'sweet';

    final accent = isSweet ? Colors.pink : Colors.deepOrange;

    return Material(
      color: Colors.transparent,

      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,

          builder: (_, __) {
            final dropY = -screenHeight * 0.62 * (1 - _drop.value);

            final foldAngle = -math.pi / 2 * (1 - _fold.value);

            final glow = math.sin(_glow.value * math.pi);

            return Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, dropY),

                      child: Transform.scale(
                        scale: _scale.value,

                        child: Transform(
                          alignment: Alignment.topCenter,

                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(foldAngle),

                          child: Container(
                            padding: const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),

                              boxShadow: [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.38 * glow),

                                  blurRadius: 42 * glow,

                                  spreadRadius: 10 * glow,
                                ),

                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.24),

                                  blurRadius: 24,

                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),

                            child: DareCardWidget(card: widget.card),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 24,

                  right: 24,

                  bottom: 26,

                  child: FadeTransition(
                    opacity: _details,

                    child: Column(
                      children: [
                        Text(
                          isSweet
                              ? AppStrings.t('new_sweet_card')
                              : AppStrings.t('new_spicy_card'),

                          style: TextStyle(
                            color: accent,

                            fontSize: 13,

                            fontWeight: FontWeight.bold,

                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            onPressed: _controller.isCompleted
                                ? () => Navigator.pop(context)
                                : null,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,

                              foregroundColor: Colors.white,

                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),

                            child: Text(AppStrings.t('add_to_hand')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
