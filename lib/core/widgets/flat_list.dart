import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Liste à plat v2, pleine largeur : surface, filet en haut et en bas, filet
/// entre les lignes. Remplace les cartes empilées.
class FlatList extends StatelessWidget {
  /// Crée la liste.
  const FlatList({required this.children, super.key});

  /// Lignes de la liste.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final divider = BorderSide(color: colors.border);
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border(top: divider, bottom: divider),
      ),
      child: ColoredBox(
        color: colors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, child) in children.indexed)
              DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  border: i == children.length - 1
                      ? null
                      : Border(bottom: divider),
                ),
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}
