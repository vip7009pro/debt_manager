import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class POTrendChart extends StatelessWidget {
  final List<POTrendData> trendData;

  const POTrendChart({Key? key, required this.trendData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'PO Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    // Quantity line
                    LineChartBarData(
                      spots: trendData
                          .map((data) => FlSpot(
                              data.date.millisecondsSinceEpoch.toDouble(),
                              data.quantity.toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Amount line
                    LineChartBarData(
                      spots: trendData
                          .map((data) => FlSpot(
                              data.date.millisecondsSinceEpoch.toDouble(),
                              data.amount))
                          .toList(),
                      isCurved: true,
                      color: Colors.red,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt());
                          return Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Quantity', Colors.blue),
                const SizedBox(width: 20),
                _buildLegendItem('Amount', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

class POTrendData {
  final DateTime date;
  final int quantity;
  final double amount;

  POTrendData({
    required this.date,
    required this.quantity,
    required this.amount,
  });
}
