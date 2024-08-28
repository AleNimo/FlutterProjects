import 'package:go_router/go_router.dart';
import 'package:tp2_log_in/presentation/screens/login.dart';
import 'package:tp2_log_in/presentation/screens/home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(
        nombre: state.extra as String
      ),
    )
  ]
);