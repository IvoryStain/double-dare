import 'language_controller.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'sound_effects': 'Sound effects',
      'sound_effects_description': 'Play sounds for cards and game actions.',
      'custom_cards': 'Custom cards',
      'create_your_own_dares': 'Create your own dares',
      'custom_dare': 'Custom dare',
      'could_not_load_custom_cards': 'Could not load custom cards',
      'no_custom_cards_yet': 'You have not created any custom cards yet.',
      'add_card': 'ADD CARD',
      'add_custom_card': 'Add custom card',
      'name': 'Name',
      'example_breakfast_in_bed': 'e.g. Breakfast in bed',
      'dare_text': 'Dare text',
      'enter_partner_dare': 'Enter what you want your partner to do',
      'category': 'Category',
      'please_enter_name_and_dare': 'Please enter a name and dare text.',
      'must_be_signed_in': 'You must be signed in.',
      'could_not_save_card': 'Could not save card',
      'save': 'SAVE',

      'dare': 'Dare',

      'new_dare': 'New dare',

      'drawn_card': 'Drawn card',

      'could_not_draw': 'Could not draw card',

      'played': 'played',

      'new_sweet_card': 'NEW SWEET CARD',

      'new_spicy_card': 'NEW SPICY CARD',

      'add_to_hand': 'ADD TO HAND',

      'romantic': 'Romantic',

      'adventurous': 'Adventurous',

      'naughty': 'Naughty',

      'extreme': 'Extreme',

      'copy_invite_code': 'Copy invite code',

      'could_not_load_decks': 'Could not load packs',

      'app_name': 'Double Dare',

      'tagline': 'A little game for two.',

      'create_game': 'Create Game',

      'join_game': 'Join Game',

      'settings': 'Settings',

      'dark_mode': 'Dark mode',

      'dark_mode_description': 'Use the darker colour theme.',

      'language': 'Language',

      'close': 'CLOSE',

      'your_name': 'Your name',

      'enter_name': 'Enter your name',

      'game_code': 'Game code',

      'create_your_game': 'Create your game',

      'create_description':
          'Choose your name and create a game for your partner.',

      'create_info': 'Create a game to receive a 5-character code that you can share with your partner.',

      'join_your_partner': 'Join your partner',

      'join_description': 'Enter your name and the 5-character game code your partner shared with you.',

      'join_info':
          'The game code is created when your partner starts a new game.',

      'your_game_code': 'YOUR GAME CODE',

      'share_code': 'Share this code with your partner.',

      'enter_game': 'ENTER GAME',

      'join_game_button': 'JOIN GAME',

      'create_game_button': 'CREATE GAME',

      'game_menu': 'GAME MENU',

      'leave_game': 'Leave game',

      'delete_game_description': 'Permanently delete this game',

      'leave_game_question': 'Leave game?',

      'leave_warning': 'Leaving the game will permanently delete this game and all of its cards and game data. This cannot be undone.',

      'cancel': 'CANCEL',

      'leave_delete': 'LEAVE & DELETE',

      'your_hand': 'YOUR HAND',

      'send_dare': 'SEND DARE',

      'your_dare': 'YOUR DARE',

      'accept': 'ACCEPT',

      'refuse': 'REFUSE',

      'no_dare': 'No dare waiting',

      'no_dare_description': 'Send your partner a dare from your hand.',

      'view_your_dare': 'VIEW YOUR DARE',

      'your_sent_dare': 'Your sent dare',

      'rejoining': 'Rejoining your game...',

      'made_for_two': 'Made for two people',

      'try_again': 'TRY AGAIN',

      'forget_saved_game': 'Forget this saved game',

      'auto_rejoin_failed': 'Could not automatically rejoin your saved game.',

      'game_ended': 'This game has been ended.',

      'game_deleted': 'Game deleted.',

      'no_sent_dare': 'You have not sent a dare yet.',

      'one_dare_per_day':
          'Your daily dare limit applies separately to each enabled mode.',

      'dare_sent': 'Dare sent! ❤️',

      'could_not_find_player': 'Could not find your player.',

      'code_help': 'Give this code to your partner so they can join the game.',

      'close_hand': 'Close hand',

      'game_menu_tooltip': 'Game menu',

      'please_enter_name': 'Please enter your name.',

      'please_enter_code': 'Please enter the 5-character game code.',

      'could_not_create': 'Could not create game',

      'could_not_join': 'Could not join game',

      'could_not_load': 'Could not load game',

      'could_not_send': 'Could not send dare',

      'could_not_resolve': 'Could not resolve dare',

      'could_not_delete': 'Could not delete game',

      'cards_left': 'left',

      'sweet_mode': 'SWEET MODE',

      'spicy_mode': 'SPICY MODE',

      'optional': 'OPTIONAL',

      'enabled': 'ENABLED',

      'romantic_adventurous': 'Romantic + Adventurous',

      'naughty_extreme': 'Naughty + Extreme',

      'choose_main_packs': 'Choose the main packs for your game.',

      'enable_spicy_description':
          'Enable Spicy Mode by selecting one or more extra packs.',

      'spicy_lane_enabled':
          'Spicy Mode will be available as a separate game lane.',

      'include_custom_cards': 'Include custom cards',

      'include_custom_cards_description':
          'Includes matching custom cards created by both players.',

      'dares_per_day': 'Dares per day',

      'dares_per_day_description': 'Choose how many dares each player can send per day in each enabled mode.',

      'please_select_pack': 'Please select at least one pack.',

      'no_deck_categories': 'No deck categories were found.',

      'no_sweet_packs': 'No Sweet packs were found.',

      'no_spicy_packs': 'No Spicy packs were found.',

      'invite_code_copied': 'Invite code copied',

      'sweet': 'SWEET',

      'spicy': 'SPICY',

      'sweet_hand': 'SWEET HAND',

      'spicy_hand': 'SPICY HAND',

      'your_sweet_dare': 'YOUR SWEET DARE',

      'your_spicy_dare': 'YOUR SPICY DARE',

      'no_sweet_dare': 'No Sweet dare yet',

      'no_spicy_dare': 'No Spicy dare yet',

      'sweet_dare_description':
          'Romantic and Adventurous dares will appear here.',

      'spicy_dare_description': 'Naughty and Extreme dares will appear here.',

      'swipe_for_spicy': 'Swipe left for Spicy →',

      'swipe_for_sweet': '← Swipe right for Sweet',

      'draw_sweet_card': 'DRAW SWEET CARD',

      'draw_spicy_card': 'DRAW SPICY CARD',

      'drawing': 'DRAWING...',

      'last_sent': 'Last sent',

      'played_cards': 'played cards',

      'no_played_cards': 'No cards have been played yet.',

      'sent_today': 'sent today',

      'daily_limit_reached': 'daily limit reached',

      'send_sweet_dare': 'SEND SWEET DARE',

      'send_spicy_dare': 'SEND SPICY DARE',

      'new_sweet_dare': 'NEW SWEET DARE',

      'new_spicy_dare': 'NEW SPICY DARE',

      'back_to_table': 'BACK TO TABLE',

      'waiting_for_response': 'Waiting for response',

      'resolved': 'Resolved',

      'player': 'Player',
    },

    'es': {
      'sound_effects': 'Efectos de sonido',
      'sound_effects_description':
          'Reproduce sonidos para las cartas y las acciones del juego.',
      'custom_cards': 'Cartas personalizadas',
      'create_your_own_dares': 'Crea tus propios retos',
      'custom_dare': 'Reto personalizado',
      'could_not_load_custom_cards':
          'No se pudieron cargar las cartas personalizadas',
      'no_custom_cards_yet': 'Aún no has creado ninguna carta personalizada.',
      'add_card': 'AÑADIR CARTA',
      'add_custom_card': 'Añadir carta personalizada',
      'name': 'Nombre',
      'example_breakfast_in_bed': 'p. ej. Desayuno en la cama',
      'dare_text': 'Texto del reto',
      'enter_partner_dare': 'Escribe lo que quieres que haga tu pareja',
      'category': 'Categoría',
      'please_enter_name_and_dare': 'Introduce un nombre y el texto del reto.',
      'must_be_signed_in': 'Debes iniciar sesión.',
      'could_not_save_card': 'No se pudo guardar la carta',
      'save': 'GUARDAR',

      'dare': 'Reto',

      'new_dare': 'Nuevo reto',

      'drawn_card': 'Carta robada',

      'could_not_draw': 'No se pudo robar la carta',

      'played': 'jugadas',

      'new_sweet_card': 'NUEVA CARTA DULCE',

      'new_spicy_card': 'NUEVA CARTA PICANTE',

      'add_to_hand': 'AÑADIR A LA MANO',

      'romantic': 'Romántico',

      'adventurous': 'Aventurero',

      'naughty': 'Atrevido',

      'extreme': 'Extremo',

      'copy_invite_code': 'Copiar código de invitación',

      'could_not_load_decks': 'No se pudieron cargar los packs',

      'app_name': 'Double Dare',

      'tagline': 'Un pequeño juego para dos.',

      'create_game': 'Crear partida',

      'join_game': 'Unirse a partida',

      'settings': 'Ajustes',

      'dark_mode': 'Modo oscuro',

      'dark_mode_description': 'Usar el tema de colores oscuro.',

      'language': 'Idioma',

      'close': 'CERRAR',

      'your_name': 'Tu nombre',

      'enter_name': 'Introduce tu nombre',

      'game_code': 'Código de partida',

      'create_your_game': 'Crea tu partida',

      'create_description':
          'Elige tu nombre y crea una partida para tu pareja.',

      'create_info': 'Crea una partida para recibir un código de 5 caracteres que puedes compartir con tu pareja.',

      'join_your_partner': 'Únete a tu pareja',

      'join_description': 'Introduce tu nombre y el código de 5 caracteres que compartió tu pareja.',

      'join_info':
          'El código se crea cuando tu pareja inicia una nueva partida.',

      'your_game_code': 'TU CÓDIGO DE PARTIDA',

      'share_code': 'Comparte este código con tu pareja.',

      'enter_game': 'ENTRAR',

      'join_game_button': 'UNIRSE',

      'create_game_button': 'CREAR PARTIDA',

      'game_menu': 'MENÚ DE PARTIDA',

      'leave_game': 'Salir de la partida',

      'delete_game_description': 'Eliminar permanentemente esta partida',

      'leave_game_question': '¿Salir de la partida?',

      'leave_warning': 'Salir eliminará permanentemente esta partida, sus cartas y todos sus datos. No se puede deshacer.',

      'cancel': 'CANCELAR',

      'leave_delete': 'SALIR Y ELIMINAR',

      'your_hand': 'TU MANO',

      'send_dare': 'ENVIAR RETO',

      'your_dare': 'TU RETO',

      'accept': 'ACEPTAR',

      'refuse': 'RECHAZAR',

      'no_dare': 'No hay ningún reto pendiente',

      'no_dare_description': 'Envía un reto a tu pareja desde tu mano.',

      'view_your_dare': 'VER TU RETO',

      'your_sent_dare': 'Tu reto enviado',

      'rejoining': 'Volviendo a tu partida...',

      'made_for_two': 'Hecho para dos personas',

      'try_again': 'INTENTAR DE NUEVO',

      'forget_saved_game': 'Olvidar esta partida guardada',

      'auto_rejoin_failed':
          'No se pudo volver automáticamente a tu partida guardada.',

      'game_ended': 'Esta partida ha terminado.',

      'game_deleted': 'Partida eliminada.',

      'no_sent_dare': 'Aún no has enviado ningún reto.',

      'one_dare_per_day':
          'El límite diario se aplica por separado a cada modo activado.',

      'dare_sent': '¡Reto enviado! ❤️',

      'could_not_find_player': 'No se pudo encontrar tu jugador.',

      'code_help': 'Da este código a tu pareja para que pueda unirse.',

      'close_hand': 'Cerrar mano',

      'game_menu_tooltip': 'Menú de partida',

      'please_enter_name': 'Introduce tu nombre.',

      'please_enter_code': 'Introduce el código de 5 caracteres.',

      'could_not_create': 'No se pudo crear la partida',

      'could_not_join': 'No se pudo unir a la partida',

      'could_not_load': 'No se pudo cargar la partida',

      'could_not_send': 'No se pudo enviar el reto',

      'could_not_resolve': 'No se pudo resolver el reto',

      'could_not_delete': 'No se pudo eliminar la partida',

      'cards_left': 'restantes',

      'sweet_mode': 'MODO DULCE',

      'spicy_mode': 'MODO PICANTE',

      'optional': 'OPCIONAL',

      'enabled': 'ACTIVADO',

      'romantic_adventurous': 'Romántico + Aventurero',

      'naughty_extreme': 'Atrevido + Extremo',

      'choose_main_packs': 'Elige los packs principales para tu partida.',

      'enable_spicy_description':
          'Activa el Modo Picante seleccionando uno o más packs extra.',

      'spicy_lane_enabled':
          'El Modo Picante estará disponible como una sección independiente.',

      'include_custom_cards': 'Incluir cartas personalizadas',

      'include_custom_cards_description': 'Incluye cartas personalizadas compatibles creadas por ambos jugadores.',

      'dares_per_day': 'Retos por día',

      'dares_per_day_description': 'Elige cuántos retos puede enviar cada jugador al día en cada modo activado.',

      'please_select_pack': 'Selecciona al menos un pack.',

      'no_deck_categories': 'No se encontraron categorías.',

      'no_sweet_packs': 'No se encontraron packs Dulces.',

      'no_spicy_packs': 'No se encontraron packs Picantes.',

      'invite_code_copied': 'Código de invitación copiado',

      'sweet': 'DULCE',

      'spicy': 'PICANTE',

      'sweet_hand': 'MANO DULCE',

      'spicy_hand': 'MANO PICANTE',

      'your_sweet_dare': 'TU RETO DULCE',

      'your_spicy_dare': 'TU RETO PICANTE',

      'no_sweet_dare': 'Aún no hay reto Dulce',

      'no_spicy_dare': 'Aún no hay reto Picante',

      'sweet_dare_description':
          'Los retos Románticos y Aventureros aparecerán aquí.',

      'spicy_dare_description':
          'Los retos Atrevidos y Extremos aparecerán aquí.',

      'swipe_for_spicy': 'Desliza a la izquierda para Picante →',

      'swipe_for_sweet': '← Desliza a la derecha para Dulce',

      'draw_sweet_card': 'ROBAR CARTA DULCE',

      'draw_spicy_card': 'ROBAR CARTA PICANTE',

      'drawing': 'ROBANDO...',

      'last_sent': 'Último enviado',

      'played_cards': 'cartas jugadas',

      'no_played_cards': 'Aún no se ha jugado ninguna carta.',

      'sent_today': 'enviados hoy',

      'daily_limit_reached': 'límite diario alcanzado',

      'send_sweet_dare': 'ENVIAR RETO DULCE',

      'send_spicy_dare': 'ENVIAR RETO PICANTE',

      'new_sweet_dare': 'NUEVO RETO DULCE',

      'new_spicy_dare': 'NUEVO RETO PICANTE',

      'back_to_table': 'VOLVER A LA MESA',

      'waiting_for_response': 'Esperando respuesta',

      'resolved': 'Resuelto',

      'player': 'Jugador',
    },

    'fr': {
      'sound_effects': 'Effets sonores',
      'sound_effects_description':
          'Joue des sons pour les cartes et les actions du jeu.',
      'custom_cards': 'Cartes personnalisées',
      'create_your_own_dares': 'Créez vos propres défis',
      'custom_dare': 'Défi personnalisé',
      'could_not_load_custom_cards':
          'Impossible de charger les cartes personnalisées',
      'no_custom_cards_yet':
          'Vous n’avez encore créé aucune carte personnalisée.',
      'add_card': 'AJOUTER UNE CARTE',
      'add_custom_card': 'Ajouter une carte personnalisée',
      'name': 'Nom',
      'example_breakfast_in_bed': 'ex. Petit-déjeuner au lit',
      'dare_text': 'Texte du défi',
      'enter_partner_dare':
          'Saisissez ce que vous voulez que votre partenaire fasse',
      'category': 'Catégorie',
      'please_enter_name_and_dare': 'Saisissez un nom et le texte du défi.',
      'must_be_signed_in': 'Vous devez être connecté.',
      'could_not_save_card': 'Impossible d’enregistrer la carte',
      'save': 'ENREGISTRER',

      'dare': 'Défi',

      'new_dare': 'Nouveau défi',

      'drawn_card': 'Carte piochée',

      'could_not_draw': 'Impossible de piocher la carte',

      'played': 'jouées',

      'new_sweet_card': 'NOUVELLE CARTE DOUCE',

      'new_spicy_card': 'NOUVELLE CARTE PIMENTÉE',

      'add_to_hand': 'AJOUTER À LA MAIN',

      'romantic': 'Romantique',

      'adventurous': 'Aventureux',

      'naughty': 'Coquin',

      'extreme': 'Extrême',

      'copy_invite_code': 'Copier le code d’invitation',

      'could_not_load_decks': 'Impossible de charger les packs',

      'app_name': 'Double Dare',

      'tagline': 'Un petit jeu pour deux.',

      'create_game': 'Créer une partie',

      'join_game': 'Rejoindre une partie',

      'settings': 'Paramètres',

      'dark_mode': 'Mode sombre',

      'dark_mode_description': 'Utiliser le thème de couleurs sombre.',

      'language': 'Langue',

      'close': 'FERMER',

      'your_name': 'Votre prénom',

      'enter_name': 'Entrez votre prénom',

      'game_code': 'Code de partie',

      'create_your_game': 'Créez votre partie',

      'create_description':
          'Choisissez votre prénom et créez une partie pour votre partenaire.',

      'create_info': 'Créez une partie pour recevoir un code de 5 caractères à partager avec votre partenaire.',

      'join_your_partner': 'Rejoignez votre partenaire',

      'join_description': 'Entrez votre prénom et le code à 5 caractères partagé par votre partenaire.',

      'join_info': 'Le code est créé lorsque votre partenaire démarre une nouvelle partie.',

      'your_game_code': 'VOTRE CODE DE PARTIE',

      'share_code': 'Partagez ce code avec votre partenaire.',

      'enter_game': 'ENTRER',

      'join_game_button': 'REJOINDRE',

      'create_game_button': 'CRÉER',

      'game_menu': 'MENU DE PARTIE',

      'leave_game': 'Quitter la partie',

      'delete_game_description': 'Supprimer définitivement cette partie',

      'leave_game_question': 'Quitter la partie ?',

      'leave_warning': 'Quitter supprimera définitivement cette partie, ses cartes et toutes ses données. Cette action est irréversible.',

      'cancel': 'ANNULER',

      'leave_delete': 'QUITTER ET SUPPRIMER',

      'your_hand': 'VOTRE MAIN',

      'send_dare': 'ENVOYER LE DÉFI',

      'your_dare': 'VOTRE DÉFI',

      'accept': 'ACCEPTER',

      'refuse': 'REFUSER',

      'no_dare': 'Aucun défi en attente',

      'no_dare_description':
          'Envoyez un défi à votre partenaire depuis votre main.',

      'view_your_dare': 'VOIR VOTRE DÉFI',

      'your_sent_dare': 'Votre défi envoyé',

      'rejoining': 'Retour à votre partie...',

      'made_for_two': 'Fait pour deux',

      'try_again': 'RÉESSAYER',

      'forget_saved_game': 'Oublier cette partie enregistrée',

      'auto_rejoin_failed':
          'Impossible de rejoindre automatiquement votre partie enregistrée.',

      'game_ended': 'Cette partie est terminée.',

      'game_deleted': 'Partie supprimée.',

      'no_sent_dare': 'Vous n’avez pas encore envoyé de défi.',

      'one_dare_per_day':
          'La limite quotidienne s’applique séparément à chaque mode activé.',

      'dare_sent': 'Défi envoyé ! ❤️',

      'could_not_find_player': 'Impossible de trouver votre joueur.',

      'code_help':
          'Donnez ce code à votre partenaire pour rejoindre la partie.',

      'close_hand': 'Fermer la main',

      'game_menu_tooltip': 'Menu de partie',

      'please_enter_name': 'Veuillez saisir votre prénom.',

      'please_enter_code': 'Veuillez saisir le code à 5 caractères.',

      'could_not_create': 'Impossible de créer la partie',

      'could_not_join': 'Impossible de rejoindre la partie',

      'could_not_load': 'Impossible de charger la partie',

      'could_not_send': 'Impossible d’envoyer le défi',

      'could_not_resolve': 'Impossible de résoudre le défi',

      'could_not_delete': 'Impossible de supprimer la partie',

      'cards_left': 'restantes',

      'sweet_mode': 'MODE DOUX',

      'spicy_mode': 'MODE PIMENTÉ',

      'optional': 'FACULTATIF',

      'enabled': 'ACTIVÉ',

      'romantic_adventurous': 'Romantique + Aventureux',

      'naughty_extreme': 'Coquin + Extrême',

      'choose_main_packs': 'Choisissez les packs principaux de votre partie.',

      'enable_spicy_description': 'Activez le Mode Pimenté en sélectionnant un ou plusieurs packs supplémentaires.',

      'spicy_lane_enabled':
          'Le Mode Pimenté sera disponible dans une section séparée.',

      'include_custom_cards': 'Inclure les cartes personnalisées',

      'include_custom_cards_description': 'Inclut les cartes personnalisées compatibles créées par les deux joueurs.',

      'dares_per_day': 'Défis par jour',

      'dares_per_day_description': 'Choisissez combien de défis chaque joueur peut envoyer par jour dans chaque mode activé.',

      'please_select_pack': 'Sélectionnez au moins un pack.',

      'no_deck_categories': 'Aucune catégorie trouvée.',

      'no_sweet_packs': 'Aucun pack Doux trouvé.',

      'no_spicy_packs': 'Aucun pack Pimenté trouvé.',

      'invite_code_copied': 'Code d’invitation copié',

      'sweet': 'DOUX',

      'spicy': 'PIMENTÉ',

      'sweet_hand': 'MAIN DOUCE',

      'spicy_hand': 'MAIN PIMENTÉE',

      'your_sweet_dare': 'VOTRE DÉFI DOUX',

      'your_spicy_dare': 'VOTRE DÉFI PIMENTÉ',

      'no_sweet_dare': 'Aucun défi Doux pour le moment',

      'no_spicy_dare': 'Aucun défi Pimenté pour le moment',

      'sweet_dare_description':
          'Les défis Romantiques et Aventureux apparaîtront ici.',

      'spicy_dare_description':
          'Les défis Coquins et Extrêmes apparaîtront ici.',

      'swipe_for_spicy': 'Glissez à gauche pour Pimenté →',

      'swipe_for_sweet': '← Glissez à droite pour Doux',

      'draw_sweet_card': 'PIOCHER UNE CARTE DOUCE',

      'draw_spicy_card': 'PIOCHER UNE CARTE PIMENTÉE',

      'drawing': 'PIOCHE...',

      'last_sent': 'Dernier envoyé',

      'played_cards': 'cartes jouées',

      'no_played_cards': 'Aucune carte n’a encore été jouée.',

      'sent_today': 'envoyés aujourd’hui',

      'daily_limit_reached': 'limite quotidienne atteinte',

      'send_sweet_dare': 'ENVOYER UN DÉFI DOUX',

      'send_spicy_dare': 'ENVOYER UN DÉFI PIMENTÉ',

      'new_sweet_dare': 'NOUVEAU DÉFI DOUX',

      'new_spicy_dare': 'NOUVEAU DÉFI PIMENTÉ',

      'back_to_table': 'RETOUR À LA TABLE',

      'waiting_for_response': 'En attente de réponse',

      'resolved': 'Résolu',

      'player': 'Joueur',
    },

    'de': {
      'sound_effects': 'Soundeffekte',
      'sound_effects_description':
          'Spielt Sounds für Karten und Spielaktionen ab.',
      'custom_cards': 'Eigene Karten',
      'create_your_own_dares': 'Erstelle deine eigenen Challenges',
      'custom_dare': 'Eigene Challenge',
      'could_not_load_custom_cards':
          'Eigene Karten konnten nicht geladen werden',
      'no_custom_cards_yet': 'Du hast noch keine eigenen Karten erstellt.',
      'add_card': 'KARTE HINZUFÜGEN',
      'add_custom_card': 'Eigene Karte hinzufügen',
      'name': 'Name',
      'example_breakfast_in_bed': 'z. B. Frühstück im Bett',
      'dare_text': 'Challenge-Text',
      'enter_partner_dare': 'Gib ein, was dein Partner tun soll',
      'category': 'Kategorie',
      'please_enter_name_and_dare':
          'Bitte gib einen Namen und einen Challenge-Text ein.',
      'must_be_signed_in': 'Du musst angemeldet sein.',
      'could_not_save_card': 'Karte konnte nicht gespeichert werden',
      'save': 'SPEICHERN',

      'dare': 'Challenge',

      'new_dare': 'Neue Challenge',

      'drawn_card': 'Gezogene Karte',

      'could_not_draw': 'Karte konnte nicht gezogen werden',

      'played': 'gespielt',

      'new_sweet_card': 'NEUE SWEET-KARTE',

      'new_spicy_card': 'NEUE SPICY-KARTE',

      'add_to_hand': 'ZUR HAND HINZUFÜGEN',

      'romantic': 'Romantisch',

      'adventurous': 'Abenteuerlich',

      'naughty': 'Frech',

      'extreme': 'Extrem',

      'copy_invite_code': 'Einladungscode kopieren',

      'could_not_load_decks': 'Pakete konnten nicht geladen werden',

      'app_name': 'PDouble Dare',

      'tagline': 'Ein kleines Spiel für zwei.',

      'create_game': 'Spiel erstellen',

      'join_game': 'Spiel beitreten',

      'settings': 'Einstellungen',

      'dark_mode': 'Dunkler Modus',

      'dark_mode_description': 'Das dunklere Farbschema verwenden.',

      'language': 'Sprache',

      'close': 'SCHLIESSEN',

      'your_name': 'Dein Name',

      'enter_name': 'Name eingeben',

      'game_code': 'Spielcode',

      'create_your_game': 'Erstelle dein Spiel',

      'create_description':
          'Wähle deinen Namen und erstelle ein Spiel für deinen Partner.',

      'create_info': 'Erstelle ein Spiel und erhalte einen 5-stelligen Code zum Teilen mit deinem Partner.',

      'join_your_partner': 'Tritt deinem Partner bei',

      'join_description':
          'Gib deinen Namen und den 5-stelligen Spielcode deines Partners ein.',

      'join_info': 'Der Spielcode wird erstellt, wenn dein Partner ein neues Spiel startet.',

      'your_game_code': 'DEIN SPIELCODE',

      'share_code': 'Teile diesen Code mit deinem Partner.',

      'enter_game': 'SPIEL BETRETEN',

      'join_game_button': 'BEITRETEN',

      'create_game_button': 'SPIEL ERSTELLEN',

      'game_menu': 'SPIELMENÜ',

      'leave_game': 'Spiel verlassen',

      'delete_game_description': 'Dieses Spiel dauerhaft löschen',

      'leave_game_question': 'Spiel verlassen?',

      'leave_warning': 'Beim Verlassen werden dieses Spiel, alle Karten und alle Spieldaten dauerhaft gelöscht. Dies kann nicht rückgängig gemacht werden.',

      'cancel': 'ABBRECHEN',

      'leave_delete': 'VERLASSEN & LÖSCHEN',

      'your_hand': 'DEINE KARTEN',

      'send_dare': 'CHALLENGE SENDEN',

      'your_dare': 'DEINE CHALLENGE',

      'accept': 'ANNEHMEN',

      'refuse': 'ABLEHNEN',

      'no_dare': 'Keine Challenge wartet',

      'no_dare_description':
          'Sende deinem Partner eine Challenge aus deiner Hand.',

      'view_your_dare': 'CHALLENGE ANZEIGEN',

      'your_sent_dare': 'Deine gesendete Challenge',

      'rejoining': 'Spiel wird wieder geöffnet...',

      'made_for_two': 'Für zwei gemacht',

      'try_again': 'NOCHMAL VERSUCHEN',

      'forget_saved_game': 'Gespeichertes Spiel vergessen',

      'auto_rejoin_failed':
          'Das gespeicherte Spiel konnte nicht automatisch geöffnet werden.',

      'game_ended': 'Dieses Spiel wurde beendet.',

      'game_deleted': 'Spiel gelöscht.',

      'no_sent_dare': 'Du hast noch keine Challenge gesendet.',

      'one_dare_per_day':
          'Das Tageslimit gilt separat für jeden aktivierten Modus.',

      'dare_sent': 'Challenge gesendet! ❤️',

      'could_not_find_player': 'Dein Spieler konnte nicht gefunden werden.',

      'code_help': 'Gib diesen Code deinem Partner, damit er beitreten kann.',

      'close_hand': 'Karten schließen',

      'game_menu_tooltip': 'Spielmenü',

      'please_enter_name': 'Bitte gib deinen Namen ein.',

      'please_enter_code': 'Bitte gib den 5-stelligen Spielcode ein.',

      'could_not_create': 'Spiel konnte nicht erstellt werden',

      'could_not_join': 'Spielbeitritt fehlgeschlagen',

      'could_not_load': 'Spiel konnte nicht geladen werden',

      'could_not_send': 'Challenge konnte nicht gesendet werden',

      'could_not_resolve': 'Challenge konnte nicht abgeschlossen werden',

      'could_not_delete': 'Spiel konnte nicht gelöscht werden',

      'cards_left': 'übrig',

      'sweet_mode': 'SWEET-MODUS',

      'spicy_mode': 'SPICY-MODUS',

      'optional': 'OPTIONAL',

      'enabled': 'AKTIV',

      'romantic_adventurous': 'Romantisch + Abenteuerlich',

      'naughty_extreme': 'Frech + Extrem',

      'choose_main_packs': 'Wähle die Hauptpakete für dein Spiel.',

      'enable_spicy_description': 'Aktiviere den Spicy-Modus, indem du ein oder mehrere Zusatzpakete auswählst.',

      'spicy_lane_enabled':
          'Der Spicy-Modus wird als eigener Spielbereich verfügbar.',

      'include_custom_cards': 'Eigene Karten einbeziehen',

      'include_custom_cards_description':
          'Bezieht passende eigene Karten von beiden Spielern ein.',

      'dares_per_day': 'Challenges pro Tag',

      'dares_per_day_description': 'Wähle, wie viele Challenges jeder Spieler pro Tag in jedem aktivierten Modus senden kann.',

      'please_select_pack': 'Wähle mindestens ein Paket aus.',

      'no_deck_categories': 'Keine Kategorien gefunden.',

      'no_sweet_packs': 'Keine Sweet-Pakete gefunden.',

      'no_spicy_packs': 'Keine Spicy-Pakete gefunden.',

      'invite_code_copied': 'Einladungscode kopiert',

      'sweet': 'SWEET',

      'spicy': 'SPICY',

      'sweet_hand': 'SWEET-HAND',

      'spicy_hand': 'SPICY-HAND',

      'your_sweet_dare': 'DEINE SWEET-CHALLENGE',

      'your_spicy_dare': 'DEINE SPICY-CHALLENGE',

      'no_sweet_dare': 'Noch keine Sweet-Challenge',

      'no_spicy_dare': 'Noch keine Spicy-Challenge',

      'sweet_dare_description':
          'Romantische und abenteuerliche Challenges erscheinen hier.',

      'spicy_dare_description':
          'Freche und extreme Challenges erscheinen hier.',

      'swipe_for_spicy': 'Nach links wischen für Spicy →',

      'swipe_for_sweet': '← Nach rechts wischen für Sweet',

      'draw_sweet_card': 'SWEET-KARTE ZIEHEN',

      'draw_spicy_card': 'SPICY-KARTE ZIEHEN',

      'drawing': 'WIRD GEZOGEN...',

      'last_sent': 'Zuletzt gesendet',

      'played_cards': 'gespielte Karten',

      'no_played_cards': 'Es wurden noch keine Karten gespielt.',

      'sent_today': 'heute gesendet',

      'daily_limit_reached': 'Tageslimit erreicht',

      'send_sweet_dare': 'SWEET-CHALLENGE SENDEN',

      'send_spicy_dare': 'SPICY-CHALLENGE SENDEN',

      'new_sweet_dare': 'NEUE SWEET-CHALLENGE',

      'new_spicy_dare': 'NEUE SPICY-CHALLENGE',

      'back_to_table': 'ZURÜCK ZUM SPIEL',

      'waiting_for_response': 'Wartet auf Antwort',

      'resolved': 'Erledigt',

      'player': 'Spieler',
    },

    'pt': {
      'sound_effects': 'Efeitos sonoros',
      'sound_effects_description': 'Reproduz sons para cartas e ações do jogo.',
      'custom_cards': 'Cartas personalizadas',
      'create_your_own_dares': 'Cria os teus próprios desafios',
      'custom_dare': 'Desafio personalizado',
      'could_not_load_custom_cards':
          'Não foi possível carregar as cartas personalizadas',
      'no_custom_cards_yet': 'Ainda não criaste nenhuma carta personalizada.',
      'add_card': 'ADICIONAR CARTA',
      'add_custom_card': 'Adicionar carta personalizada',
      'name': 'Nome',
      'example_breakfast_in_bed': 'ex. Pequeno-almoço na cama',
      'dare_text': 'Texto do desafio',
      'enter_partner_dare': 'Escreve o que queres que o teu parceiro faça',
      'category': 'Categoria',
      'please_enter_name_and_dare': 'Introduz um nome e o texto do desafio.',
      'must_be_signed_in': 'Tens de iniciar sessão.',
      'could_not_save_card': 'Não foi possível guardar a carta',
      'save': 'GUARDAR',

      'dare': 'Desafio',

      'new_dare': 'Novo desafio',

      'drawn_card': 'Carta comprada',

      'could_not_draw': 'Não foi possível comprar a carta',

      'played': 'jogadas',

      'new_sweet_card': 'NOVA CARTA DOCE',

      'new_spicy_card': 'NOVA CARTA PICANTE',

      'add_to_hand': 'ADICIONAR À MÃO',

      'romantic': 'Romântico',

      'adventurous': 'Aventureiro',

      'naughty': 'Atrevido',

      'extreme': 'Extremo',

      'copy_invite_code': 'Copiar código de convite',

      'could_not_load_decks': 'Não foi possível carregar os packs',

      'app_name': 'Double Dare',

      'tagline': 'Um pequeno jogo para dois.',

      'create_game': 'Criar jogo',

      'join_game': 'Entrar no jogo',

      'settings': 'Definições',

      'dark_mode': 'Modo escuro',

      'dark_mode_description': 'Usar o tema de cores mais escuro.',

      'language': 'Idioma',

      'close': 'FECHAR',

      'your_name': 'O teu nome',

      'enter_name': 'Introduz o teu nome',

      'game_code': 'Código do jogo',

      'create_your_game': 'Cria o teu jogo',

      'create_description':
          'Escolhe o teu nome e cria um jogo para o teu parceiro.',

      'create_info': 'Cria um jogo para receber um código de 5 caracteres que podes partilhar com o teu parceiro.',

      'join_your_partner': 'Junta-te ao teu parceiro',

      'join_description': 'Introduz o teu nome e o código de 5 caracteres partilhado pelo teu parceiro.',

      'join_info':
          'O código é criado quando o teu parceiro inicia um novo jogo.',

      'your_game_code': 'O TEU CÓDIGO',

      'share_code': 'Partilha este código com o teu parceiro.',

      'enter_game': 'ENTRAR',

      'join_game_button': 'ENTRAR NO JOGO',

      'create_game_button': 'CRIAR JOGO',

      'game_menu': 'MENU DO JOGO',

      'leave_game': 'Sair do jogo',

      'delete_game_description': 'Eliminar permanentemente este jogo',

      'leave_game_question': 'Sair do jogo?',

      'leave_warning': 'Sair irá eliminar permanentemente este jogo, todas as cartas e os dados do jogo. Esta ação não pode ser anulada.',

      'cancel': 'CANCELAR',

      'leave_delete': 'SAIR E ELIMINAR',

      'your_hand': 'A TUA MÃO',

      'send_dare': 'ENVIAR DESAFIO',

      'your_dare': 'O TEU DESAFIO',

      'accept': 'ACEITAR',

      'refuse': 'RECUSAR',

      'no_dare': 'Nenhum desafio pendente',

      'no_dare_description':
          'Envia um desafio ao teu parceiro a partir da tua mão.',

      'view_your_dare': 'VER O TEU DESAFIO',

      'your_sent_dare': 'O teu desafio enviado',

      'rejoining': 'A voltar ao teu jogo...',

      'made_for_two': 'Feito para duas pessoas',

      'try_again': 'TENTAR NOVAMENTE',

      'forget_saved_game': 'Esquecer este jogo guardado',

      'auto_rejoin_failed':
          'Não foi possível voltar automaticamente ao jogo guardado.',

      'game_ended': 'Este jogo terminou.',

      'game_deleted': 'Jogo eliminado.',

      'no_sent_dare': 'Ainda não enviaste nenhum desafio.',

      'one_dare_per_day':
          'O limite diário aplica-se separadamente a cada modo ativado.',

      'dare_sent': 'Desafio enviado! ❤️',

      'could_not_find_player': 'Não foi possível encontrar o teu jogador.',

      'code_help': 'Dá este código ao teu parceiro para ele entrar no jogo.',

      'close_hand': 'Fechar mão',

      'game_menu_tooltip': 'Menu do jogo',

      'please_enter_name': 'Introduz o teu nome.',

      'please_enter_code': 'Introduz o código de 5 caracteres.',

      'could_not_create': 'Não foi possível criar o jogo',

      'could_not_join': 'Não foi possível entrar no jogo',

      'could_not_load': 'Não foi possível carregar o jogo',

      'could_not_send': 'Não foi possível enviar o desafio',

      'could_not_resolve': 'Não foi possível resolver o desafio',

      'could_not_delete': 'Não foi possível eliminar o jogo',

      'cards_left': 'restantes',

      'sweet_mode': 'MODO DOCE',

      'spicy_mode': 'MODO PICANTE',

      'optional': 'OPCIONAL',

      'enabled': 'ATIVADO',

      'romantic_adventurous': 'Romântico + Aventureiro',

      'naughty_extreme': 'Atrevido + Extremo',

      'choose_main_packs': 'Escolhe os packs principais para o teu jogo.',

      'enable_spicy_description':
          'Ativa o Modo Picante selecionando um ou mais packs extra.',

      'spicy_lane_enabled':
          'O Modo Picante ficará disponível como uma área separada do jogo.',

      'include_custom_cards': 'Incluir cartas personalizadas',

      'include_custom_cards_description': 'Inclui cartas personalizadas compatíveis criadas pelos dois jogadores.',

      'dares_per_day': 'Desafios por dia',

      'dares_per_day_description': 'Escolhe quantos desafios cada jogador pode enviar por dia em cada modo ativado.',

      'please_select_pack': 'Seleciona pelo menos um pack.',

      'no_deck_categories': 'Não foram encontradas categorias.',

      'no_sweet_packs': 'Não foram encontrados packs Doces.',

      'no_spicy_packs': 'Não foram encontrados packs Picantes.',

      'invite_code_copied': 'Código de convite copiado',

      'sweet': 'DOCE',

      'spicy': 'PICANTE',

      'sweet_hand': 'MÃO DOCE',

      'spicy_hand': 'MÃO PICANTE',

      'your_sweet_dare': 'O TEU DESAFIO DOCE',

      'your_spicy_dare': 'O TEU DESAFIO PICANTE',

      'no_sweet_dare': 'Ainda não há desafio Doce',

      'no_spicy_dare': 'Ainda não há desafio Picante',

      'sweet_dare_description':
          'Os desafios Românticos e Aventureiros aparecem aqui.',

      'spicy_dare_description':
          'Os desafios Atrevidos e Extremos aparecem aqui.',

      'swipe_for_spicy': 'Desliza para a esquerda para Picante →',

      'swipe_for_sweet': '← Desliza para a direita para Doce',

      'draw_sweet_card': 'COMPRAR CARTA DOCE',

      'draw_spicy_card': 'COMPRAR CARTA PICANTE',

      'drawing': 'A COMPRAR...',

      'last_sent': 'Último enviado',

      'played_cards': 'cartas jogadas',

      'no_played_cards': 'Ainda não foram jogadas cartas.',

      'sent_today': 'enviados hoje',

      'daily_limit_reached': 'limite diário atingido',

      'send_sweet_dare': 'ENVIAR DESAFIO DOCE',

      'send_spicy_dare': 'ENVIAR DESAFIO PICANTE',

      'new_sweet_dare': 'NOVO DESAFIO DOCE',

      'new_spicy_dare': 'NOVO DESAFIO PICANTE',

      'back_to_table': 'VOLTAR AO JOGO',

      'waiting_for_response': 'À espera de resposta',

      'resolved': 'Resolvido',

      'player': 'Jogador',
    },

    'zh': {
      'sound_effects': '音效',
      'sound_effects_description': '为卡牌和游戏操作播放音效。',
      'custom_cards': '自定义卡牌',
      'create_your_own_dares': '创建你自己的挑战',
      'custom_dare': '自定义挑战',
      'could_not_load_custom_cards': '无法加载自定义卡牌',
      'no_custom_cards_yet': '你还没有创建任何自定义卡牌。',
      'add_card': '添加卡牌',
      'add_custom_card': '添加自定义卡牌',
      'name': '名称',
      'example_breakfast_in_bed': '例如：床上早餐',
      'dare_text': '挑战内容',
      'enter_partner_dare': '输入你希望伴侣完成的内容',
      'category': '类别',
      'please_enter_name_and_dare': '请输入名称和挑战内容。',
      'must_be_signed_in': '你必须先登录。',
      'could_not_save_card': '无法保存卡牌',
      'save': '保存',

      'dare': '挑战',

      'new_dare': '新挑战',

      'drawn_card': '抽到的卡牌',

      'could_not_draw': '无法抽取卡牌',

      'played': '已使用',

      'new_sweet_card': '新的甜蜜卡牌',

      'new_spicy_card': '新的刺激卡牌',

      'add_to_hand': '加入手牌',

      'romantic': '浪漫',

      'adventurous': '冒险',

      'naughty': '大胆',

      'extreme': '极限',

      'copy_invite_code': '复制邀请码',

      'could_not_load_decks': '无法加载卡包',

      'app_name': 'Double Dare',

      'tagline': '两个人的小小游戏。',

      'create_game': '创建游戏',

      'join_game': '加入游戏',

      'settings': '设置',

      'dark_mode': '深色模式',

      'dark_mode_description': '使用深色主题。',

      'language': '语言',

      'close': '关闭',

      'your_name': '你的名字',

      'enter_name': '输入你的名字',

      'game_code': '游戏代码',

      'create_your_game': '创建你的游戏',

      'create_description': '输入你的名字并为伴侣创建一个游戏。',

      'create_info': '创建游戏后会获得一个 5 位代码，可以分享给伴侣。',

      'join_your_partner': '加入伴侣的游戏',

      'join_description': '输入你的名字和伴侣分享的 5 位游戏代码。',

      'join_info': '你的伴侣创建新游戏时会生成游戏代码。',

      'your_game_code': '你的游戏代码',

      'share_code': '把这个代码分享给你的伴侣。',

      'enter_game': '进入游戏',

      'join_game_button': '加入游戏',

      'create_game_button': '创建游戏',

      'game_menu': '游戏菜单',

      'leave_game': '离开游戏',

      'delete_game_description': '永久删除此游戏',

      'leave_game_question': '离开游戏？',

      'leave_warning': '离开后将永久删除此游戏、所有卡牌和游戏数据，且无法撤销。',

      'cancel': '取消',

      'leave_delete': '离开并删除',

      'your_hand': '你的手牌',

      'send_dare': '发送挑战',

      'your_dare': '你的挑战',

      'accept': '接受',

      'refuse': '拒绝',

      'no_dare': '暂无挑战',

      'no_dare_description': '从你的手牌中向伴侣发送一个挑战。',

      'view_your_dare': '查看挑战',

      'your_sent_dare': '你发送的挑战',

      'rejoining': '正在重新加入游戏...',

      'made_for_two': '专为两人设计',

      'try_again': '重试',

      'forget_saved_game': '忘记已保存的游戏',

      'auto_rejoin_failed': '无法自动重新加入已保存的游戏。',

      'game_ended': '这个游戏已经结束。',

      'game_deleted': '游戏已删除。',

      'no_sent_dare': '你还没有发送过挑战。',

      'one_dare_per_day': '每日挑战上限会分别应用于每个已启用模式。',

      'dare_sent': '挑战已发送！❤️',

      'could_not_find_player': '找不到你的玩家。',

      'code_help': '把这个代码给你的伴侣，让对方加入游戏。',

      'close_hand': '关闭手牌',

      'game_menu_tooltip': '游戏菜单',

      'please_enter_name': '请输入你的名字。',

      'please_enter_code': '请输入 5 位游戏代码。',

      'could_not_create': '无法创建游戏',

      'could_not_join': '无法加入游戏',

      'could_not_load': '无法加载游戏',

      'could_not_send': '无法发送挑战',

      'could_not_resolve': '无法处理挑战',

      'could_not_delete': '无法删除游戏',

      'cards_left': '剩余',

      'sweet_mode': '甜蜜模式',

      'spicy_mode': '刺激模式',

      'optional': '可选',

      'enabled': '已启用',

      'romantic_adventurous': '浪漫 + 冒险',

      'naughty_extreme': '大胆 + 极限',

      'choose_main_packs': '选择游戏的主要卡包。',

      'enable_spicy_description': '选择一个或多个额外卡包来启用刺激模式。',

      'spicy_lane_enabled': '刺激模式会作为独立游戏区域显示。',

      'include_custom_cards': '包含自定义卡牌',

      'include_custom_cards_description': '包含两位玩家创建且与所选类别匹配的自定义卡牌。',

      'dares_per_day': '每日挑战数',

      'dares_per_day_description': '选择每位玩家在每个已启用模式中每天可发送的挑战数量。',

      'please_select_pack': '请至少选择一个卡包。',

      'no_deck_categories': '未找到卡牌类别。',

      'no_sweet_packs': '未找到甜蜜模式卡包。',

      'no_spicy_packs': '未找到刺激模式卡包。',

      'invite_code_copied': '邀请码已复制',

      'sweet': '甜蜜',

      'spicy': '刺激',

      'sweet_hand': '甜蜜手牌',

      'spicy_hand': '刺激手牌',

      'your_sweet_dare': '你的甜蜜挑战',

      'your_spicy_dare': '你的刺激挑战',

      'no_sweet_dare': '暂时没有甜蜜挑战',

      'no_spicy_dare': '暂时没有刺激挑战',

      'sweet_dare_description': '浪漫和冒险挑战会显示在这里。',

      'spicy_dare_description': '大胆和极限挑战会显示在这里。',

      'swipe_for_spicy': '向左滑动切换到刺激模式 →',

      'swipe_for_sweet': '← 向右滑动切换到甜蜜模式',

      'draw_sweet_card': '抽取甜蜜卡牌',

      'draw_spicy_card': '抽取刺激卡牌',

      'drawing': '抽取中...',

      'last_sent': '上次发送',

      'played_cards': '已使用卡牌',

      'no_played_cards': '还没有使用过卡牌。',

      'sent_today': '今日已发送',

      'daily_limit_reached': '已达到每日上限',

      'send_sweet_dare': '发送甜蜜挑战',

      'send_spicy_dare': '发送刺激挑战',

      'new_sweet_dare': '新的甜蜜挑战',

      'new_spicy_dare': '新的刺激挑战',

      'back_to_table': '返回游戏',

      'waiting_for_response': '等待回应',

      'resolved': '已完成',

      'player': '玩家',
    },
  };

  static String t(String key) {
    final code = LanguageController.current;

    return _translations[code]?[key] ?? _translations['en']?[key] ?? key;
  }
}
