import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageGrid extends StatelessWidget {
  const ImageGrid({super.key, required this.galeries});

  final List<Galery> galeries;

  void _popUpImage(BuildContext context, String url, Size size) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onVerticalDragEnd: (endDetails) {
            double? velocity = endDetails.primaryVelocity;
            if (velocity != null && velocity > 0) {
              Navigator.pop(context);
            }
          },
          child: Container(
            color: Colors.black,
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(0),
              minScale: 0.1,
              maxScale: 4,
              child: Hero(
                tag: 'GridViewImage',
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        url,
                        cacheManager: CacheManager(
                          Config(
                            "CafeImageDetailGrid_$url",
                            stalePeriod: const Duration(days: 1),
                            maxNrOfCacheObjects: 100,
                          ),
                        ),
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: GridView.custom(
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: [
              const QuiltedGridTile(2, 2),
              const QuiltedGridTile(1, 1),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) => GestureDetector(
              onTap: () => _popUpImage(context, galeries[index].url, size),
              child: Hero(
                tag: 'GridViewImage_${galeries[index].url}',
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        galeries[index].url,
                        cacheManager: CacheManager(
                          Config(
                            "CafeImageDetailGrid",
                            stalePeriod: const Duration(days: 1),
                            maxNrOfCacheObjects: 100,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            childCount: galeries.length,
          ),
        ),
      ),
    );
  }
}
