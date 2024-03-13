import 'package:anime_list/src/domain/local/models/anime/anime_data.dart';
import 'package:anime_list/src/domain/local/models/anime/genre_data.dart';
import 'package:anime_list/src/domain/local/models/anime/studio_data.dart';
import 'package:anime_list/src/domain/use_case/anime_character_use_case.dart';
import 'package:anime_list/src/domain/use_case/anime_search_use_case.dart';
import 'package:anime_list/src/domain/use_case/anime_season_now_use_case.dart';
import 'package:anime_list/src/presentation/bloc/anime_bloc.dart';
import 'package:anime_list/src/presentation/state/event_anime.dart';
import 'package:anime_list/src/presentation/state/state_anime.dart';
import 'package:anime_list/src/utils/constants/type_anime.dart';
import 'package:anime_list/src/utils/resources/data_state.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockAnimeSearchUseCase extends Mock implements AnimeSearchUseCase {}

class MockAnimeSeasonNowUseCase extends Mock implements AnimeSeasonNowUseCase {}

class MockAnimeCharacterUseCase extends Mock implements AnimeCharacterUseCase {}

final studioData1 = StudioData(1, "Wit Studio", "History", "www");
final studioData2 = StudioData(2, "Bones", "History", "http");
final studioData3 = StudioData(3, "Sunrise", "History", "www");

final genreData1 = GenreData(1, "Action", "History", "www");
final genreData2 = GenreData(2, "Adventure", "History", "www");
final genreData3 = GenreData(3, "Comedy", "History", "www");

var anime = AnimeData(
  1,
  "https://myanimelist.net/anime/1/Shingeki_no_Kyojin",
  "https://cdn.myanimelist.net/images/anime/139/92144.jpg",
  "https://www.youtube.com/watch?v=tY8Wz77qG3c",
  "https://i.ytimg.com/vi/tY8Wz77qG3c/maxresdefault.jpg",
  "Shingeki no Kyojin",
  "Attack on Titan",
  "進撃の巨人",
  ["Attack on Titan", "Shingeki Kyojin"],
  TypeAnime.tv,
  "Manga",
  75,
  "Finished Airing",
  false,
  "2013-04-07",
  "2022-04-03",
  "24 min",
  "R - 17+ (violence & profanity)",
  8.8,
  1222000,
  4,
  10,
  225000,
  "In the year 850, humanity lives in fear of gigantic man-eating humanoids called Titans. The last remaining humans live within three enormous concentric walls that protect them from the Titans. The story follows Eren Yeager, his adopted sister Mikasa Ackerman, and their childhood friend Armin Arlert, whose lives are changed forever after the appearance of a colossal Titan brings about the destruction of their home town and the death of Eren's mother. Vowing revenge and to reclaim the world from the Titans, Eren, Mikasa, and Armin join the Scout Regiment, an elite group of soldiers who fight Titans outside the walls.",
  "https://cdn.myanimelist.net/images/anime/139/92145.jpg",
  "Spring 2013",
  "Sunday",
  "00:00 (JST)",
  "Asia/Tokyo",
  [studioData1],
  [studioData2],
  [studioData1, studioData3],
  [genreData1, genreData2],
);

void main() {
  group('AnimeBloc', () {
    late AnimeBloc animeBloc;
    late AnimeSearchUseCase mockAnimeSearchUseCase;
    late AnimeSeasonNowUseCase mockAnimeSeasonNowUseCase;
    late AnimeCharacterUseCase mockAnimeCharacterUseCase;

    setUp(() {
      mockAnimeSearchUseCase = MockAnimeSearchUseCase();
      mockAnimeSeasonNowUseCase = MockAnimeSeasonNowUseCase();
      mockAnimeCharacterUseCase = MockAnimeCharacterUseCase();
      animeBloc = AnimeBloc(mockAnimeSearchUseCase, mockAnimeSeasonNowUseCase, mockAnimeCharacterUseCase);
    });

    test('Initial state should be StateAnimeLoadin', () {
      expect(animeBloc.state, StateAnimeLoading());
    });

    test('Fetching anime data returns StateAnimeData on success', () async {
      final animeData = [anime];
      when(mockAnimeSearchUseCase.getAnimeSearch()).thenAnswer((_) async => DataStateSuccess(animeData));

      animeBloc.add(EventAnimeGet());

      await expectLater(
        animeBloc.stream,
        emitsInOrder([StateAnimeLoading(), StateAnimeData(animeData)]),
      );
    });

    test('Fetching anime data returns StateAnimeError on failure', () async {
      when(mockAnimeSearchUseCase.getAnimeSearch()).thenAnswer((_) async => DataStateError(Exception('No internet connection')));

      animeBloc.add(EventAnimeGet());

      await expectLater(
        animeBloc.stream,
        emitsInOrder([StateAnimeLoading(), StateAnimeError()]),
      );
    });
  });
}
