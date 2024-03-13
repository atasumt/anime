import 'package:anime_list/src/domain/dto/anime/genre_extension.dart';
import 'package:anime_list/src/domain/dto/anime/studio_extension.dart';
import 'package:anime_list/src/domain/remote/models/data_anime_response.dart';

import '../../../utils/converter/type_anime_converter.dart';
import '../../local/models/anime/anime_data.dart';
import '../../local/models/anime/genre_data.dart';

extension DataAnimeResponseExtension on DataAnimeResponse {
  AnimeData toAnimeData() => AnimeData(
          this.malId,
          this.url,
          this.images?.jpg?.imageUrl,
          this.trailer?.youtubeId,
          this.trailer?.images?.imageUrl,
          this.title,
          this.titleEnglish,
          this.titleJapanese,
          this.titleSynonyms,
          this.type != null ? TypeAnimeConverter().encode(this.type!) : null,
          this.source,
          this.episodes,
          this.status,
          this.airing,
          '${this.aired?.prop?.from?.day}-${this.aired?.prop?.from?.month}-${this.aired?.prop?.from?.year}',
          '${this.aired?.prop?.to?.day}-${this.aired?.prop?.to?.month}-${this.aired?.prop?.to?.year}',
          this.duration,
          this.rating,
          this.score,
          this.scoredBy,
          this.rank,
          this.popularity,
          this.favorites,
          this.synopsis,
          this.background,
          this.season,
          this.broadcast?.day,
          this.broadcast?.time,
          this.broadcast?.timezone,
          this.producers?.map((otherItemResponse) => otherItemResponse.toStudioData()).toList(),
          this.licensors?.map((otherItemResponse) => otherItemResponse.toStudioData()).toList(),
          this.studios?.map((otherItemResponse) => otherItemResponse.toStudioData()).toList(), <GenreData>[
        ...?this.genres?.map((otherItemResponse) => otherItemResponse.toGenreData()).toList(),
        ...?this.themes?.map((otherItemResponse) => otherItemResponse.toGenreData()).toList(),
        ...?this.demographics?.map((otherItemResponse) => otherItemResponse.toGenreData()).toList()
      ]);
}
