import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tp3_listas/domain/movie.dart';
import 'package:tp3_listas/data/movies_repository.dart';


class MoviesScreen extends StatelessWidget {
  MoviesScreen({super.key});

  final List<Movie> movies = movieList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),

      ),
      body: _MoviesView(movies: movies,),
    );
  }
}

class _MoviesView extends StatelessWidget {
  const _MoviesView({
    required this.movies
  });

  final List<Movie> movies;
  @override
  Widget build(BuildContext context) {
    return ListView.builder( //ListViewBuilder sirve para listas dinamicas, ya tiene función de scroll, etc
      itemCount: 4,
      itemBuilder: (context,index){ //Vendría a ser una especie de forEach que recorre todos los elementos y retorna un widget para cada item
        return _MovieItem(movie: movies[index]);
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  const _MovieItem({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector( //Widget
      onTap: () {
        context.push('/movieDetail/${movie.id}');
      },
      child: Card(
        child: ListTile(
          leading: movie.posterURL != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(movie.posterURL!),
            )
            : const Icon(Icons.movie),
          title: Text(movie.title),
          subtitle: Text(movie.director),
          trailing: const Icon(Icons.arrow_forward),
          // onTap: () {
          //   context.push('/movieDetail/${movie.id}');
          // },
        ),
      ),
    );
  }
}