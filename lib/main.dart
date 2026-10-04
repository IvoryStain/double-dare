import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'services/theme_controller.dart';
import 'services/language_controller.dart';
import 'services/notification_service.dart';
import 'services/sound_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://mopeoklytxxlrpwjskgg.supabase.co',
    publishableKey: 'sb_publishable_FemmItUrbFWr7WGAjQecwQ_OTwa_cAn',
  );

  final supabase = Supabase.instance.client;

  try {
    final existingSession =
        supabase.auth.currentSession;

    if (existingSession == null) {
      final response =
          await supabase.auth.signInAnonymously();

      debugPrint(
        'ANONYMOUS AUTH SUCCESS: '
        '${response.user?.id}',
      );
    } else if (existingSession.isExpired) {
      debugPrint(
        'AUTH SESSION EXPIRED - REFRESHING',
      );

      final response =
          await supabase.auth.refreshSession();

      debugPrint(
        'AUTH SESSION REFRESHED: '
        '${response.user?.id}',
      );
    } else {
      debugPrint(
        'EXISTING AUTH SESSION: '
        '${supabase.auth.currentUser?.id}',
      );
    }
  } catch (error, stackTrace) {
    debugPrint(
      'AUTH STARTUP ERROR: $error',
    );

    debugPrint('$stackTrace');
  }

await NotificationService.initialize();
await ThemeController.load();
await LanguageController.load();
await SoundService.initialise();

runApp(const CouplesDaresApp());
  runApp(const CouplesDaresApp());
}

class CouplesDaresApp extends StatelessWidget {
  const CouplesDaresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable:
          ThemeController.themeMode,
      builder: (
        context,
        themeMode,
        child,
      ) {
        return ValueListenableBuilder<String>(
          valueListenable:
              LanguageController.language,
          builder: (
            context,
            languageCode,
            child,
          ) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Double Dare',

              themeMode: themeMode,

              theme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Arial',

                scaffoldBackgroundColor:
                    const Color(0xFFFFF7FA),

                colorScheme:
                    ColorScheme.fromSeed(
                  seedColor:
                      Colors.pink.shade500,
                  brightness:
                      Brightness.light,
                ).copyWith(
                  primary:
                      Colors.pink.shade500,
                  secondary:
                      Colors.pink.shade500,
                  surfaceContainer:
                      Colors.pink.shade100,
                ),

                dialogTheme:
                    DialogThemeData(
                  backgroundColor:
                      Colors.pink.shade100,
                ),

                bottomSheetTheme:
                    BottomSheetThemeData(
                  backgroundColor:
                      Colors.pink.shade100,
                ),

                popupMenuTheme:
                    PopupMenuThemeData(
                  color:
                      Colors.pink.shade100,
                ),
              ),

              darkTheme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Arial',

                brightness:
                    Brightness.dark,

                scaffoldBackgroundColor:
                    const Color(
                  0xFF171216,
                ),

                colorScheme:
                    ColorScheme.fromSeed(
                  seedColor: Colors.pink,
                  brightness:
                      Brightness.dark,
                ),

                cardColor:
                    const Color(
                  0xFF241E23,
                ),

                dialogTheme:
                    const DialogThemeData(
                  backgroundColor:
                      Color(
                    0xFF241E23,
                  ),
                ),

                bottomSheetTheme:
                    const BottomSheetThemeData(
                  backgroundColor:
                      Color(
                    0xFF241E23,
                  ),
                ),

                inputDecorationTheme:
                    const InputDecorationTheme(
                  filled: true,
                  fillColor:
                      Color(
                    0xFF241E23,
                  ),
                ),
              ),

              home:
                  const HomeScreen(),
            );
          },
        );
      },
    );
  }
}