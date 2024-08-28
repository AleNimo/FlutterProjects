import 'package:go_router/go_router.dart';
import 'package:tp3_listas/presentation/screens/movie_detail_screen.dart';
import 'package:tp3_listas/presentation/screens/movies_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/movies',
  routes: [
    GoRoute(
      path: '/movies',
      builder: (context, state) => MoviesScreen(),
    ),
    GoRoute(
      path: '/movieDetail/:id',
      builder: (context, state) =>
          MovieDetailScreen(movieId: state.pathParameters['id']!),
    ),
  ],
);
