import 'package:flutter/material.dart';

import '../data/account_models.dart';

Future<void> showTreatmentPolicy(
  BuildContext context,
  TreatmentPolicy policy,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    scrollable: true,
    title: const Text('Política de tratamiento'),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (policy.isTest)
          const Text(
            'Documento de prueba. Usa únicamente datos ficticios.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        Text('Versión ${policy.version}'),
        const SizedBox(height: 12),
        Text(policy.body),
        const SizedBox(height: 12),
        const Text(
          'Finalidades',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (final purpose in policy.purposes)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('• $purpose'),
          ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Entendido'),
      ),
    ],
  ),
);
