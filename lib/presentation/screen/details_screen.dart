import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_review_app/core/app_colors.dart';
import 'package:movie_review_app/core/app_strings.dart';
import 'package:movie_review_app/domain/entities/movie.dart';
import 'package:movie_review_app/presentation/provider/movie_provider.dart';
import 'package:movie_review_app/presentation/screen/home_screen.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.movie});
  final Movie movie;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic>? movieDetails;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchMovieDetails();
  }

  void _fetchMovieDetails() async {
    final details = await Provider.of<MovieProvider>(
      context,
      listen: false,
    ).fetchMovieDetails(widget.movie.id);
    if (mounted) {
      setState(() {
        movieDetails = details;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fetched details for ${widget.movie.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInWishlist = context.watch<MovieProvider>().isInWishlist(widget.movie.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title, style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.surface,
      ),
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.surface,
            expandedHeight: 300,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.movie.backdropPath != null
                  ? CachedNetworkImage(
                imageUrl:
                '${AppStrings.imageBaseUrl}${widget.movie.backdropPath}',
              )
                  : CachedNetworkImage(
                imageUrl:
                '${AppStrings.imageBaseUrl}${widget.movie.posterPath}',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        widget.movie.releaseDate,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        final provider = context.read<MovieProvider>();
                        final wasInWishlist = provider.isInWishlist(widget.movie.id);
                        provider.toggleWishlist(widget.movie);
                        if (!wasInWishlist) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeScreen(initialTabIndex: 2)),
                            (_) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Removed from wishlist')),
                          );
                        }
                      },
                      icon: Icon(isInWishlist ? Icons.remove : Icons.add),
                      label: Text(isInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist'),
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.movie.overview,
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
