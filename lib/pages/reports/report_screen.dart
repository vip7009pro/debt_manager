import 'package:flutter/material.dart';
import 'package:debt_manager/pages/reports/po_trend.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({ Key? key }) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // Add sample data for the chart
  final List<POTrendData> sampleData = [
    POTrendData(
      date: DateTime.now().subtract(const Duration(days: 4)),
      quantity: 100,
      amount: 1000,
    ),
    POTrendData(
      date: DateTime.now().subtract(const Duration(days: 3)),
      quantity: 150,
      amount: 1500,
    ),
    POTrendData(
      date: DateTime.now().subtract(const Duration(days: 2)),
      quantity: 80,
      amount: 800,
    ),
    POTrendData(
      date: DateTime.now().subtract(const Duration(days: 1)),
      quantity: 200,
      amount: 2000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          POTrendChart(trendData: sampleData),
          const SizedBox(height: 16),
          // Additional report items can be added here
          Card(
            child: ListTile(
              title: const Text('Report Item 1'),
              subtitle: const Text('Details about report item 1'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle tap
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Report Item 2'),
              subtitle: const Text('Details about report item 2'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle tap
              },
            ),
          ),
        ],
      ),
    );
  }
}