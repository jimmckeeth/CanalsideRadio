import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radiostream/audio_service/service_locator.dart';
import 'package:radiostream/bloc/internet_status.dart';
import 'package:radiostream/helper/scaffold_helper.dart';
import 'package:radiostream/screens/radio/radio_home.dart';
import 'package:radiostream/widgets/top_media_player.dart';
import 'package:radiostream/widgets/top_menu.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // lock orientation to portrait (later maybe can handle landscape?)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // setting back to original form after dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-detect internet connectivity when app returns from background
      getIt<InternetStatus>().checkConnection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // scaffold key for whole app to show snackbar
      key: getIt<ScaffoldHelper>().scaffoldKey,
      body: const Stack(
        children: [
          RadioHome(),
          TopMenu(),
          TopMediaPlayer(),
        ],
      ),
    );
  }
}
