import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrixmeds/services/api_service.dart';
import 'package:matrixmeds/services/auth_service.dart';

class CommonInteractionsPage extends ConsumerStatefulWidget {
  const CommonInteractionsPage({super.key});

  @override
  ConsumerState<CommonInteractionsPage> createState() => _CommonInteractionsPageState();
}

class _CommonInteractionsPageState extends ConsumerState<CommonInteractionsPage> {
  AsyncValue<List<Map<String, dynamic>>>? _interactions;
  String _selectedSeverity = 'all';

  @override
  void initState() {
    super.initState();
    _fetchInteractions();
  }

  Future<void> _fetchInteractions() async {
    setState(() {
      _interactions = const AsyncValue.loading();
    });

    try {
      final interactions = await ref.read(apiServiceProvider).getCommonInteractions();
      setState(() {
        _interactions = AsyncValue.data(interactions);
      });
    } catch (e) {
      setState(() {
        _interactions = AsyncValue.error(e, StackTrace.current);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Common Interactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Filter by severity:'),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedSeverity,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSeverity = value;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _interactions?.when(
              data: (interactions) {
                final filteredInteractions = _selectedSeverity == 'all'
                    ? interactions
                    : interactions.where((i) => i['severity'] == _selectedSeverity).toList();

                return ListView.builder(
                  itemCount: filteredInteractions.length,
                  itemBuilder: (context, index) {
                    final interaction = filteredInteractions[index];
                    return ListTile(
                      title: Text('${interaction['drug_a']} + ${interaction['drug_b']}'),
                      subtitle: Text('Severity: ${interaction['severity']}'),
                      trailing: Icon(
                        _getSeverityIcon(interaction['severity']),
                        color: _getSeverityColor(interaction['severity']),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ) ?? const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'high':
        return Icons.dangerous;
      case 'medium':
        return Icons.warning;
      case 'low':
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
