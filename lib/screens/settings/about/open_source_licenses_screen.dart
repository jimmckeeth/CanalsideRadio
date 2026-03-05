import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenSourceLicensesScreen extends StatelessWidget {
  const OpenSourceLicensesScreen({
    super.key,
    required this.appName,
    required this.appVersion,
  });

  final String appName;
  final String appVersion;

  Future<void> _urlLaunch(String urlString) async {
    try {
      if (await canLaunchUrl(Uri.parse(urlString))) {
        await launchUrl(Uri.parse(urlString));
      }
    } catch (e) {
      // do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open source licenses')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Source code'),
            subtitle: const Text('github.com/jimmckeeth/CanalsideRadio'),
            onTap: () =>
                _urlLaunch('https://github.com/jimmckeeth/CanalsideRadio'),
          ),
          const Divider(),
          ListTile(
            title: const Text('License'),
            subtitle: const Text('GNU General Public License v3'),
            onTap: () => _urlLaunch(
              'https://github.com/jimmckeeth/CanalsideRadio?tab=License-1-ov-file',
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Package licenses'),
            subtitle: const Text('Open source libraries used in this app'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: appName,
                applicationVersion: appVersion,
              );
            },
          ),
        ],
      ),
    );
  }
}
