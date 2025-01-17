import 'package:go_router/go_router.dart';
// import 'package:primer_parcial/data/fake_repository.dart';
import 'package:primer_parcial/data/local_repository.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';
import 'package:primer_parcial/presentation/screens/configuration.dart';
import 'package:primer_parcial/presentation/screens/login.dart';
import 'package:primer_parcial/presentation/screens/trees_screen.dart';
import 'package:primer_parcial/presentation/screens/tree_detail_screen.dart';
import 'package:primer_parcial/presentation/screens/user_profile.dart';

// final Repository repository = FakeRepository();
final Repository repository = LocalRepository();

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(
        repository: repository,
      ),
    ),
    GoRoute(
        path: '/trees/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          return TreesScreen(
            userId: int.tryParse(userId ?? '') ?? -1,
            repository: repository,
          );
        }),
    GoRoute(
        path: '/treeDetail/:treeId',
        builder: (context, state) {
          final treeId = state.pathParameters['treeId'];
          return TreeDetailScreen(
            treeId: int.tryParse(treeId ?? '') ?? -1,
            repository: repository,
          );
        }),
    GoRoute(
        path: '/userProfile/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          return UserProfile(
            userId: int.tryParse(userId ?? '') ?? -1,
            repository: repository,
          );
        }),
    GoRoute(
      path: '/configuration',
      builder: (context, state) => const Configuration(),
    ),
  ],
);
