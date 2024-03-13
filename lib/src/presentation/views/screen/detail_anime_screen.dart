import 'package:anime_list/src/presentation/bloc/anime_bloc.dart';
import 'package:anime_list/src/presentation/views/widgets/companent_helper_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/event_anime.dart';
import '../../state/state_anime.dart';

@RoutePage()
//ignore: must_be_immutable
class DetailAnimeScreen extends StatelessWidget {
  final int malIdAnime;
  final String episodes;
  final String synopsis;

  DetailAnimeScreen({
    Key? key,
    @PathParam('malIdAnime') required this.malIdAnime,
    @PathParam('episodes') required this.episodes,
    @PathParam('synopsis') required this.synopsis,
  }) : super(key: key);

  late AnimeBloc _detailAnimeBloc;

  @override
  Widget build(BuildContext context) {
    _detailAnimeBloc = context.read<AnimeBloc>();
    _detailAnimeBloc.add(EventGetAnimeCharacters(malIdAnime));

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _mainBody(context, constraints.maxWidth);
        },
      ),
    );
  }

  Widget _mainBody(BuildContext context, double maxWidth) {
    double widthImage = maxWidth;
    double heightImage = (widthImage / 225) * 319;

    Widget _flexibleSpaceBar = FlexibleSpaceBar(
      background: BlocBuilder<AnimeBloc, StateAnime>(
        buildWhen: (previous, current) {
          if (current is StateAnimeCharacters) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is StateAnimeCharacters) {
            return Image.network(
              state.characters.data?[0].character?.images?.jpg?.imageUrl ?? "",
              fit: BoxFit.cover,
            );
          } else {
            return Container();
          }
        },
      ),
    );

    Widget _title = BlocBuilder<AnimeBloc, StateAnime>(
      buildWhen: (previous, current) {
        if (current is StateAnimeCharacters) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is StateAnimeCharacters) {
          return Text(
            state.characters.data?[0].character?.name ?? "",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
          );
        } else {
          return Container();
        }
      },
    );

    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: heightImage,
            pinned: false,
            snap: true,
            floating: true,
            title: _title,
            centerTitle: true,
            flexibleSpace: _flexibleSpaceBar,
          ),
        ];
      },
      body: _bodyy(synopsis, episodes: episodes),
    );
  }

  Widget _bodyy(String? synopsis, {String episodes = '0'}) {
    return BlocBuilder<AnimeBloc, StateAnime>(
      buildWhen: (previous, current) {
        if (current is StateAnimeCharacters) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is StateAnimeCharacters) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Column(
              children: [
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CompanentHelper(titleName: 'Puan', value: state.characters.data?[0].favorites.toString() ?? ''),
                    CompanentHelper(titleName: 'Role', value: state.characters.data?[0].role.toString() ?? ''),
                    CompanentHelper(titleName: 'Bölüm Sayısı', value: episodes == 'null' ? '0' : episodes),
                  ],
                ),
                SizedBox(height: 32),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Text(
                          '${synopsis}',
                          maxLines: 20,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
