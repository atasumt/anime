import 'package:anime_list/src/domain/local/models/anime/studio_data.dart';
import 'package:anime_list/src/domain/remote/models/other_item_response.dart';


extension OtherItemExtension on OtherItemResponse {
  StudioData toStudioData() => StudioData(
        this.malId,
        this.type,
        this.name,
        this.url,
      );
}
