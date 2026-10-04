import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'game_screen.dart';
import '../services/game_session.dart';
import '../services/app_strings.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final TextEditingController _nameController = TextEditingController();

  bool _creatingGame = false;
  bool _loadingCategories = true;
  bool _includeCustomCards = false;

  String? _gameCode;
  String? _gameId;
  String? _playerId;

  List<String> _categories = [];
  final Set<String> _selectedCategories = {};

  int _dailyDareLimit = 1;

  static const Set<String> _sweetCategories = {
    'Romantic',
    'Adventurous',
  };

  static const Set<String> _spicyCategories = {
    'Naughty',
    'Extreme',
  };

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final supabase = Supabase.instance.client;

      final result = await supabase
          .from('dare_cards')
          .select('category')
          .order('category');

      final categories = result
          .map<String>((row) => row['category'] as String)
          .toSet()
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _categories = categories;

        // Sweet is the default game.
        // Spicy stays disabled until Naughty and/or Extreme is selected.
        _selectedCategories
          ..clear()
          ..addAll(
            categories.where(
              (category) => _sweetCategories.contains(category),
            ),
          );

        _loadingCategories = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingCategories = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.t('could_not_load_decks')}: $error'),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  void _toggleCategory(String category) {
    if (_gameCode != null) {
      return;
    }

    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  bool get _sweetEnabled =>
      _selectedCategories.any(_sweetCategories.contains);

  bool get _spicyEnabled =>
      _selectedCategories.any(_spicyCategories.contains);

  List<String> get _availableSweetCategories => _categories
      .where(_sweetCategories.contains)
      .toList();

  List<String> get _availableSpicyCategories => _categories
      .where(_spicyCategories.contains)
      .toList();

  String _categoryLabel(String category) {
    switch (category) {
      case 'Romantic':
        return AppStrings.t('romantic');
      case 'Adventurous':
        return AppStrings.t('adventurous');
      case 'Naughty':
        return AppStrings.t('naughty');
      case 'Extreme':
        return AppStrings.t('extreme');
      default:
        return category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _startGame() async {
    final playerName = _nameController.text.trim();

    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.t('please_enter_name')),
        ),
      );
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.t('please_select_pack')),
        ),
      );
      return;
    }

    setState(() {
      _creatingGame = true;
    });

    try {
      final supabase = Supabase.instance.client;

      final result = await supabase.rpc(
        'create_game',
        params: {
          'p_player_name': playerName,
          'p_categories': [
            ..._selectedCategories,
            if (_includeCustomCards) 'Custom',
          ],
          'p_daily_dare_limit': _dailyDareLimit,
        },
      );

      final data = Map<String, dynamic>.from(result as Map);

      final gameId = data['game_id'] as String;
      final playerId = data['player_id'] as String;
      final savedCode = data['invite_code'] as String;

      await GameSession.save(
        gameId: gameId,
        playerId: playerId,
        playerNumber: 1,
        playerName: playerName,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _gameCode = savedCode;
        _gameId = gameId;
        _playerId = playerId;
        _creatingGame = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _creatingGame = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppStrings.t('could_not_create')}: $error',
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  Future<void> _copyGameCode() async {
    if (_gameCode == null) {
      return;
    }

    await Clipboard.setData(
      ClipboardData(text: _gameCode!),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.t('invite_code_copied')),
      ),
    );
  }

  void _enterGame() {
    if (_gameId == null ||
        _playerId == null ||
        _gameCode == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          gameId: _gameId!,
          playerId: _playerId!,
          playerNumber: 1,
          startingPlayerName: _nameController.text.trim(),
          inviteCode: _gameCode!,
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String category,
    required Color accent,
    required bool isDark,
  }) {
    final colors = Theme.of(context).colorScheme;
    final selected = _selectedCategories.contains(category);

    return FilterChip(
      label: Text(_categoryLabel(category)),
      selected: selected,
      onSelected: (_) => _toggleCategory(category),
      selectedColor: accent.withValues(
        alpha: isDark ? 0.30 : 0.16,
      ),
      checkmarkColor: accent,
      side: BorderSide(
        color: selected ? accent : colors.outlineVariant,
      ),
    );
  }

  Widget _buildSweetSection({
    required bool isDark,
  }) {
    final colors = Theme.of(context).colorScheme;
    final categories = _availableSweetCategories;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.pink.withValues(
            alpha: _sweetEnabled ? 0.40 : 0.18,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.t('sweet_mode'),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.t('choose_main_packs'),
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          if (categories.isEmpty)
            Text(
              AppStrings.t('no_sweet_packs'),
              style: TextStyle(
                color: colors.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories
                  .map(
                    (category) => _buildCategoryChip(
                      category: category,
                      accent: Colors.pink,
                      isDark: isDark,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSpicySection({
    required bool isDark,
  }) {
    final colors = Theme.of(context).colorScheme;
    final categories = _availableSpicyCategories;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.deepOrange.withValues(
            alpha: _spicyEnabled ? 0.55 : 0.18,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.deepOrange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.t('spicy_mode'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _spicyEnabled
                      ? AppStrings.t('enabled')
                      : AppStrings.t('optional'),
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.t('enable_spicy_description'),
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          if (categories.isEmpty)
            Text(
              AppStrings.t('no_spicy_packs'),
              style: TextStyle(
                color: colors.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories
                  .map(
                    (category) => _buildCategoryChip(
                      category: category,
                      accent: Colors.deepOrange,
                      isDark: isDark,
                    ),
                  )
                  .toList(),
            ),
          if (_spicyEnabled) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.deepOrange,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.t('spicy_lane_enabled'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.t('create_game')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Icon(
                Icons.favorite,
                color: colors.primary,
                size: 52,
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.t('create_your_game'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppStrings.t('create_description'),
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
                enabled: _gameCode == null,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: AppStrings.t('your_name'),
                  hintText: AppStrings.t('enter_name'),
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_gameCode == null) ...[
                const SizedBox(height: 28),
                if (_loadingCategories)
                  Center(
                    child: CircularProgressIndicator(
                      color: colors.primary,
                    ),
                  )
                else if (_categories.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      AppStrings.t('no_deck_categories'),
                    ),
                  )
                else ...[
                  _buildSweetSection(
                    isDark: isDark,
                  ),
                  const SizedBox(height: 18),
                  _buildSpicySection(
                    isDark: isDark,
                  ),
                ],
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.outlineVariant,
                    ),
                  ),
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppStrings.t('include_custom_cards'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      AppStrings.t('include_custom_cards_description'),
                    ),
                    value: _includeCustomCards,
                    onChanged: (enabled) {
                      setState(() {
                        _includeCustomCards = enabled;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  AppStrings.t('dares_per_day'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.t('dares_per_day_description'),
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment<int>(
                      value: 1,
                      label: Text('1'),
                    ),
                    ButtonSegment<int>(
                      value: 2,
                      label: Text('2'),
                    ),
                    ButtonSegment<int>(
                      value: 3,
                      label: Text('3'),
                    ),
                  ],
                  selected: {_dailyDareLimit},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _dailyDareLimit = selection.first;
                    });
                  },
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(
                      alpha: isDark ? 0.12 : 0.08,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppStrings.t('create_info'),
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_gameCode != null) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colors.primary.withValues(
                        alpha: 0.22,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.25 : 0.06,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.t('your_game_code'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _gameCode!,
                            style: const TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _copyGameCode,
                            tooltip: AppStrings.t('copy_invite_code'),
                            icon: const Icon(Icons.copy),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppStrings.t('share_code'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _gameCode != null
                      ? _enterGame
                      : (_creatingGame || _loadingCategories
                          ? null
                          : _startGame),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _creatingGame
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onPrimary,
                          ),
                        )
                      : Text(
                          _gameCode != null
                              ? AppStrings.t('enter_game')
                              : AppStrings.t('create_game_button'),
                          style: const TextStyle(
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
