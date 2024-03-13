import 'dart:async';

import 'package:anime_list/src/domain/local/models/anime/anime_data.dart';
import 'package:anime_list/src/domain/local/models/anime/pagination_data.dart';
import 'package:anime_list/src/domain/repository/anime_repository_remote.dart';
import 'package:anime_list/src/utils/network/network_manager.dart';
import 'package:anime_list/src/utils/resources/data_state.dart';
import 'package:anime_list/src/utils/resources/data_state_pagination.dart';

class AnimeSearchUseCase {
  final NetworkManager _networkManager;
  final AnimeRepositoryRemote _animeRepositoryRemote;

  const AnimeSearchUseCase(
    this._networkManager,
    this._animeRepositoryRemote,
  );

  Future<DataState<List<AnimeData>>> getAnimeSearch() async {
    bool isOnline = await _networkManager.isOnline;

    if (isOnline) {
      return _getDataFromRemote();
    } else {
      return DataStateError(Exception('No internet connection'));
    }
  }

  Future<DataState<List<AnimeData>>> _getDataFromRemote() async {
    DataStatePagination<List<AnimeData>, PaginationData> dataStatePaginationAnimeDataPaginationData = await _getAnimeSearchRemoteRepository();

    if (dataStatePaginationAnimeDataPaginationData is DataStatePaginationSuccess) {
      return DataStateSuccess(dataStatePaginationAnimeDataPaginationData.data!);
    } else {
      return DataStateError(Exception('Failed to fetch data from remote'));
    }
  }

  Future<DataStatePagination<List<AnimeData>, PaginationData>> _getAnimeSearchRemoteRepository() => _animeRepositoryRemote.getAnimeSearch();
}
