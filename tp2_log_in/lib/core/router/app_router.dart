import 'package:go_router/go_router.dart';
import 'package:tp2_log_in/presentation/screens/login.dart';
import 'package:tp2_log_in/presentation/screens/trees_screen.dart';
import 'package:tp2_log_in/presentation/screens/tree_detail_screen.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/trees/:userName',
    builder: (context, state) =>
        TreesScreen(userName: state.pathParameters['userName']!),
  ),
  GoRoute(
    path: '/treeDetail/:id',
    builder: (context, state) =>
        TreeDetailScreen(treeId: state.pathParameters['id']!),
  ),
]);
