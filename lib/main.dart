import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as iccp;
import 'package:provider/provider.dart';
import 'package:radiostream/audio_service/service_locator.dart';
import 'package:radiostream/bloc/internet_status.dart';
import 'package:radiostream/bloc/media/media_screen_bloc.dart';
import 'package:radiostream/bloc/radio/radio_index_bloc.dart';
import 'package:radiostream/bloc/radio/radio_loading_bloc.dart';
import 'package:radiostream/bloc/settings/app_theme_bloc.dart';
import 'package:radiostream/bloc/settings/initial_radio_index_bloc.dart';
import 'package:radiostream/constants/constants.dart';
import 'package:radiostream/helper/download_helper.dart';
import 'package:radiostream/helper/navigator_helper.dart';
import 'package:radiostream/screens/home.dart';
import 'package:radiostream/screens/media_player/media_player.dart';
import 'package:radiostream/screens/media_player/playing_queue.dart';
import 'package:radiostream/screens/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize flutter downloader
  // // TODO: change the debug to false later / remove
  // await FlutterDownloader.initialize(debug: false);

  // initialize the audio service
  await setupServiceLocator();

  runApp(MyConstants(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
  );

  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // providers for changing widgets using streams
    return MultiProvider(
      providers: [
        // stream for Canalside Radio stream index
        Provider<RadioIndexBloc>(
          create: (_) => RadioIndexBloc(),
          dispose: (_, RadioIndexBloc radioIndexBloc) =>
              radioIndexBloc.dispose(),
        ),
        // stream for radio loading state
        Provider<RadioLoadingBloc>(
          create: (_) => RadioLoadingBloc(),
          dispose: (_, RadioLoadingBloc radioLoadingBloc) =>
              radioLoadingBloc.dispose(),
        ),
        // stream for internet connectivity status
        StreamProvider<iccp.InternetStatus>(
          initialData: iccp.InternetStatus.connected,
          create: (context) {
            return getIt<InternetStatus>().internetStatusStreamController.stream;
          },
        ),
        // stream for initial Canalside Radio stream index
        Provider<InitialRadioIndexBloc>(
          create: (_) => InitialRadioIndexBloc(),
          dispose: (_, InitialRadioIndexBloc initialRadioIndexBloc) =>
              initialRadioIndexBloc.dispose(),
        ),
        // stream for app theme
        Provider<AppThemeBloc>(
          create: (_) => AppThemeBloc(),
          dispose: (_, AppThemeBloc appThemeBloc) => appThemeBloc.dispose(),
        ),
        // stream for media screen updates
        Provider<MediaScreenBloc>(
          // updates the media screen based on download state
          // calling from download helper is a must
          create: (_) => DownloadHelper.getMediaScreenBloc(),
          dispose: (_, MediaScreenBloc mediaScreenBloc) =>
              mediaScreenBloc.dispose(),
        ),
      ],
      child: Consumer<AppThemeBloc>(
          // listen to change of app theme
          builder: (context, appThemeBloc, child) {
        return StreamBuilder<String?>(
            stream: appThemeBloc.appThemeStream as Stream<String?>?,
            builder: (context, snapshot) {
              String appTheme =
                  snapshot.data ?? MyConstants.of(context)!.appThemes[2];

              bool isSystemDefault =
                  appTheme == MyConstants.of(context)!.appThemes[2];
              bool isDarkTheme =
                  appTheme == MyConstants.of(context)!.appThemes[1];

              return MaterialApp(
                title: 'The Canalside Radio',
                debugShowCheckedModeBanner: false,
                themeMode: isSystemDefault
                    ? ThemeMode.system
                    : (isDarkTheme ? ThemeMode.dark : ThemeMode.light),
                theme: lightTheme,
                darkTheme: darkTheme,
                home: const Home(),
                navigatorKey: getIt<NavigationService>().navigatorKey,
                routes: {
                  MediaPlayer.route: (context) => const MediaPlayer(),
                  PlayingQueue.route: (context) => const PlayingQueue(),
                  Settings.route: (context) => const Settings(),
                },
              );
            });
      }),
    );
  }
}
