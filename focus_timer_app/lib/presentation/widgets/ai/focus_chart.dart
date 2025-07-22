import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class FocusChart extends StatefulWidget {
  final List<double> data;
  final List<String> labels;
  final String title;

  const FocusChart({
    super.key,
    required this.data,
    required this.labels,
    required this.title,
  });

  @override
  State<FocusChart> createState() => _FocusChartState();
}

class _FocusChartState extends State<FocusChart> {
  int? tappedIndex;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final labels = widget.labels;
    final title = widget.title;
    if (data.isEmpty) {
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
                  Icons.show_chart,
                  color: AppColors.aiPrimaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'データがありません',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: AppColors.textColor.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);

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
                Icons.show_chart,
                color: AppColors.aiPrimaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: GestureDetector(
              onTapUp: (details) {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  final local = box.globalToLocal(details.globalPosition);
                  final width = box.size.width;
                  final height = box.size.height - 40;
                  final stepX = width / (data.length - 1);
                  for (int i = 0; i < data.length; i++) {
                    final x = i * stepX;
                    final normalizedValue = (data[i] - minValue) / (maxValue - minValue);
                    final y = height - (normalizedValue * height);
                    final dx = (local.dx - x).abs();
                    final dy = (local.dy - y).abs();
                    if (dx < 16 && dy < 16) {
                      setState(() {
                        tappedIndex = i;
                      });
                      return;
                    }
                  }
                  setState(() {
                    tappedIndex = null;
                  });
                }
              },
              child: CustomPaint(
                size: const Size(double.infinity, 220),
                painter: ChartPainter(
                  data: data,
                  labels: labels,
                  maxValue: maxValue,
                  minValue: minValue,
                  color: AppColors.aiPrimaryColor,
                  tappedIndex: tappedIndex,
                  context: context,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double maxValue;
  final double minValue;
  final Color color;
  final int? tappedIndex;
  final BuildContext context;

  ChartPainter({
    required this.data,
    required this.labels,
    required this.maxValue,
    required this.minValue,
    required this.color,
    required this.tappedIndex,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;



    final path = Path();
    final fillPath = Path();

    final width = size.width;
    final height = size.height - 40; // ラベル用のスペース
    final stepX = width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = (data[i] - minValue) / (maxValue - minValue);
      final y = height - (normalizedValue * height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // データポイントを描画
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = color);

      // タップされたデータポイントの値をバルーン表示
      if (tappedIndex == i) {
        final percent = (data[i] * 100).toStringAsFixed(1);
        final textSpan = TextSpan(
          text: '$percent%',
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.aiPrimaryColor,
            backgroundColor: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final balloonWidth = textPainter.width + 16;
        final balloonHeight = textPainter.height + 8;
        final balloonRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, y - 28),
            width: balloonWidth,
            height: balloonHeight,
          ),
          const Radius.circular(8),
        );
        canvas.drawRRect(
          balloonRect,
          Paint()..color = Colors.white..style = PaintingStyle.fill,
        );
        canvas.drawRRect(
          balloonRect,
          Paint()..color = AppColors.aiPrimaryColor.withOpacity(0.2)..style = PaintingStyle.stroke..strokeWidth = 2,
        );
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, y - 28 - textPainter.height / 2 + 4),
        );
      }

      // ラベルを描画
      if (i < labels.length) {
        final textSpan = TextSpan(
          text: labels[i],
          style: GoogleFonts.notoSans(
            fontSize: 12,
            color: AppColors.textColor,
            fontWeight: tappedIndex == i ? FontWeight.bold : FontWeight.normal,
            backgroundColor: tappedIndex == i ? AppColors.aiPrimaryColor.withOpacity(0.08) : null,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, height + 10),
        );
      }
    }

    // グラフの線を描画
    canvas.drawPath(path, paint);

    // 塗りつぶしを描画
    fillPath.lineTo(width, height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 