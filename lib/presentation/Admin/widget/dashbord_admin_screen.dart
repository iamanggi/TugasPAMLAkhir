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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: BlocBuilder<DashboardAdminBloc, DashboardAdminState>(
          builder: (context, state) {
            if (state is DashboardAdminLoaded) {
              final userName = state.dashboard.data?.user?.nama ?? "Admin";
              return Row(
                children: [
                  const Icon(Icons.person, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Halo, $userName',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            } else {
              return const Text("Dashboard Admin", style: TextStyle(color: Colors.white));
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
          CircularProgressIndicator(color: Color(0xFF3B82F6)),
          SizedBox(height: 16),
          Text('Memuat data dashboard...', style: TextStyle(color: Color(0xFF64748B))),
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
          const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
          const SizedBox(height: 16),
          Text("Gagal memuat data:", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFF374151))),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280)), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<DashboardAdminBloc>().add(LoadDashboardAdmin()),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
            ),
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
      color: const Color(0xFF3B82F6),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummarySection(context),
            const SizedBox(height: 24),
            _buildReportsTrendSection(context),
            const SizedBox(height: 32),
            _buildReportsStatsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    final totalReports = data?.totalReports ?? 0;
    final totalUsers = data?.totalUsers ?? 0;
    final totalCategories = data?.totalCategories ?? 0;
    final averageRating = data?.averageRating ?? 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.report_outlined,
                title: "Total Laporan",
                value: totalReports.toString(),
                color: const Color(0xFF8B5CF6),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                icon: Icons.people_outline,
                title: "Total Users",
                value: totalUsers.toString(),
                color: const Color(0xFF3B82F6),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.category_outlined,
                title: "Total Kategori",
                value: totalCategories.toString(),
                color: const Color(0xFF10B981),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                icon: Icons.star_outline,
                title: "Avg Rating",
                value: averageRating.toStringAsFixed(1),
                color: const Color(0xFFF59E0B),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsTrendSection(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.trending_up, color: Color(0xFF3B82F6), size: 24),
                SizedBox(width: 12),
                Text(
                  "Tren Laporan", 
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  )
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: _ReportsChart(data: data),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsStatsSection(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.analytics_outlined, color: Color(0xFFF59E0B), size: 24),
                SizedBox(width: 12),
                Text(
                  "Statistik Laporan", 
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  )
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ReportsStatsGrid(data: data),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final Color backgroundColor;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13, 
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportsChart extends StatelessWidget {
  final AdminDashboardData? data;

  const _ReportsChart({required this.data});

  @override
  Widget build(BuildContext context) {
    // Create sample data based on the available information
    final List<FlSpot> spots = [
      FlSpot(0, (data?.reportsToday ?? 0).toDouble()),
      FlSpot(1, (data?.reportsThisWeek ?? 0).toDouble()),
      FlSpot(2, (data?.reportsThisMonth ?? 0).toDouble()),
      FlSpot(3, (data?.totalReports ?? 0).toDouble()),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xFFE5E7EB),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xFFE5E7EB),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, _) => Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Hari Ini', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)));
                  case 1:
                    return const Text('Minggu Ini', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)));
                  case 2:
                    return const Text('Bulan Ini', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)));
                  case 3:
                    return const Text('Total', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: spots,
            color: const Color(0xFF3B82F6),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 6,
                color: const Color(0xFF3B82F6),
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.2),
                  const Color(0xFF3B82F6).withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        minY: 0,
        maxY: (data?.totalReports ?? 0).toDouble() * 1.2,
      ),
    );
  }
}

class _ReportsStatsGrid extends StatelessWidget {
  final AdminDashboardData? data;

  const _ReportsStatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatItem(
                title: "Pending",
                value: data?.pendingReports ?? 0,
                color: const Color(0xFFF59E0B),
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                title: "Verified",
                value: data?.verifiedReports ?? 0,
                color: const Color(0xFF10B981),
                icon: Icons.verified,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatItem(
                title: "In Progress",
                value: data?.inProgressReports ?? 0,
                color: const Color(0xFF3B82F6),
                icon: Icons.hourglass_bottom,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                title: "Completed",
                value: data?.completedReports ?? 0,
                color: const Color(0xFF059669),
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatItem(
                title: "Rejected",
                value: data?.rejectedReports ?? 0,
                color: const Color(0xFFEF4444),
                icon: Icons.cancel,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatItem(
                title: "Total Ratings",
                value: data?.totalRatings ?? 0,
                color: const Color(0xFF8B5CF6),
                icon: Icons.star,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}