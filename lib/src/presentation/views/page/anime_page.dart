import 'package:anime_list/src/presentation/components/jikan_moe_grid_view_pagination.dart';
import 'package:anime_list/src/presentation/components/jikan_moe_sliver_app_bar.dart';
import 'package:anime_list/src/utils/constants/int.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/router/app_router.dart';
import '../../../domain/local/models/anime/anime_data.dart';
import '../../../utils/window_size/window_class.dart';
import '../../../utils/window_size/window_size_class.dart';
import '../../bloc/anime_bloc.dart';
import '../../state/event_anime.dart';
import '../../state/state_anime.dart';

@RoutePage()
//ignore: must_be_immutable
class AnimePage extends StatelessWidget {
  late AnimeBloc _animeBloc;
  late WindowSizeClass _windowSizeClass;

  @override
  Widget build(BuildContext context) {
    _windowSizeClass = WindowSizeClass(context);

    _animeBloc = context.read<AnimeBloc>();
    _animeBloc.add(EventAnimeGet());
    _animeBloc.add(EventAnimeGetSeasonNow(firstPageAnimeSeasonNow));

    return Scaffold(body: _contentScreen(context));
  }

  Widget _contentScreen(BuildContext context) {
    if (_windowSizeClass.windowClass == WindowClass.Compact) {
      return _sliverAppBar(context);
    } else if (_windowSizeClass.windowClass == WindowClass.Medium) {
      return Row(
        children: [
          Expanded(
            child: _sliverAppBar(context),
          ),
          Expanded(
            child: AutoRouter(),
          ),
        ],
      );
    } else if (_windowSizeClass.windowClass == WindowClass.Expanded) {
      return Row(
        children: [
          Expanded(
            child: _sliverAppBar(context),
          ),
          Expanded(
            child: AutoRouter(),
          ),
        ],
      );
    }

    throw 'This should never have happened';
  }

  Widget _sliverAppBar(BuildContext context) {
    Widget sliverAppBar = JikanMoeSliverAppBar(
      title: Text('Anime'),
    );

    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          sliverAppBar,
        ];
      },
      body: _contentHomeAnime(context),
    );
  }

  /// Content Home
  Widget _contentHomeAnime(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('This Season', style: Theme.of(context).textTheme.titleLarge),
          ),
          Container(
            height: 750,
            width: MediaQuery.of(context).size.width,
            child: _animeSeasonNow(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('Anime List', style: Theme.of(context).textTheme.titleLarge),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: _viewAnime(context),
          ),
        ],
      ),
    );
  }

  /// Anime Season Now
  Widget _animeSeasonNow(BuildContext context) {
    return BlocBuilder<AnimeBloc, StateAnime>(
      buildWhen: (previous, current) => current is StateAnimeDataSeasonNow,
      builder: (context, responseStateAnime) {
        if (responseStateAnime is StateAnimeDataSeasonNow) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _animeSeasonNowView(context, responseStateAnime.data),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _animeSeasonNowView(BuildContext context, List<AnimeData> listAnimeData) {
    return JikanMoeGridViewPagination(
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount(context),
        childAspectRatio: _childAspectRatio(context),
      ),
      shrinkWrap: true,
      itemCount: listAnimeData.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.router.push(
              DetailAnimeRoute(
                malIdAnime: listAnimeData[index].malId!,
                episodes: listAnimeData[index].episodes.toString(),
                synopsis: listAnimeData[index].synopsis ?? '',
              ),
            );
          },
          child: _itemSeasonNow(
            context,
            src: listAnimeData[index].image ?? '',
            title: listAnimeData[index].titleDefault ?? listAnimeData[index].titleEnglish ?? '',
            subtitle: listAnimeData[index].titleJapanese ?? '',
            score: listAnimeData[index].score.toString(),
          ),
        );
      },
      onPageChanged: (page) {
        _animeBloc.add(EventAnimeGetSeasonNow(page));
      },
    );
  }

  double _childAspectRatio(BuildContext context) {
    if (_windowSizeClass.windowClass == WindowClass.Compact) {
      return MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3);
    } else if (_windowSizeClass.windowClass == WindowClass.Medium) {
      return MediaQuery.of(context).size.height / (MediaQuery.of(context).size.width / 3);
    } else if (_windowSizeClass.windowClass == WindowClass.Expanded) {
      return MediaQuery.of(context).size.height / (MediaQuery.of(context).size.width / 3);
    }

    throw 'This should never have happened';
  }

  int _crossAxisCount(BuildContext context) {
    if (_windowSizeClass.windowClass == WindowClass.Compact) {
      return 3;
    } else if (_windowSizeClass.windowClass == WindowClass.Medium) {
      return 3;
    } else if (_windowSizeClass.windowClass == WindowClass.Expanded) {
      return 3;
    }

    throw 'This should never have happened';
  }

  /// Item Anime Season Now
  Widget _itemSeasonNow(BuildContext context, {required String src, required String title, required String subtitle, required String score}) {
    return Column(
      children: [
        Image.network(
          src,
          width: 225 / 2,
          height: 319 / 2,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '${score}',
            maxLines: 2,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// View Anime
  Widget _viewAnime(BuildContext context) {
    return BlocBuilder<AnimeBloc, StateAnime>(
        buildWhen: (previous, current) => current is StateAnimeData,
        builder: (context, responseStateHome) {
          if (responseStateHome is StateAnimeData) {
            List<AnimeData> listAnimeData = responseStateHome.data;
            return _listAnime(context, listAnimeData);
          } else {
            return Container();
          }
        });
  }

  /// List Anime
  Widget _listAnime(BuildContext context, List<AnimeData> listAnimeData) {
    return ListView.builder(
      itemCount: listAnimeData.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            listAnimeData[index].image ?? '',
            errorBuilder: (context, error, stackTrace) => CircleAvatar(
              child: Text(
                listAnimeData[index].titleEnglish?[0] ?? 'J',
              ),
            ),
          ),
          title: Text(listAnimeData[index].titleEnglish ?? ''),
          subtitle: Text(listAnimeData[index].rating?.toString() ?? ''),
          trailing: Icon(Icons.more_vert),
        );
      },
    );
  }
}
