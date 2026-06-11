import 'package:flutter/material.dart';
import 'package:mindflasher_4/services/logging/app_logger.dart';

class AdminLogScreen extends StatelessWidget {
  const AdminLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Logs'),
        actions: [
          IconButton(
            onPressed: () => AppLogger.instance.clear(),
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: AppLogger.instance,
        builder: (context, child) {
          final entries = AppLogger.instance.entries.reversed.toList();
          if (entries.isEmpty) {
            return const Center(
              child: Text('No logs recorded yet.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(entry.format()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}