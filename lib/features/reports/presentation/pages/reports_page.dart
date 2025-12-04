import 'package:flutter/material.dart';
import 'dart:math' as math;

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedPeriod = '24 hrs usage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A5A5A), // Gris oscuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A5A5A), // Gris oscuro
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Reportes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card principal blanco
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coffee Used in Last 24 Hours
                  const Text(
                    'Café usado en las últimas 24 hrs',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '1.13kg',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '↑ + 12%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Reduction in Daily Usage
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A2C1A), // Marrón oscuro
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '340g ahorrados de desperdicio',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Circular Gauge Chart
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Gauge semicircular
                          CustomPaint(
                            size: const Size(200, 200),
                            painter: _GaugePainter(),
                          ),
                          // Texto en el centro
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '80%',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Recetas aprobadas usadas',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5A5A5A),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Usage by Origin
                  const Text(
                    'Uso por origen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _OriginItem(
                    color: const Color(0xFF4A2C1A),
                    origin: 'Guatemala',
                    quantity: '123g',
                  ),
                  const SizedBox(height: 8),
                  _OriginItem(
                    color: const Color(0xFF6B4423),
                    origin: 'Etiopía',
                    quantity: '105g',
                  ),
                  const SizedBox(height: 8),
                  _OriginItem(
                    color: const Color(0xFF8B5A3C),
                    origin: 'Colombia',
                    quantity: '104g',
                  ),
                  const SizedBox(height: 32),
                  // Time of Day Usage
                  const Text(
                    'Uso por hora del día',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _OriginItem(
                    color: Colors.black,
                    origin: 'Mañana',
                    quantity: '400g',
                  ),
                  const SizedBox(height: 8),
                  _OriginItem(
                    color: const Color(0xFF9E9E9E),
                    origin: 'Tarde',
                    quantity: '200g',
                  ),
                ],
              ),
            ),
            // Selector de período
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PeriodButton(
                    label: '24 hrs uso',
                    isSelected: _selectedPeriod == '24 hrs usage',
                    onTap: () {
                      setState(() {
                        _selectedPeriod = '24 hrs usage';
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _PeriodButton(
                    label: 'Uso semanal',
                    isSelected: _selectedPeriod == 'week usage',
                    onTap: () {
                      setState(() {
                        _selectedPeriod = 'week usage';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Arco marrón oscuro (0-120)
    paint.color = const Color(0xFF4A2C1A);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * 0.3,
      false,
      paint,
    );

    // Arco negro (120-180)
    paint.color = Colors.black;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.3,
      math.pi * 0.2,
      false,
      paint,
    );

    // Arco gris claro (180-240)
    paint.color = const Color(0xFF9E9E9E);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.5,
      math.pi * 0.2,
      false,
      paint,
    );

    // Arco marrón oscuro (240-300)
    paint.color = const Color(0xFF4A2C1A);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.7,
      math.pi * 0.2,
      false,
      paint,
    );

    // Marcas de escala
    final scalePaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 2;

    for (int i = 0; i <= 4; i++) {
      final angle = math.pi + (math.pi * i / 4);
      final startX = center.dx + (radius - 10) * math.cos(angle);
      final startY = center.dy + (radius - 10) * math.sin(angle);
      final endX = center.dx + (radius + 10) * math.cos(angle);
      final endY = center.dy + (radius + 10) * math.sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        scalePaint,
      );

      // Números de escala
      final textPainter = TextPainter(
        text: TextSpan(
          text: (i * 100).toString(),
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF5A5A5A),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx + (radius - 30) * math.cos(angle) - textPainter.width / 2,
          center.dy + (radius - 30) * math.sin(angle) - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OriginItem extends StatelessWidget {
  final Color color;
  final String origin;
  final String quantity;

  const _OriginItem({
    required this.color,
    required this.origin,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$origin - $quantity',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFF9E9E9E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 16,
              ),
            if (isSelected) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

