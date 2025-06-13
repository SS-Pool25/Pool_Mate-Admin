import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets/sidebar.dart';
import '../services/dashboardService.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _storage = const FlutterSecureStorage();
  String? adminName;
  String quote = "Keep pushing forward! 🚀";

  Map<String, dynamic>? todayStats;
  Map<String, dynamic>? yesterdayStats;
  List<dynamic>? monthlyStats;
  List<dynamic>? yearlyStats;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminName();
    _loadStats();
  }

  Future<void> _loadAdminName() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      try {
        final decoded = JwtDecoder.decode(token);
        setState(() {
          adminName = decoded['name'] ?? 'Admin';
        });
      } catch (e) {
        setState(() {
          adminName = 'Admin';
        });
      }
    } else {
      setState(() {
        adminName = 'Admin';
      });
    }
  }

  Future<void> _loadStats() async {
    setState(() {
      loading = true;
    });

    final today = await DashboardService.fetchTodayStats();
    final yesterday = await DashboardService.fetchYesterdayStats();
    final monthly = await DashboardService.fetchMonthlyStats();
    final yearly = await DashboardService.fetchYearlyStats();

    setState(() {
      todayStats = today;
      yesterdayStats = yesterday;
      monthlyStats = monthly;
      yearlyStats = yearly;
      loading = false;
    });
    print(todayStats);
    print(yesterdayStats);
    print(monthlyStats);
    print(yearlyStats);

  }

  Widget buildBarChart(Map<String, dynamic>? data, String title) {
    if (data == null) return const SizedBox();

    final List<_RideData> chartData = [
      _RideData(
        'Demand',
        data['demandride_count']?['total'] ?? 0,
        data['demandride_count']?['completed'] ?? 0,
        data['demandride_count']?['cancelled'] ?? 0,
      ),
      _RideData(
        'Schedule',
        data['scheduleride_count']?['total'] ?? 0,
        data['scheduleride_count']?['completed'] ?? 0,
        data['scheduleride_count']?['cancelled'] ?? 0,
      ),
      _RideData(
        'Pool',
        data['poolride_count']?['total'] ?? 0,
        data['poolride_count']?['completed'] ?? 0,
        data['poolride_count']?['cancelled'] ?? 0,
      ),
    ];
    print(chartData.map((e) => '${e.type}: ${e.total}, ${e.completed}, ${e.cancelled}').toList());


    return SfCartesianChart(
      backgroundColor: const Color(0xFF2A2A3C),
      title: ChartTitle(
        text: title,
        textStyle: const TextStyle(color: Colors.white),
      ),
      legend: Legend(
        isVisible: true,
        textStyle: const TextStyle(color: Colors.white),
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(color: Colors.white70),
        axisLine: const AxisLine(color: Colors.white30),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: const TextStyle(color: Colors.white70),
        axisLine: const AxisLine(color: Colors.white30),
        majorGridLines: const MajorGridLines(color: Colors.white12),
      ),
      series: <CartesianSeries>[
        ColumnSeries<_RideData, String>(
          name: 'Total',
          dataSource: chartData,
          xValueMapper: (d, _) => d.type,
          yValueMapper: (d, _) => d.total,
          color: const Color(0xFF2196F3),
          spacing: 0.2, // spacing between grouped bars
          width: 0.2,
          dataLabelSettings: const DataLabelSettings(isVisible: true),// width of each bar
        ),
        ColumnSeries<_RideData, String>(
          name: 'Completed',
          dataSource: chartData,
          xValueMapper: (d, _) => d.type,
          yValueMapper: (d, _) => d.completed,
          color: const Color(0xFF4CAF50),
          spacing: 0.2,
          width: 0.2,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        ColumnSeries<_RideData, String>(
          name: 'Cancelled',
          dataSource: chartData,
          xValueMapper: (d, _) => d.type,
          yValueMapper: (d, _) => d.cancelled,
          color: const Color(0xFFF44336),
          spacing: 0.2,
          width: 0.2,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],

    );
  }

  Widget buildLineChart(List<dynamic>? data, String title) {
    if (data == null || data.isEmpty) return const SizedBox();

    final List<_TimeSeriesRide> chartData = data.map((d) {
      final date = DateTime.parse(d['date']);
      final label = title == "Monthly Stats"
          ? '${date.year}-${date.month.toString().padLeft(2, '0')}'
          : '${date.year}';
      return _TimeSeriesRide(
        label,
        d['demandride_count']?['total'] ?? 0,
        d['scheduleride_count']?['total'] ?? 0,
        d['poolride_count']?['total'] ?? 0,
      );
    }).toList();

    print("Parsed chart data:");
    chartData.forEach((d) => print('${d.label} => Demand: ${d.demandTotal}, Schedule: ${d.scheduleTotal}, Pool: ${d.poolTotal}'));

    return SfCartesianChart(
      backgroundColor: const Color(0xFF2A2A3C),
      title: ChartTitle(
        text: title,
        textStyle: const TextStyle(color: Colors.white),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: const Legend(isVisible: true, textStyle: TextStyle(color: Colors.white)),
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(color: Colors.white70),
        axisLine: const AxisLine(color: Colors.white30),
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
      ),
      primaryYAxis: NumericAxis(
        labelStyle: const TextStyle(color: Colors.white70),
        axisLine: const AxisLine(color: Colors.white30),
        majorGridLines: const MajorGridLines(color: Colors.white12),
      ),
      series: <CartesianSeries<_TimeSeriesRide, String>>[
        LineSeries<_TimeSeriesRide, String>(
          name: 'Demand',
          dataSource: chartData,
          xValueMapper: (d, _) => d.label,
          yValueMapper: (d, _) => d.demandTotal,
          color: const Color(0xFF4CAF50),
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        LineSeries<_TimeSeriesRide, String>(
          name: 'Schedule',
          dataSource: chartData,
          xValueMapper: (d, _) => d.label,
          yValueMapper: (d, _) => d.scheduleTotal,
          color: Colors.amber,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        LineSeries<_TimeSeriesRide, String>(
          name: 'Pool',
          dataSource: chartData,
          xValueMapper: (d, _) => d.label,
          yValueMapper: (d, _) => d.poolTotal,
          color: Colors.blue,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: const Color(0xFF1E1E2F),
          appBar:
              isMobile
                  ? AppBar(
                    backgroundColor: const Color(0xFF2A2A3C),
                    title: const Text('Dashboard'),
                    leading: Builder(
                      builder:
                          (context) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                    ),
                  )
                  : null,
          drawer:
              isMobile
                  ? Drawer(
                    child: Material(
                      color: const Color(0xFF2A2A3C),
                      child: Sidebar(),
                    ),
                  )
                  : null,
          body: Row(
            children: [
              if (!isMobile)
                Material(color: const Color(0xFF1E1E2F), child: Sidebar()),
              Expanded(
                child:
                    loading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isMobile)
                                  const Text(
                                    'Dashboard',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                const SizedBox(height: 20),
                                Text(
                                  'Hello, ${adminName ?? "..."}!',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  quote,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A3C),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: buildBarChart(
                                    todayStats,
                                    "Today's Stats",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A3C),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: buildBarChart(
                                    yesterdayStats,
                                    "Yesterday's Stats",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A3C),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: buildLineChart(
                                    monthlyStats,
                                    "Monthly Stats",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A3C),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: buildLineChart(
                                    yearlyStats,
                                    "Yearly Stats",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Data models
class _RideData {
  final String type;
  final int total;
  final int completed;
  final int cancelled;

  _RideData(this.type, this.total, this.completed, this.cancelled);
}

class _TimeSeriesRide {
  final String label;
  final int demandTotal;
  final int scheduleTotal;
  final int poolTotal;

  _TimeSeriesRide(this.label, this.demandTotal, this.scheduleTotal, this.poolTotal);
}
