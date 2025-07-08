import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart' as http;
import 'package:tilik_desa/core/bahasa/translation.dart';
import 'package:tilik_desa/data/repository/Admin/categori_admin_respositori.dart';
import 'package:tilik_desa/data/repository/Admin/dashboard_admin_repository.dart';
import 'package:tilik_desa/data/repository/Admin/pemeliharaan_admin_repository.dart';
import 'package:tilik_desa/data/repository/Auth/auth_repository.dart';
import 'package:tilik_desa/data/repository/User/dashboard_user_repository.dart';
import 'package:tilik_desa/data/repository/User/profil_update_user_repository.dart';
import 'package:tilik_desa/data/repository/User/report_user_repository.dart';
import 'package:tilik_desa/presentation/Admin/bloc/categori_admin/categori_bloc.dart';
import 'package:tilik_desa/presentation/Admin/bloc/dashboard_admin/dashboard_admin_bloc.dart';
import 'package:tilik_desa/presentation/Admin/bloc/pemeliharaan_admin/pemeliharaan_admin_bloc.dart';
import 'package:tilik_desa/presentation/User/bloc/dashboard_user/dashboard_user_bloc.dart';
import 'package:tilik_desa/presentation/User/bloc/report_user/report_user_bloc.dart';
import 'package:tilik_desa/presentation/User/bloc/update_profil_user/update_profil_user_bloc.dart';
import 'package:tilik_desa/presentation/auth/bloc/login/login_bloc.dart';
import 'package:tilik_desa/presentation/auth/bloc/register/register_bloc.dart';
import 'package:tilik_desa/presentation/auth/widget/login_screen.dart';
import 'package:tilik_desa/services/services_http_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => LoginBloc(
                authRepository: AuthRepository(ServiceHttpClient()),
              ),
        ),
        BlocProvider(
          create:
              (context) => RegisterBloc(
                authRepository: AuthRepository(ServiceHttpClient()),
              ),
        ),
        BlocProvider(
          create:
              (context) => DashboardUserBloc(
                dashboardUserRepository: DashboardUserRepository(
                  ServiceHttpClient(),
                ),
              ),
        ),
        BlocProvider(
          create:
              (context) => DashboardAdminBloc(
                repository: DashboardAdminRepository(ServiceHttpClient()),
              ),
        ),
        BlocProvider(
          create:
              (context) => ReportUserBloc(
                reportRepository: ReportRepository(ServiceHttpClient()),
              ),
        ),

        BlocProvider(
          create:
              (context) => UpdateProfilUserBloc(
                UserProfileRepository(ServiceHttpClient()),
              ),
        ),
        BlocProvider(
          create:
              (context) => PemeliharaanAdminBloc(
                repository: PemeliharaanRepository(ServiceHttpClient()),
              ),
        ),
        BlocProvider(
          create: (context) => CategoriBloc(
            CategoryRepository(ServiceHttpClient()),
          ),
        ),
      ],
      child: GetMaterialApp(
        title: 'TilikDesa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        translations: AppTranslations(), // ⬅️ tambahkan ini
        locale: const Locale('id', 'ID'), // bahasa default
        fallbackLocale: const Locale(
          'en',
          'US',
        ), // fallback jika id tidak tersedia
        home: const LoginScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
