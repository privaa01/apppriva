# Baseline F04 — 2026-11-05

Checkout sincronizado por fast-forward con origin/work:31ee98f. No había cambios
locales de usuario. En ese momento las modificaciones eran la revisión editorial;
después se añadió la migración al asset incluido en la APK.

- Flutter oficial3.47.8, framework737ba8f885dc774b53b442759999a312c9461e4e;
  enginecf636b1dfb818dd6a3ff16e390e93b1a036969c8; Dart3.13.7.
- `flutter pub get --enforce-lockfile`: satisfactorio, sin modificar manifiestos/lockfile.
- `flutter analyze --fatal-infos`: satisfactorio,0 diagnósticos,10.2s.
- `flutter test --no-pub`:135 pruebas satisfactorias,0 fallidas,20s.
- Firebase:17/17 pruebas de reglas satisfactorias en la restauración inmediatamente
  anterior de esta instancia; no son pruebas de reglas Tips ni una ejecución nueva.

Esta ejecución corresponde al baseline previo a código F04. No acredita todavía
nuevas pantallas, contenido F04, TalkBack, participantes ni la matriz Android.
Registros temporales de esta ejecución: `/tmp/priva-f04-baseline-tests.log` y
`/tmp/priva-f04-baseline-analyze.log`; recuento y estados tomados de la salida final,
no de resultados históricos de la documentación.
