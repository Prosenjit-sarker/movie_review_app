import 'package:flutter/material.dart';
import 'package:movie_review_app/presentation/provider/movie_provider.dart';
import 'package:movie_review_app/presentation/screen/details_screen.dart';
import 'package:movie_review_app/presentation/widget/movie_card.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          final movies = provider.wishlistMovies;
          if (movies.isEmpty) {
            return const Center(
              child: Text('No movies in wishlist', style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailsScreen(movie: movie)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
