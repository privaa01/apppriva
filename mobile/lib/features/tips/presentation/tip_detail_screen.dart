import 'package:flutter/material.dart';

import '../../account/application/account_controller.dart';
import '../data/tips_repository.dart';
import 'tips_page.dart';

class TipDetailScreen extends StatelessWidget {
  const TipDetailScreen({
    super.key,
    required this.account,
    required this.repository,
    required this.categoryId,
    this.observer,
  });
  final AccountController account;
  final TipsRepository repository;
  final String categoryId;
  final RouteObserver<PageRoute<dynamic>>? observer;
  @override
  Widget build(BuildContext context) => TipsPage(
    account: account,
    repository: repository,
    categoryId: categoryId,
    observer: observer,
  );
}
