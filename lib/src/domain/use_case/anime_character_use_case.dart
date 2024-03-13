import 'package:anime_list/src/domain/remote/models/character_response.dart';
import 'package:anime_list/src/domain/repository/anime_repository_remote.dart';
import 'package:anime_list/src/utils/network/network_manager.dart';
import 'package:anime_list/src/utils/resources/data_state.dart';

class AnimeCharacterUseCase {
  final NetworkManager _networkManager;
  final AnimeRepositoryRemote _animeRepositoryRemote;

  const AnimeCharacterUseCase(
    this._networkManager,
    this._animeRepositoryRemote,
  );

  Future<DataState<CharacterResponse>> getAnimeCharacters(int animeId) async {
    bool isOnline = await _networkManager.isOnline;

    if (isOnline) {
      return _getDataFromRemote(animeId);
    } else {
      return DataStateError(Exception('No internet connection'));
    }
  }

  Future<DataState<CharacterResponse>> _getDataFromRemote(int animeId) async {
    DataState<CharacterResponse> dataStateCharacterResponse = await _getCharacterDataRemoteRepository(animeId);

    if (dataStateCharacterResponse is DataStateSuccess) {
      return DataStateSuccess(dataStateCharacterResponse.data!);
    } else {
      return DataStateError(Exception('Failed to fetch character data from remote'));
    }
  }

  Future<DataState<CharacterResponse>> _getCharacterDataRemoteRepository(int animeId) => _animeRepositoryRemote.getAnimeCharacters(animeId);
}
