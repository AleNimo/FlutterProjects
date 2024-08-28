import 'package:flutter/material.dart';
import 'package:tp3_listas/domain/movie.dart';
import 'package:tp3_listas/data/movies_repository.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Detail'),
      ),
      body: _MovieDetailView(
        movie: movieList.firstWhere((movie) => movie.id == movieId),
      ),
    );
  }
}

//Podría pasar solo el id o el objeto de la pelicula
//Pasar el id hace que haya una doble busqueda en la lista, pero si la peli cambia no me queda el objeto desactualizado
//Tambien se pasa el id si la información es sensible
class _MovieDetailView extends StatelessWidget {
  const _MovieDetailView({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (movie.posterURL != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterURL!,
                height: 400,
              ),
            )
          else
            const Icon(Icons.movie),
          Text(movie.title,
              style: textStyle
                  .titleLarge), //Se usa el estilo de materialApp para mantener el paradigma
          Text(movie.director, style: textStyle.bodyMedium),
          Text(movie.year.toString(), style: textStyle.bodySmall),
        ],
      ),
    );
  }
}
