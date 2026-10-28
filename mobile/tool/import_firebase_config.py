#!/usr/bin/env python3
"""Import public Firebase Android/iOS app configuration; never service accounts."""
import argparse
import json
import pathlib
import plistlib
import sys

PROJECT_ID = 'priva-785cb'


def convert(source, package=None):
    if source.suffix.lower() == '.plist':
        with source.open('rb') as stream:
            data = plistlib.load(stream)
        if data.get('PROJECT_ID') != PROJECT_ID:
            raise ValueError('El archivo no pertenece al proyecto priva-785cb.')
        values = (data.get('API_KEY'), data.get('GOOGLE_APP_ID'),
                  data.get('GCM_SENDER_ID'))
        platform = 'ios'
    else:
        data = json.loads(source.read_text())
        if 'private_key' in data or data.get('type') == 'service_account':
            raise ValueError('No se aceptan cuentas de servicio ni claves privadas.')
        info = data.get('project_info', {})
        if info.get('project_id') != PROJECT_ID:
            raise ValueError('El archivo no pertenece al proyecto priva-785cb.')
        clients = data.get('client', [])
        if package:
            clients = [c for c in clients if c.get('client_info', {}).get(
                'android_client_info', {}).get('package_name') == package]
        if len(clients) != 1:
            raise ValueError('Selecciona un único cliente Android mediante --package.')
        client = clients[0]
        keys = client.get('api_key', [])
        if len(keys) != 1:
            raise ValueError('Se requiere una única API key pública de aplicación.')
        values = (keys[0].get('current_key'),
                  client.get('client_info', {}).get('mobilesdk_app_id'),
                  info.get('project_number'))
        platform = 'android'
    key, app_id, sender = values
    if not all(isinstance(v, str) and v.strip() for v in values):
        raise ValueError('Faltan identificadores públicos de aplicación.')
    parts = app_id.split(':')
    if len(parts) != 4 or parts[:3] != ['1', sender, platform] or not parts[3]:
        raise ValueError('El app ID no coincide con plataforma/remitente.')
    return platform, dict(FIREBASE_API_KEY=key, FIREBASE_APP_ID=app_id,
                         FIREBASE_PROJECT_ID=PROJECT_ID,
                         FIREBASE_MESSAGING_SENDER_ID=sender)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=pathlib.Path)
    parser.add_argument('--package', help='Seleccionar package Android si hay varios')
    args = parser.parse_args()
    try:
        platform, config = convert(args.source, args.package)
        target = pathlib.Path(__file__).resolve().parents[1] / 'config' / (
            f'firebase-{platform}.local.json')
        # Exclusive creation avoids overwriting existing environment settings.
        with target.open('x') as stream:
            stream.write(json.dumps(config, indent=2) + '\n')
        target.chmod(0o600)
        print(f'Configuración pública importada para {PROJECT_ID} ({platform}).')
        print(f'flutter run --dart-define-from-file=config/{target.name}')
        print('Esto no autentica CLI, despliega reglas ni valida el servicio real.')
    except (OSError, ValueError, KeyError, TypeError, plistlib.InvalidFileException):
        print('No se pudo importar. Comprueba proyecto, formato, cliente único y que '
              'no exista ya el archivo de destino. No uses cuentas de servicio.',
              file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
