import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:research_buddy/providers/progress_provider.dart';

class ProgressOverlay extends ConsumerWidget {
  final bool loading;
  final Widget? child;

  const ProgressOverlay({Key? key, this.child, this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final childWidget = child;

    return Stack(
      children: [
        if (childWidget != null) childWidget,
        if (progress || loading)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor.withAlpha(127),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
