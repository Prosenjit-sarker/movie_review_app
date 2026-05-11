import 'package:flutter/material.dart';
import 'package:movie_review_app/data/service/api_service.dart';
import 'package:movie_review_app/domain/entities/movie.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Movie> _trendingMovies = [];
  List<Movie> get trendingMovies => _trendingMovies;

  List<Movie> _searchResults = [];
  List<Movie> get searchResults => _searchResults;

  List<Movie> _upcomingMovies = [
    Movie(
      id: 101,
      title: 'Future Blockbuster',
      overview: 'An exciting upcoming movie.',
      posterPath: '/future_blockbuster.jpg',
      backdropPath: '/future_backdrop.jpg',
      voteAverage: 8.5,
      releaseDate: '2026-06-01',
      genreIds: [12, 18],
    ),
    Movie(
      id: 102,
      title: 'Next Big Hit',
      overview: 'A thrilling adventure awaits.',
      posterPath: '/next_big_hit.jpg',
      backdropPath: '/next_backdrop.jpg',
      voteAverage: 7.9,
      releaseDate: '2026-07-15',
      genreIds: [28, 53],
    ),
  ];
  List<Movie> get upcomingMovies => _upcomingMovies;

  final List<Movie> _wishlistMovies = [];
  List<Movie> get wishlistMovies => List.unmodifiable(_wishlistMovies);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchTrendingMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _trendingMovies = await _apiService.getTrendingMovies();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isInWishlist(int movieId) => _wishlistMovies.any((m) => m.id == movieId);

  void addToWishlist(Movie movie) {
    if (isInWishlist(movie.id)) return;
    _wishlistMovies.add(movie);
    notifyListeners();
  }

  void removeFromWishlist(int movieId) {
    _wishlistMovies.removeWhere((m) => m.id == movieId);
    notifyListeners();
  }

  void toggleWishlist(Movie movie) {
    if (isInWishlist(movie.id)) {
      removeFromWishlist(movie.id);
    } else {
      addToWishlist(movie);
    }
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchMovies(query);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUpcomingMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _upcomingMovies = await _apiService.getUpcomingMovies();
      if (_upcomingMovies.isEmpty) {
        _upcomingMovies = _fallbackUpcomingMovies;
      }
      _errorMessage = '';
    } catch (e) {
      _upcomingMovies = _fallbackUpcomingMovies;
      _errorMessage = '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Movie> get _fallbackUpcomingMovies => [
        Movie(
          id: 603,
          title: 'The Matrix',
          overview: 'A computer hacker learns about the true nature of reality.',
          posterPath: null,
          backdropPath: null,
          voteAverage: 8.0,
          releaseDate: '1999-03-31',
          genreIds: const [],
        ),
        Movie(
          id: 157336,
          title: 'Interstellar',
          overview: 'A team travels through a wormhole in space to ensure humanity’s survival.',
          posterPath: null,
          backdropPath: null,
          voteAverage: 8.3,
          releaseDate: '2014-11-05',
          genreIds: const [],
        ),
        Movie(
          id: 299534,
          title: 'Avengers: Endgame',
          overview: 'The Avengers assemble once more to reverse Thanos’ actions.',
          posterPath: null,
          backdropPath: null,
          voteAverage: 8.2,
          releaseDate: '2019-04-24',
          genreIds: const [],
        ),
      ];

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final details = await _apiService.getMovieDetails(movieId);
      _errorMessage = '';
      return details;
    } catch (e) {
      _errorMessage = e.toString();
      return {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
