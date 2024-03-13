import 'package:anime_list/src/domain/remote/models/character_response.dart';
import 'package:anime_list/src/domain/use_case/anime_character_use_case.dart';
import 'package:anime_list/src/presentation/state/state_anime.dart';
import 'package:anime_list/src/utils/constants/int.dart';
import 'package:anime_list/src/utils/resources/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/local/models/anime/anime_data.dart';
import '../../domain/use_case/anime_search_use_case.dart';
import '../../domain/use_case/anime_season_now_use_case.dart';
import '../../utils/controller/pagination_scroll_controller.dart';
import '../state/event_anime.dart';

class AnimeBloc extends Bloc<EventAnime, StateAnime> {
  final AnimeSearchUseCase _animeSearchUseCase;
  final AnimeSeasonNowUseCase _animeSeasonNowUseCase;
  final AnimeCharacterUseCase _animeCharacterUseCase;

  List<AnimeData> listSeasonNowAnimeData = [];

  PaginationScrollController paginationScrollController = PaginationScrollController(
    onPageChanged: (page) => print('page $page'),
  );

  AnimeBloc(
    this._animeSearchUseCase,
    this._animeSeasonNowUseCase,
    this._animeCharacterUseCase,
  ) : super(StateAnimeLoading()) {
    on<EventAnimeGet>(_getAnimeData);
    on<EventAnimeGetSeasonNow>(_getAnimeSeasonNow);
    on<EventGetAnimeCharacters>(_getAnimeCharacters);
  }

  void _getAnimeData(EventAnimeGet event, Emitter<StateAnime> emit) async {
    DataState<List<AnimeData>> dataStateListAnimeData = await _animeSearchUseCase.getAnimeSearch();

    StateAnime responseStateAnime;

    if (dataStateListAnimeData is DataStateSuccess) {
      responseStateAnime = StateAnimeData(dataStateListAnimeData.data!);
    } else if (dataStateListAnimeData is DataStateError) {
      responseStateAnime = StateAnimeError();
    } else {
      responseStateAnime = StateAnimeError();
    }

    emit(responseStateAnime);
  }

  void _getAnimeSeasonNow(EventAnimeGetSeasonNow event, Emitter<StateAnime> emit) async {
    DataState<List<AnimeData>> dataStateListAnimeSeasonNowData = await _animeSeasonNowUseCase.getAnimeSeasonNow(event.page, limitPage);

    StateAnime responseStateAnime;

    if (dataStateListAnimeSeasonNowData is DataStateSuccess) {
      listSeasonNowAnimeData.addAll(dataStateListAnimeSeasonNowData.data!);
      responseStateAnime = StateAnimeDataSeasonNow(listSeasonNowAnimeData);
    } else if (dataStateListAnimeSeasonNowData is DataStateError) {
      responseStateAnime = StateAnimeError();
    } else {
      responseStateAnime = StateAnimeError();
    }

    emit(responseStateAnime);
  }

  void _getAnimeCharacters(EventGetAnimeCharacters event, Emitter<StateAnime> emit) async {
    DataState<CharacterResponse> dataStateCharacterResponse = await _animeCharacterUseCase.getAnimeCharacters(event.animeId);

    StateAnime responseStateAnime;

    if (dataStateCharacterResponse is DataStateSuccess) {
      responseStateAnime = StateAnimeCharacters(dataStateCharacterResponse.data!);
    } else if (dataStateCharacterResponse is DataStateError) {
      responseStateAnime = StateAnimeError();
    } else {
      responseStateAnime = StateAnimeError();
    }

    emit(responseStateAnime);
  }
}
