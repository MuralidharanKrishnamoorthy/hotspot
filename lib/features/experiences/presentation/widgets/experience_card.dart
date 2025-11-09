import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../design_system/color_tokens.dart';

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String imageUrl;
  final bool selected;
  final VoidCallback onTap;

  static const List<double> _grayMatrix = <double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primaryAccent : AppColors.border1;
    final child = Stack(
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: selected
                ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                : const ColorFilter.matrix(_grayMatrix),
            child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
        ),
        // No explicit title overlay to mimic stamp card visuals
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: selected ? 104 : 96,
        height: selected ? 132 : 124,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: selected ? 1.4 : 1),
          color: AppColors.base2,
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: AppColors.primaryAccent,
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ]
              : const [],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
