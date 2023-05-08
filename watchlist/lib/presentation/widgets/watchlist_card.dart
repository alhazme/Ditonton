import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/domain/entities/watchlist.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';

class WatchlistCard extends StatelessWidget {
  final Watchlist watchlist;

  const WatchlistCard(this.watchlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (watchlist.category == 'movie') {
            Navigator.pushNamed(
              context,
              MOVIE_DETAIL_ROUTE,
              arguments: watchlist.id,
            );
          } else {
            Navigator.pushNamed(
              context,
              TV_DETAIL_ROUTE,
              arguments: watchlist.id,
            );
          }
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      watchlist.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      watchlist.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${watchlist.posterPath}',
                  width: 80,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}