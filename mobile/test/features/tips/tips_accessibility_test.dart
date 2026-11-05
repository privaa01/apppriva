import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priva_mobile/app/priva_app.dart';
import 'package:priva_mobile/features/account/application/account_controller.dart';
import 'package:priva_mobile/features/tips/data/tip_content.dart';

import '../account/ui_test_repository.dart';
import 'tips_test_fixtures.dart';

void main() {
  setUpAll(() async {
    final root =
        Platform.environment['PRIVA_FLUTTER_ROOT'] ??
        Platform.environment['FLUTTER_ROOT'];
    if (root == null) return;
    final fonts = '$root/bin/cache/artifacts/material_fonts';
    final text = FontLoader('Roboto');
    for (final file in ['Roboto-Regular.ttf', 'Roboto-Bold.ttf']) {
      text.addFont(
        File('$fonts/$file').readAsBytes().then((b) => ByteData.sublistView(b)),
      );
    }
    await text.load();
    await (FontLoader('MaterialIcons')..addFont(
          File('$fonts/MaterialIcons-Regular.otf')
              .readAsBytes()
              .then((b) => ByteData.sublistView(b)),
        ))
        .load();
  });
  for (final size in [const Size(320, 720), const Size(412, 915)]) {
    for (final scale in [1.0, 2.0]) {
      for (final id in [null, ...TipContent.ids]) {
        testWidgets(
          'F04-A11Y $id ${size.width} text $scale no clipping and labeled controls',
          (tester) async {
            tester.view.devicePixelRatio = 3;
            tester.view.physicalSize = size * 3;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);
            final semantics = tester.ensureSemantics();
            try {
              final accounts = UiTestRepository();
              final account = AccountController(accounts);
              await account.initialize();
              final root = GlobalKey();
              final tips = TestTipsRepository();
              await tester.pumpWidget(
                RepaintBoundary(
                  key: root,
                  child: PrivaApp(
                    controller: account,
                    tipsRepository: tips,
                    initialRoute: id == null ? '/tips' : '/tips/$id',
                    builder: (context, child) => MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(scale)),
                      child: child!,
                    ),
                  ),
                ),
              );
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);
              expect(find.byType(TextField), findsNothing);
              if (id == null) {
                expect(
                  find.bySemanticsLabel('Ver más: Contraseñas seguras'),
                  findsOneWidget,
                );
              } else {
                final action = find.byKey(Key('tips.example.$id'));
                await tester.scrollUntilVisible(
                  action,
                  120,
                  scrollable: find.byType(Scrollable).first,
                  maxScrolls: 100,
                );
                await tester.ensureVisible(action);
                await tester.tap(action);
                await tester.pumpAndSettle();
                expect(
                  find.text(
                    tips.tips
                        .singleWhere((t) => t.categoryId == id)
                        .explanation,
                  ),
                  findsOneWidget,
                );
                expect(
                  find.bySemanticsLabel(
                    'Ver ejemplo: ${TipContent.catalogTitles[id]}',
                  ),
                  findsOneWidget,
                );
                if (id == 'passwords') {
                  final eye = find.byKey(const Key('tips.password.toggle'));
                  await tester.ensureVisible(eye);
                  await tester.tap(eye);
                  await tester.pumpAndSettle();
                  expect(find.text('Sol!Camina27_Luna'), findsOneWidget);
                }
              }
              expect(tester.takeException(), isNull);
              if (size.width == 412 && scale == 1) {
                final scroll = find.byType(Scrollable).first;
                await tester.drag(scroll, const Offset(0, 3000));
                await tester.pumpAndSettle();
                await tester.runAsync(() async {
                  final image =
                      await (root.currentContext!.findRenderObject()!
                              as RenderRepaintBoundary)
                          .toImage();
                  final data = await image.toByteData(
                    format: ui.ImageByteFormat.png,
                  );
                  await File('/tmp/priva-f04-${id ?? 'catalog'}.png')
                      .writeAsBytes(data!.buffer.asUint8List());
                  image.dispose();
                });
              }
              await expectLater(
                tester,
                meetsGuideline(androidTapTargetGuideline),
              );
              await expectLater(
                tester,
                meetsGuideline(labeledTapTargetGuideline),
              );
              await expectLater(tester, meetsGuideline(textContrastGuideline));
              await tester.pumpWidget(const SizedBox());
              account.dispose();
              await accounts.changes.close();
            } finally {
              semantics.dispose();
            }
          },
        );
      }
    }
  }
}
