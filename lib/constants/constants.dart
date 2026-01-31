import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radiostream/helper/navigator_helper.dart';

class MyConstants extends InheritedWidget {
  static MyConstants? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MyConstants>();

  const MyConstants({required super.child, super.key});

  /// The list of stream https source names and links
  final Map<String, String> radioStreamHttps = const {
    'The Canalside Radio': 'https://das-edge63-live365-dal03.cdnstream.com/a62767',
  };

  final Map<String, String> radioStreamImages = const {
    'The Canalside Radio': '',
  };

  /// The list of items in the top menu bar
  final Map<dynamic, String> menuTitles = const {
    MenuNavigation.settings: 'Settings',
  };

  /// The list of android icons in the top menu bar
  final Map<dynamic, IconData> menuTitleAndroidIcons = const {
    MenuNavigation.settings: Icons.settings_outlined,
  };

  /// The list of ios icons in the top menu bar
  final Map<dynamic, IconData> menuTitleIosIcons = const {
    MenuNavigation.settings: CupertinoIcons.settings,
  };

  /// list of radio streams for schedule
  final Map<String, int> scheduleStream = const {
    'Prasanthi Stream': 1,
    // 'Africa Stream': 3,
    // 'America Stream': 2,
    'Discourse Stream': 6,
    'Telugu Stream': 5,
  };

  /// list of audio archive images with names
  final Map<String, String> audioArchive = const {

  };

  /// list of audio archive names and fids
  final Map<String, String> audioArchiveFids = const {
    'first':
        '5965,5967,6223,6737,6738,6876,6879,7006,7159,7161,7163,7165,7327,7461,7644,7646,25601,25602,25605,25628,25629,25630,25631,25633,25634,25635,25636,25714,26164,26166,26187,26188,26190,26217,26219,26231,26248,26459,26581,26715,27010,27301,27575,27576,27929,27974,5963,5964,5966,5968,5969,6096,6097,6098,6099,6101,6102,6103,6174,6175,6176,6177,6217,6218,6219,6220,6221,6222,6739,6740,6741,6742,6743,6822,6823,6824,6825,6826,6827,6872,6873,6874,6875,6877,6878,7003,7004,7005,7007,7008,7009,7010,7084,7085,7086,7087,7088,7157,7158,7160,7162,7164,7166,7324,7325,7326,7328,7329,7330,7400,7401,7402,7403,7459,7460,7462,7463,7464,7465,7466,7645,7647,7648,7782,7783,7876,7918,8049,10775,10776,10777,10778,10779,17550,17551,27532,27533,27534,27535,27536,27537,27538,27539,27540',
    'second':
        '11352,11353,11354,11355,22376,22417,22418,22432,22433,22434,22435,22469,22470,22471,22495,22496,22497,22498,22499,22500,22501,22502,22518,22519,22520,22521,22522,22523,22524,22543,22544,22545,22546,22547,22568,22569,22570,22571,22572,22573,26328,26329,26330,26331,26332,26333',
  };

  /// list of audio archive names and links
  final Map<String, String> audioArchiveLink = const {
    // TODO: these won't be supported in the future, have to remove
  };

  /// list of audio archive names and search parameters
  final Map<String, String> audioArchiveSearch = const {

  };

  /// list of app themes
  // Note: don't change or move the values
  final List<String> appThemes = const [
    'Light',
    'Dark',
    'System default',
  ];

  @override
  bool updateShouldNotify(MyConstants oldWidget) => false;
}
