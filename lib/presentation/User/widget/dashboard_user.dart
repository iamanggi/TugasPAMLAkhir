import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tilik_desa/core/navigations/user_botom_navigation.dart';
import 'package:tilik_desa/presentation/User/bloc/dashboard_user/dashboard_user_bloc.dart';
import 'package:tilik_desa/presentation/User/widget/pengaturan_user.dart';
import 'package:tilik_desa/presentation/User/widget/report_user.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({Key? key}) : super(key: key);

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardUserBloc>().add(LoadDashboardUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<DashboardUserBloc, DashboardUserState>(
          builder: (context, state) {
            String displayName = "loading".tr;

            if (state is DashboardUserLoaded) {
              displayName = state.dashboard.data?.user?.nama ?? "user".tr;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "welcome".tr,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: BlocBuilder<DashboardUserBloc, DashboardUserState>(
              builder: (context, state) {
                if (state is DashboardUserLoaded) {
                  final photoUrl = state.dashboard.data?.user?.photo;
                  if (photoUrl != null && photoUrl.isNotEmpty) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(photoUrl),
                      child: null,
                    );
                  }
                }
                return const CircleAvatar(child: Icon(Icons.person));
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<DashboardUserBloc, DashboardUserState>(
        builder: (context, state) {
          if (state is DashboardUserLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text("loading_dashboard".tr),
                ],
              ),
            );
          } else if (state is DashboardUserLoaded) {
            final dashboard = state.dashboard.data;
            final stats = dashboard?.stats;
            final pemeliharaan = dashboard?.pemeliharaan;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardUserBloc>().add(LoadDashboardUser());
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildStatsCard(stats),
                  const SizedBox(height: 16),
                  if (pemeliharaan != null && pemeliharaan.isNotEmpty)
                    _buildPemeliharaanSection(pemeliharaan),
                ],
              ),
            );
          } else if (state is DashboardUserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "dashboard_failed".tr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardUserBloc>().add(LoadDashboardUser());
                    },
                    child: Text("try_again".tr),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text("loading".tr),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  CameraScreen()));
        },
        child: const Icon(Icons.add),
        tooltip: "new_report".tr,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: UserBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  CameraScreen()));
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              break;
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'search_hint'.tr,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.filter_list),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      onChanged: (value) {},
    );
  }

  Widget _buildStatsCard(dynamic stats) {
    final totalReports = stats?.totalReports ?? 0;
    final pendingReports = stats?.pendingReports ?? 0;
    final inProgressReports = stats?.inProgressReports ?? 0;
    final completedReports = stats?.completedReports ?? 0;

    final statList = [
      {
        "label": "total_reports".tr,
        "value": totalReports.toString(),
        "icon": Icons.assignment,
        "color": Colors.blue,
      },
      {
        "label": "pending".tr,
        "value": pendingReports.toString(),
        "icon": Icons.hourglass_empty,
        "color": Colors.orange,
      },
      {
        "label": "in_progress".tr,
        "value": inProgressReports.toString(),
        "icon": Icons.engineering,
        "color": Colors.purple,
      },
      {
        "label": "completed".tr,
        "value": completedReports.toString(),
        "icon": Icons.check_circle,
        "color": Colors.green,
      },
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "your_stats".tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: statList.length,
              itemBuilder: (context, index) {
                final item = statList[index];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (item["color"] as Color).withOpacity(0.1),
                        (item["color"] as Color).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (item["color"] as Color).withOpacity(0.3),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(item["icon"] as IconData, color: item["color"] as Color, size: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["value"].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: item["color"] as Color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["label"].toString(),
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPemeliharaanSection(List<dynamic> pemeliharaanList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.build, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              "maintenance_info".tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...pemeliharaanList.map((pemeliharaan) => _buildPemeliharaanCard(pemeliharaan)).toList(),
      ],
    );
  }

  Widget _buildPemeliharaanCard(dynamic pemeliharaan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.amber.shade50, Colors.orange.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pemeliharaan.namaFasilitas ?? "facility".tr,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (pemeliharaan.tglPemeliharaan != null)
                          Text(
                            "${'date'.tr}: ${pemeliharaan.tglPemeliharaan}",
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (pemeliharaan.deskripsi != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(pemeliharaan.deskripsi!, style: const TextStyle(fontSize: 14)),
                ),
              ],
              if (pemeliharaan.catatan != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.note, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${'note'.tr}: ${pemeliharaan.catatan}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
