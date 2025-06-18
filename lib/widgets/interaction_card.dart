import 'package:flutter/material.dart';

class InteractionCard extends StatelessWidget {
  final bool interaction;
  final String severity;
  final String notes;

  const InteractionCard({
    super.key,
    required this.interaction,
    required this.severity,
    required this.notes,
  });

  IconData _getSeverityIcon() {
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

  Color _getSeverityColor() {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  interaction ? Icons.warning : Icons.check_circle,
                  color: interaction ? Colors.red : Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    interaction ? 'Interaction Found' : 'No Interaction Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: interaction ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (interaction)
              Row(
                children: [
                  Icon(
                    _getSeverityIcon(),
                    color: _getSeverityColor(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Severity: $severity',
                    style: TextStyle(
                      color: _getSeverityColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (notes.isNotEmpty)
              Text(
                notes,
                style: const TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}
