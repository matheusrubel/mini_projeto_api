import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cpf_provider.dart';
import 'providers/fipe_provider.dart';
import 'providers/moeda_provider.dart';
import 'providers/cep_provider.dart';
import 'providers/senha_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CpfProvider()),
        ChangeNotifierProvider(create: (_) => FipeProvider()),
        ChangeNotifierProvider(create: (_) => MoedaProvider()),
        ChangeNotifierProvider(create: (_) => CepProvider()),
        ChangeNotifierProvider(create: (_) => SenhaProvider()),
      ],
      child: MaterialApp(
        title: 'Invertexto App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1565C0),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          // CORRIGIDO: CardThemeData em vez de CardTheme
          cardTheme: CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
