import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../states/auth_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String username = '';
  String password = '';
  String? error;
  final _formKey = GlobalKey<FormState>();
  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final user = await context.read<AuthState>().signin(username, password);
    if (user != null) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/polls', (_) => false);
      }
    } else {
      setState(() {
        error = 'Une erreur est survenue.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Identifiant'),
            onChanged: (value) => username = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            onChanged: (value) => password = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          if (error != null)
            Text(error!,
                style: theme.textTheme.labelMedium!
                    .copyWith(color: theme.colorScheme.error)),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Créer le compte'),
          ),
        ],
      ),
    );
  }
}
