import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrixmeds/services/api_service.dart';
import 'package:matrixmeds/widgets/drug_input.dart';
import 'package:matrixmeds/widgets/interaction_card.dart';
import 'package:matrixmeds/services/auth_service.dart';

class CheckInteractionPage extends ConsumerStatefulWidget {
  const CheckInteractionPage({super.key});

  @override
  ConsumerState<CheckInteractionPage> createState() => _CheckInteractionPageState();
}

class _CheckInteractionPageState extends ConsumerState<CheckInteractionPage> {
  final _formKey = GlobalKey<FormState>();
  String _drugA = '';
  String _drugB = '';
  AsyncValue<Map<String, dynamic>?>? _result;

  Future<void> _checkInteraction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _result = const AsyncValue.loading();
    });

    try {
      final result = await ref.read(apiServiceProvider).checkInteraction(
        drugA: _drugA,
        drugB: _drugB,
      );
      setState(() {
        _result = AsyncValue.data(result);
      });
    } catch (e) {
      setState(() {
        _result = AsyncValue.error(e, StackTrace.current);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Drug Interaction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DrugInput(
                label: 'Drug A',
                onChanged: (value) => _drugA = value,
              ),
              const SizedBox(height: 16),
              DrugInput(
                label: 'Drug B',
                onChanged: (value) => _drugB = value,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _checkInteraction,
                child: const Text('Check Interaction'),
              ),
              const SizedBox(height: 24),
              if (_result != null)
                Expanded(
                  child: _result!.when(
                    data: (data) {
                      if (data == null) return const SizedBox.shrink();
                      return InteractionCard(
                        interaction: data['interaction'] ?? false,
                        severity: data['severity'] ?? 'unknown',
                        notes: data['notes'] ?? '',
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error: $error'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
