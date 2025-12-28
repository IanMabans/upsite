import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

/// Password strength indicator bar.
///
/// Visual indicator showing password strength (0-4 levels).
/// Displays as 4 horizontal bars that fill based on strength.
class PasswordStrengthIndicator extends StatelessWidget {
  /// Password strength value (0-4)
  final int strength;

  /// Whether to show the strength label
  final bool showLabel;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bars
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: index < strength
                      ? _getStrengthColor(strength)
                      : AppColors.cardDarkLighter,
                ),
              ),
            );
          }),
        ),

        // Optional label
        if (showLabel && strength > 0) ...[
          const SizedBox(height: 6),
          Text(
            _getStrengthLabel(strength),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getStrengthColor(strength),
            ),
          ),
        ],
      ],
    );
  }

  /// Get color based on strength level.
  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return const Color(0xFF10B981); // emerald-500
      case 4:
        return const Color(0xFF10B981); // emerald-500
      default:
        return AppColors.cardDarkLighter;
    }
  }

  /// Get label based on strength level.
  String _getStrengthLabel(int strength) {
    switch (strength) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }
}
