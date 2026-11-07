import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('el asset coincide literalmente con el catálogo aprobado', () async {
    final document = jsonDecode(
      await rootBundle.loadString(
        'assets/content/result-recommendations-1.0.0.json',
      ),
    ) as Map<String, dynamic>;
    expect(document['contentVersion'], 'result-recommendations-es-CO-1.0.0');
    expect(document['status'], 'approved');
    expect(document['modules'], _approvedModules);
  });
}

const _approvedModules = <Map<String, Object>>[
  {
    'topic': 'passwords',
    'actions': [
      'Usa una contraseña distinta y extensa para cada servicio.',
      'Guarda tus claves en un gestor de contraseñas confiable y protegido.',
      'Cambia las credenciales filtradas y también donde las hayas reutilizado.',
    ],
  },
  {
    'topic': 'access',
    'actions': [
      'Activa la verificación en dos pasos en tus cuentas principales.',
      'Revisa dispositivos y aplicaciones con acceso, y retira los que no reconozcas.',
      'Conserva los códigos de recuperación en un lugar seguro y no los compartas.',
    ],
  },
  {
    'topic': 'networks',
    'actions': [
      'Evita ingresar a cuentas sensibles desde redes públicas; usa una conexión confiable.',
      'Protege el Wi-Fi y la administración del router con credenciales propias.',
      'Desactiva conexiones automáticas y funciones de proximidad cuando no las necesites.',
    ],
  },
  {
    'topic': 'phishing',
    'actions': [
      'Verifica remitentes, enlaces y solicitudes urgentes mediante un canal oficial.',
      'Nunca compartas contraseñas ni códigos de verificación por mensajes o llamadas.',
      'No abras archivos ni enlaces inesperados; reporta los intentos sospechosos.',
    ],
  },
  {
    'topic': 'devices',
    'actions': [
      'Mantén el sistema, las aplicaciones y las protecciones de seguridad actualizados.',
      'Instala software únicamente desde tiendas y sitios oficiales.',
      'Revisa permisos, extensiones y medios externos antes de permitirles acceso.',
    ],
  },
];
