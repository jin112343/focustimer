import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class ProductivityScore extends StatelessWidget {
  final double score;
  final double trend;

  const ProductivityScore({
    super.key,
    required this.score,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor(score);
    final trendIcon = _getTrendIcon(trend);
    final trendColor = _getTrendColor(trend);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics,
                color: AppColors.aiPrimaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '今週の生産性スコア',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${score.toInt()}',
                style: GoogleFonts.robotoMono(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '点',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        trendIcon,
                        size: 16,
                        color: trendColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${trend >= 0 ? '+' : ''}${trend.toInt()}点 先週比',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: AppColors.textColor.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            _getScoreDescription(score),
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppColors.textColor.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.successColor;
    if (score >= 60) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  IconData _getTrendIcon(double trend) {
    if (trend > 0) return Icons.trending_up;
    if (trend < 0) return Icons.trending_down;
    return Icons.trending_flat;
  }

  Color _getTrendColor(double trend) {
    if (trend > 0) return AppColors.successColor;
    if (trend < 0) return AppColors.errorColor;
    return AppColors.textColor.withValues(alpha: 0.5);
  }

  String _getScoreDescription(double score) {
    if (score >= 90) return '優秀！最高レベルの生産性です';
    if (score >= 80) return '良好！高い生産性を維持しています';
    if (score >= 70) return '良好！改善の余地があります';
    if (score >= 60) return '普通！さらなる向上を目指しましょう';
    if (score >= 50) return '要改善！集中力を高める必要があります';
    return '要努力！基本的な改善から始めましょう';
  }
} 