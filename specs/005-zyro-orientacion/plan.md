# Implementation Plan: F05 — Asistente Zyro local

## Resumen

Implementar P07 como una conversación guiada y determinista dentro de Flutter. Las
respuestas aprobadas viajan con la aplicación, funcionan sin conexión y los mensajes
solo viven en memoria mientras la pantalla está abierta. No se incorpora Firebase,
proveedor generativo, historial, analítica ni nuevas dependencias.

## Contexto técnico

- Flutter 3.47.8 y Dart 3.13.7.
- Android API 24 o posterior.
- Navegación y sesión existentes mediante `AccountRouter` y `AccountScaffold`.
- Contenido local en `LocalZyroGuide`; presentación en `ZyroScreen`.
- Activo visual existente `assets/images/zyro/zyro.png`.
- Pruebas unitarias y de widgets con `flutter_test`; análisis con `dart analyze`.

## Constitución y puertas de calidad

- Minimización: cero persistencia y cero transmisión de consultas.
- Seguridad: no solicita secretos, rechaza acceso indebido y no valida enlaces.
- Verificabilidad: toda respuesta admitida tiene pruebas deterministas.
- Accesibilidad: etiquetas semánticas, controles táctiles y teclado visibles.
- Arquitectura: se reutilizan tema, rutas, guardas y navegación existentes.
- Dependencias: no se agrega ningún paquete ni servicio.

## Estructura

```text
mobile/lib/features/zyro/
├── data/local_zyro_guide.dart
└── presentation/zyro_screen.dart

mobile/test/features/zyro/
├── local_zyro_guide_test.dart
└── zyro_screen_test.dart

specs/005-zyro-orientacion/
├── contracts/zyro-local.md
├── data-model.md
├── plan.md
├── quickstart.md
├── research.md
└── tasks.md
```

## Fases

1. Cerrar alcance y contrato de respuestas locales.
2. Habilitar P07 y su acceso autenticado en la navegación.
3. Implementar motor local, avisos, límites y pantalla adaptable.
4. Automatizar pruebas de contenido, privacidad, navegación y accesibilidad.
5. Validar en Motorola G22/Android 12, modo avión, teclado y 20 respuestas.
6. Registrar evidencia, actualizar tareas y cerrar F05.

## Riesgos y mitigaciones

- Coincidencias ambiguas: temas pequeños, normalización y pruebas por frase.
- Pasos desactualizados de plataformas: no se muestran hasta aprobar fuentes.
- Expectativa de IA: etiqueta «Asistente Zyro» y explicación de orientación local.
- Exposición de secretos: aviso permanente y respuesta específica ante credenciales.

