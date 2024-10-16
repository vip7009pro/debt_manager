import 'package:debt_manager/pages/stocks/stock_screen.dart';
import 'package:debt_manager/pages/stocks/warehouse_input_screen.dart';
import 'package:debt_manager/pages/stocks/warehouse_output_screen.dart';
import 'package:flutter/material.dart';

class WarehouseTabScreen extends StatelessWidget {
  const WarehouseTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Warehouse'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: TabBar(              
              tabs: [
                Tab(text: 'Stock'),
                Tab(text: 'Input'),
                Tab(text: 'Output'),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: StockScreen()),
            Center(child: WarehouseInputScreen()),
            Center(child: WarehouseOutputScreen()),
          ],
        ),
      ),
    );
  }
}