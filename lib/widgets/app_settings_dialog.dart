import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/app_strings.dart';

import '../services/language_controller.dart';
import '../services/sound_service.dart';

import '../services/theme_controller.dart';

Future<void> showAppSettingsDialog(BuildContext context) async {
  await showDialog(
    context: context,

    builder: (dialogContext) {
      return ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeController.themeMode,

        builder: (context, themeMode, child) {
          return ValueListenableBuilder<String>(
            valueListenable: LanguageController.language,

            builder: (context, languageCode, child) {
              final isDarkMode = themeMode == ThemeMode.dark;

              return AlertDialog(
                title: Text(AppStrings.t('settings')),

                content: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,

                      title: Text(AppStrings.t('dark_mode')),

                      subtitle: Text(AppStrings.t('dark_mode_description')),

                      value: isDarkMode,

                      onChanged: (enabled) async {
                        await ThemeController.setDarkMode(enabled);
                      },
                    ),

                    const Divider(),

                    ValueListenableBuilder<bool>(
                      valueListenable: SoundService.enabledNotifier,
                      builder: (context, soundEnabled, child) {
                        return SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          secondary: const Icon(Icons.volume_up_outlined),
                          title: Text(AppStrings.t('sound_effects')),
                          subtitle: Text(
                            AppStrings.t('sound_effects_description'),
                          ),
                          value: soundEnabled,
                          onChanged: (enabled) async {
                            await SoundService.setEnabled(enabled);
                          },
                        );
                      },
                    ),

                    const Divider(),

                    ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: const Icon(Icons.language),

                      title: Text(AppStrings.t('language')),

                      subtitle: Text(LanguageController.currentName),

                      trailing: const Icon(Icons.chevron_right),

                      onTap: () {
                        _showLanguagePicker(dialogContext);
                      },
                    ),

                    const Divider(),

                    ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: const Icon(Icons.style_outlined),

                      title: Text(AppStrings.t('custom_cards')),

                      subtitle: Text(AppStrings.t('create_your_own_dares')),

                      trailing: const Icon(Icons.chevron_right),

                      onTap: () {
                        _showCustomCards(dialogContext);
                      },
                    ),
                  ],
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },

                    child: Text(AppStrings.t('close')),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

Future<void> _showLanguagePicker(BuildContext context) async {
  await showDialog(
    context: context,

    builder: (pickerContext) {
      return ValueListenableBuilder<String>(
        valueListenable: LanguageController.language,

        builder: (context, selectedLanguage, child) {
          return AlertDialog(
            title: Text(AppStrings.t('language')),

            content: SizedBox(
              width: 320,

              child: ListView(
                shrinkWrap: true,

                children: LanguageController.languages.entries.map((entry) {
                  final code = entry.key;

                  final name = entry.value;

                  final selected = selectedLanguage == code;

                  return ListTile(
                    leading: selected
                        ? Icon(
                            Icons.check_circle,

                            color: Theme.of(context).colorScheme.primary,
                          )
                        : const Icon(Icons.circle_outlined),

                    title: Text(name),

                    onTap: () async {
                      await LanguageController.setLanguage(code);

                      if (pickerContext.mounted) {
                        Navigator.pop(pickerContext);
                      }
                    },
                  );
                }).toList(),
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(pickerContext);
                },

                child: Text(AppStrings.t('close')),
              ),
            ],
          );
        },
      );
    },
  );
}

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

Future<void> _showCustomCards(BuildContext context) async {
  await showDialog(
    context: context,

    builder: (customContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<List<Map<String, dynamic>>> loadCards() async {
            final supabase = Supabase.instance.client;

            final user = supabase.auth.currentUser;

            if (user == null) {
              return [];
            }

            final result = await supabase
                .from('custom_dare_cards')
                .select('id, title, text, category, created_at')
                .eq('auth_user_id', user.id)
                .order('created_at', ascending: true);

            return List<Map<String, dynamic>>.from(result);
          }

          return AlertDialog(
            title: Text(AppStrings.t('custom_cards')),

            content: SizedBox(
              width: 420,

              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: loadCards(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 140,

                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return SizedBox(
                      height: 140,

                      child: Center(
                        child: Text(
                          '${AppStrings.t('could_not_load_custom_cards')}:\n${snapshot.error}',

                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final cards = snapshot.data ?? [];

                  if (cards.isEmpty) {
                    return const SizedBox(
                      height: 140,

                      child: Center(
                        child: Text(
                          'You have not created any custom cards yet.',

                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),

                    child: ListView.separated(
                      shrinkWrap: true,

                      itemCount: cards.length,

                      separatorBuilder: (context, index) => const Divider(),

                      itemBuilder: (context, index) {
                        final card = cards[index];

                        return ListTile(
                          contentPadding: EdgeInsets.zero,

                          leading: const Icon(Icons.style),

                          title: Text(
                            card['title'] as String? ??
                                AppStrings.t('custom_dare'),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const SizedBox(height: 4),

                              Text(
                                _categoryLabel(
                                  card['category'] as String? ?? '',
                                ),

                                style: TextStyle(
                                  fontSize: 12,

                                  fontWeight: FontWeight.w600,

                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                card['text'] as String? ?? '',

                                maxLines: 2,

                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),

                            onPressed: () async {
                              final supabase = Supabase.instance.client;

                              await supabase
                                  .from('custom_dare_cards')
                                  .delete()
                                  .eq('id', card['id']);

                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            actions: [
              TextButton.icon(
                onPressed: () async {
                  final added = await _showAddCustomCard(customContext);

                  if (added) {
                    setState(() {});
                  }
                },

                icon: const Icon(Icons.add),

                label: Text(AppStrings.t('add_card')),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(customContext);
                },

                child: Text(AppStrings.t('close')),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool> _showAddCustomCard(BuildContext context) async {
  final titleController = TextEditingController();

  final textController = TextEditingController();

  const categories = ['Romantic', 'Adventurous', 'Naughty', 'Extreme'];

  String selectedCategory = 'Romantic';

  final result = await showDialog<bool>(
    context: context,

    builder: (addContext) {
      bool saving = false;

      String? errorText;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(AppStrings.t('add_custom_card')),

            content: SizedBox(
              width: 380,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: titleController,

                    textCapitalization: TextCapitalization.words,

                    decoration: InputDecoration(
                      labelText: AppStrings.t('name'),
                      hintText: AppStrings.t('example_breakfast_in_bed'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: textController,

                    maxLines: 5,

                    textCapitalization: TextCapitalization.sentences,

                    decoration: InputDecoration(
                      labelText: AppStrings.t('dare_text'),
                      hintText: AppStrings.t('enter_partner_dare'),
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,

                    decoration: InputDecoration(
                      labelText: AppStrings.t('category'),
                      border: const OutlineInputBorder(),
                    ),

                    items: categories
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category,

                            child: Text(_categoryLabel(category)),
                          ),
                        )
                        .toList(),

                    onChanged: saving
                        ? null
                        : (value) {
                            if (value == null) {
                              return;
                            }

                            setState(() {
                              selectedCategory = value;
                            });
                          },
                  ),

                  if (errorText != null) ...[
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        errorText!,

                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            actions: [
              TextButton(
                onPressed: saving
                    ? null
                    : () {
                        Navigator.pop(addContext, false);
                      },

                child: Text(AppStrings.t('cancel')),
              ),

              ElevatedButton(
                onPressed: saving
                    ? null
                    : () async {
                        final title = titleController.text.trim();

                        final text = textController.text.trim();

                        if (title.isEmpty || text.isEmpty) {
                          setState(() {
                            errorText = AppStrings.t(
                              'please_enter_name_and_dare',
                            );
                          });

                          return;
                        }

                        setState(() {
                          saving = true;

                          errorText = null;
                        });

                        try {
                          final supabase = Supabase.instance.client;

                          final user = supabase.auth.currentUser;

                          if (user == null) {
                            throw Exception(AppStrings.t('must_be_signed_in'));
                          }

                          await supabase.from('custom_dare_cards').insert({
                            'auth_user_id': user.id,

                            'title': title,

                            'text': text,

                            'category': selectedCategory,
                          });

                          if (addContext.mounted) {
                            Navigator.pop(addContext, true);
                          }
                        } catch (error) {
                          if (!addContext.mounted) {
                            return;
                          }

                          setState(() {
                            saving = false;

                            errorText =
                                '${AppStrings.t('could_not_save_card')}: $error';
                          });
                        }
                      },

                child: saving
                    ? const SizedBox(
                        width: 18,

                        height: 18,

                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(AppStrings.t('save')),
              ),
            ],
          );
        },
      );
    },
  );

  titleController.dispose();

  textController.dispose();

  return result ?? false;
}
