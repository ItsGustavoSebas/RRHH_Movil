import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/screens/screens.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: ( _ ) => EducacionesService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => MessageService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda Electrónica',
      initialRoute: 'splash',
      routes: {
        'inicio': (_) => const InicioScreen(),
        '/': (_) => const HomeScreen(),
        'splash': (_) => const SplashScreen(),
        'login': (_) => const LoginScreen(),
        'historial': (_) => const HistorialScreen(),  // Ruta actualizada
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 244, 243),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
