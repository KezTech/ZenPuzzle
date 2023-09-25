import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zen/pages/challenge.dart';
import 'package:zen/pages/mode.dart';
import 'package:zen/slider/puzzle_app.dart';

import 'mem/views/game_screen.dart';
import 'mem/views/start_game_screen.dart';
import 'pages/available_rooms_page.dart';
import 'pages/create_room_name_page.dart';
import 'pages/edit_user_name.dart';
import 'routing/navigator.dart';
import 'store/user_profile.dart';
import 'theme/colors.dart';
import 'theme/dp.dart';
import 'theme/typo.dart';
import 'widgets/const.dart';
import 'widgets/menu_button.dart';
import 'widgets/no_glow.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/casual_game.dart';
import 'models/challenge_game.dart';
import 'models/preferences.dart';

Future<void> _setupUserProfileStore() async {
  userName = ValueNotifier(await getUserName());
  var previousName = userName.value;

  userName.addListener(() async {
    if (userName.value != previousName) {
      previousName = userName.value;
      await setUserName(userName.value);
    }
  });
}

Future<void> setupDependencies() async {
  await _setupUserProfileStore();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  await setupDependencies();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: kHighContrast,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: kHighContrast,
    ),
  );

  runApp(
    // DevicePreview(
    //   enabled: kDebugMode,
    //   builder: (context) =>
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChallengeGame(context)),
        ChangeNotifierProvider(create: (context) => CasualGame(context)),
        ChangeNotifierProvider(create: (context) => Preferences(prefs)),
      ],
      child: const TicTacApp(),
    ),
    // ),
  );
}

class TicTacApp extends StatelessWidget {
  const TicTacApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.light().copyWith();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlow(),
          child: child!,
        );
      },
      title: 'Zen Puzzle',
      theme: theme.copyWith(
        scaffoldBackgroundColor: kHighContrast,
        textTheme: theme.textTheme.apply(
          fontFamily: kFontFamily,
          bodyColor: kDarkerColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void _byOpenCreateRoomPage() =>
      context.push((context) => const CreateRoomNamePage());

  void _byOpenServerListPage() =>
      context.push((context) => const AvailableRoomsPage());

  void _byOpenEditProfilePage() =>
      context.push((context) => const EditUserName());

  void _mathGame() => context.push((context) => const ModePage(
        gamemode: 1,
      ));

  void _slid() => context.push((context) => const PuzzleApp());

  void _memGame() => context.push((context) => const MyFlipCardGame());

  Widget _buildLogo() => Column(
        children: [
          const Center(child: Text('Zen\n Puzzle\n', style: kLogoTxt)),
          Container(
              height: 70,
              width: 120,
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: ImageIcon(AssetImage('assets/icon/logo.png')))),
          SizedBox(
            height: 40, // <-- SEE HERE
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    ChallengePage();
    return Scaffold(
      backgroundColor: kHighContrast,
      body: Padding(
        padding: k20dp.symmetric(horizontal: true),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              ...kLargeDivider,
              _buildLogo(),
              MenuButton('Create room', onTap: _byOpenCreateRoomPage),
              kTransparentDivider,
              MenuButton('Join room', onTap: _byOpenServerListPage),
              kTransparentDivider,
              MenuButton('Set your name', onTap: _byOpenEditProfilePage),
              kTransparentDivider,
              MenuButton('Memory', onTap: _memGame),
              kTransparentDivider,
              MenuButton('B-Slider', onTap: _slid),
              kTransparentDivider,
              MenuButton('Math', onTap: _mathGame),
              ...kLargeDivider,
            ],
          ),
        ),
      ),
    );
  }
}
