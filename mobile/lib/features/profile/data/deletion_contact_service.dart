import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const supportEmail = 'priva202611@gmail.com';
Uri get deletionRequestUri {
  final values = {
    'subject': 'Solicitud de eliminación de datos de Priva',
    'body':
        'Hola, equipo de Priva. Quiero solicitar la eliminación de mis datos. '
        'Por favor, indíquenme el procedimiento y el alcance aplicable.',
  };
  return Uri(
    scheme: 'mailto',
    path: supportEmail,
    query: values.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&'),
  );
}

abstract interface class DeletionContactService {
  Future<bool> openDraft();
  Future<bool> copyAddress();
}

class PlatformDeletionContactService implements DeletionContactService {
  PlatformDeletionContactService({
    Future<bool> Function(Uri)? launch,
    Future<void> Function(String)? copy,
    this.timeout = const Duration(seconds: 15),
  }) : _launch =
           launch ??
           ((uri) => launchUrl(uri, mode: LaunchMode.externalApplication)),
       _copy =
           copy ?? ((value) => Clipboard.setData(ClipboardData(text: value)));
  final Future<bool> Function(Uri) _launch;
  final Future<void> Function(String) _copy;
  final Duration timeout;
  @override
  Future<bool> openDraft() async {
    try {
      return await _launch(deletionRequestUri).timeout(timeout);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> copyAddress() async {
    try {
      await _copy(supportEmail).timeout(timeout);
      return true;
    } catch (_) {
      return false;
    }
  }
}
