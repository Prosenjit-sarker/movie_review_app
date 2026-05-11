import 'package:flutter/material.dart';
import 'package:movie_review_app/domain/entities/movie.dart';

class MovieListHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final ValueChanged<Movie>? onMovieTap;

  const MovieListHorizontal({super.key, required this.movies, this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onMovieTap == null ? null : () => onMovieTap!(movie),
              child: SizedBox(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        movie.posterUrl,
                        width: 130,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 130,
                          height: 180,
                          color: Colors.grey.shade800,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.releaseDate,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
