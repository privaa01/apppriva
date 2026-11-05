import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../data/tips_repository.dart';
import 'tips_page.dart';

class TipsCatalogScreen extends StatelessWidget {
  const TipsCatalogScreen({
    super.key,
    required this.account,
    required this.repository,
    this.observer,
  });
  final AccountController account;
  final TipsRepository repository;
  final RouteObserver<PageRoute<dynamic>>? observer;
  @override
  Widget build(BuildContext context) =>
      TipsPage(account: account, repository: repository, observer: observer);
}
