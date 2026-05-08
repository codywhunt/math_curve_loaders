import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalLink(String url) async {
  final uri = Uri.parse(url);

  try {
    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (didLaunch) {
      return;
    }
  } on PlatformException {
    // Try the host OS below before falling back to copying the URL.
  } on MissingPluginException {
    // This can happen in a running macOS app after adding a plugin via hot reload.
  }

  if (await _openWithHostPlatform(url)) {
    return;
  }

  await Clipboard.setData(ClipboardData(text: url));
}

Future<bool> _openWithHostPlatform(String url) async {
  final command = switch (Platform.operatingSystem) {
    'macos' => ('/usr/bin/open', [url]),
    'linux' => ('xdg-open', [url]),
    'windows' => ('cmd', ['/c', 'start', '', url]),
    _ => null,
  };

  if (command == null) {
    return false;
  }

  try {
    final result = await Process.run(command.$1, command.$2, runInShell: true);
    return result.exitCode == 0;
  } on ProcessException {
    return false;
  }
}
