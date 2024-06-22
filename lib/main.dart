import 'package:rrhh_movil/components/components.dart';
import 'package:rrhh_movil/screens/permisos/permisosView.dart';
import 'package:rrhh_movil/screens/screens.dart';
import 'package:rrhh_movil/services/fuente_de_contratacion.dart';
import 'package:rrhh_movil/services/idiomas.dart';
import 'package:rrhh_movil/services/nivel_ingles.dart';
import 'package:rrhh_movil/services/permiso_service.dart';
import 'package:rrhh_movil/services/puesto_disponible.dart';
import 'package:rrhh_movil/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

        ChangeNotifierProvider(create: (_) => EducacionesService()),
        ChangeNotifierProvider(create: (_) => IdiomasService()),
        ChangeNotifierProvider(create: (_) => FuenteDeContratacionService()),
        ChangeNotifierProvider(create: (_) => PuestoDisponibleService()),
        ChangeNotifierProvider(create: (_) => NivelIdiomasService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => MessageService()),
        ChangeNotifierProvider(create: (_) => PermisosService()),

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
      title: 'RRHH',
      initialRoute: 'splash',
      routes: {
        'inicio': (_) => const InicioScreen(),
        '/': (_) => const HomeScreen(),
        'splash': (_) => const SplashScreen(),
        'login': (_) => const LoginScreen(),
   
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 244, 243),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.blue,
        ),
      ),

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español
      ],
      locale: const Locale('es', 'ES'), // Establece el idioma por defecto
  
    );
  }
}
