import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tilik_desa/data/model/response/admin/dashboard_admin_response_model.dart';
import 'package:tilik_desa/presentation/Admin/bloc/dashboard_admin/dashboard_admin_bloc.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
  
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardAdminBloc>().add(LoadDashboardAdmin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: BlocBuilder<DashboardAdminBloc, DashboardAdminState>(
          builder: (context, state) {
            if (state is DashboardAdminLoaded) {
              final userName = state.dashboard.data?.user?.nama ?? "Admin";
              return Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Halo, $userName',
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            } else {
              return const Text("Dashboard Admin");
            }
          },
        ),
      ),
      body: BlocBuilder<DashboardAdminBloc, DashboardAdminState>(
        builder: (context, state) {
          return switch (state) {
            DashboardAdminLoading() => const _LoadingWidget(),
            DashboardAdminError() => _ErrorWidget(message: state.message),
            DashboardAdminLoaded() => _ContentWidget(data: state.dashboard.data),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat data dashboard...'),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text("Gagal memuat data:", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<DashboardAdminBloc>().add(LoadDashboardAdmin()),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  final AdminDashboardData? data;

  const _ContentWidget({this.data});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<DashboardAdminBloc>().add(LoadDashboardAdmin()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportsTrendSection(context),
            const SizedBox(height: 32),
            _buildPriorityAreasSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTrendSection(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.trending_up, color: Colors.blue),
                SizedBox(width: 8),
                Text("Tren Laporan Bulanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            if (data?.reportsTrend != null && data!.reportsTrend!.isNotEmpty)
              SizedBox(height: 300, child: _ReportsChart(trendData: data!.reportsTrend!))
            else
              const _EmptyBox(
                icon: Icons.analytics_outlined,
                message: "Belum ada data tren laporan",
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityAreasSection(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.priority_high, color: Colors.orange),
                SizedBox(width: 8),
                Text("Informasi Tambahan dari Admin", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            if (data?.priorityAreas != null && data!.priorityAreas!.isNotEmpty)
              ...data!.priorityAreas!.map((area) => _InfoCard(area: area))
            else
              const _EmptyBox(
                icon: Icons.info_outline,
                message: "Belum ada informasi tambahan",
              ),
          ],
        ),
      ),
    );
  }
}

class _ReportsChart extends StatelessWidget {
  final List<ReportsTrend> trendData;

  const _ReportsChart({required this.trendData});

  @override
  Widget build(BuildContext context) {
    final spots = trendData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return FlSpot(index.toDouble(), (item.count ?? 0).toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, _) => Text(value.toInt().toString()),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index >= 0 && index < trendData.length) {
                  return Text(trendData[index].day ?? '', style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: spots,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [Colors.blue.withOpacity(0.2), Colors.blue.withOpacity(0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final PriorityArea area;

  const _InfoCard({required this.area});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(area.village ?? 'Judul tidak tersedia', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Jumlah Laporan: ${area.reportCount ?? 0}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyBox({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
