import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold(
      {super.key, required this.body, this.appBar, this.bottomNavigationBar});

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final surfaceVariant = theme.colorScheme.surfaceVariant;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        key: const ValueKey('GradientScaffold'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [surfaceVariant, surface],
            stops: const [.2, 1],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar,
          body: body,
        ),
      ),
    );
  }
}