import 'package:go_router/go_router.dart';
import 'package:tp2_log_in/presentation/screens/login.dart';
import 'package:tp2_log_in/presentation/screens/policies_screen.dart';
import 'package:tp2_log_in/presentation/screens/policy_detail_screen.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/policy/:userName',
    builder: (context, state) =>
        PoliciesScreen(userName: state.pathParameters['userName']!),
  ),
  GoRoute(
    path: '/policyDetail/:id',
    builder: (context, state) =>
        PolicyDetailScreen(policyId: state.pathParameters['id']!),
  ),
]);
