abstract class EventAnime {}

class EventAnimeGet extends EventAnime {}

class EventAnimeGetSeasonNow extends EventAnime {
  final int page;

  EventAnimeGetSeasonNow(this.page);
}

class EventDetailAnimeGet extends EventAnime {
  final int malId;

  EventDetailAnimeGet(this.malId);
}

class EventGetAnimeCharacters extends EventAnime {
  final int animeId;

  EventGetAnimeCharacters(this.animeId);
}
