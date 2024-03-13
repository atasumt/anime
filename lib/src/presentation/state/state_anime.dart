import 'package:anime_list/src/domain/remote/models/character_response.dart';

import '../../domain/local/models/anime/anime_data.dart';

abstract class StateAnime {}

class StateAnimeLoading extends StateAnime {
  StateAnimeLoading();
}

class StateAnimeError extends StateAnime {
  StateAnimeError();
}

class StateAnimeData extends StateAnime {
  final List<AnimeData> data;
  StateAnimeData(this.data);
}

class StateAnimeDataSeasonNow extends StateAnime {
  final List<AnimeData> data;
  StateAnimeDataSeasonNow(this.data);
}

class StateDetailAnimeData extends StateAnime {
  final AnimeData data;
  StateDetailAnimeData(this.data);
}

class StateAnimeCharacters extends StateAnime {
  final CharacterResponse characters;
  StateAnimeCharacters(this.characters);
}
