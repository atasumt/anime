import 'package:anime_list/src/domain/local/models/anime/anime_data.dart';
import 'package:anime_list/src/domain/local/models/anime/pagination_data.dart';

import '../../domain/repository/anime_repository_remote.dart';
import '../../utils/network/network_manager.dart';
import '../../utils/resources/data_state.dart';
import '../../utils/resources/data_state_pagination.dart';

class AnimeSeasonNowUseCase {
  final NetworkManager _networkManager;
  final AnimeRepositoryRemote _animeRepositoryRemote;

  const AnimeSeasonNowUseCase(this._networkManager, this._animeRepositoryRemote);

  Future<DataState<List<AnimeData>>> getAnimeSeasonNow(int page, int limit) async {
    bool isOnline = await _networkManager.isOnline;

    if (isOnline) {
      return _getDataFromRemote(page, limit);
    } else {
      return DataStateError(Exception('No internet connection'));
    }
  }

  Future<DataState<List<AnimeData>>> _getDataFromRemote(int page, int limit) async {
    DataStatePagination<List<AnimeData>, PaginationData> dataStatePaginationAnimeDataPaginationData = await _getAnimeSearchRemoteRepository(page, limit);

    if (dataStatePaginationAnimeDataPaginationData is DataStatePaginationSuccess) {
      if (dataStatePaginationAnimeDataPaginationData.data != null) {
        return DataStateSuccess(dataStatePaginationAnimeDataPaginationData.data!);
      } else {
        return DataStateError(Exception('Data is null'));
      }
    } else {
      return DataStateError(Exception('Failed to fetch data from remote'));
    }
  }

  Future<DataStatePagination<List<AnimeData>, PaginationData>> _getAnimeSearchRemoteRepository(int page, int limit) =>
      _animeRepositoryRemote.getAnimeSeasonNow(page, limit);
}
