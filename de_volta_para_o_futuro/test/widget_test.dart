import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:de_volta_para_o_futuro/main.dart';
import 'package:de_volta_para_o_futuro/modelos.dart';

void main() {
  testWidgets('Carrega JSON e navega pelas quatro seções', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const Aplicativo());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
    expect(find.text('Sinopse'), findsOneWidget);
    for (final titulo in ['Enredo', 'Elenco', 'Detalhes', 'Curiosidades']) {
      await tester.ensureVisible(find.text(titulo));
      await tester.tap(find.text(titulo));
      await tester.pumpAndSettle();
      if (titulo == 'Elenco') {
        expect(find.text('Crispin Glover'), findsOneWidget);
        await tester.scrollUntilVisible(find.text('Billy Zane'), 250);
        expect(find.text('Billy Zane'), findsOneWidget);
      } else {
        final tela = tester.widget<TelaConteudo>(find.byType(TelaConteudo));
        expect(tela.secao.titulo, titulo);
        expect(find.text(tela.secao.itens.first.titulo), findsOneWidget);
        await tester.scrollUntilVisible(
            find.text(tela.secao.itens.last.titulo), 250);
      }
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Telas cabem em celular estreito com texto ampliado',
      (tester) async {
    final filme = Filme.fromJson(jsonDecode(
      File('assets/dados/filme.json').readAsStringSync(),
    ));
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final telas = <Widget>[
      TelaInicio(filme: filme),
      TelaElenco(filme: filme),
      ...filme.secoes
          .where((s) => s.id != 'elenco')
          .map((s) => TelaConteudo(secao: s)),
    ];
    for (final tela in telas) {
      await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: tela,
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
