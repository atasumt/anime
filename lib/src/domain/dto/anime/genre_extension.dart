import 'package:anime_list/src/domain/local/models/anime/genre_data.dart';
import 'package:anime_list/src/domain/remote/models/other_item_response.dart';

extension OtherItemResponseExtension on OtherItemResponse {
  GenreData toGenreData() => GenreData(
        this.malId,
        this.type,
        this.name,
        this.url,
      );
}
