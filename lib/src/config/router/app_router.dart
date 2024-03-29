import 'package:anime_list/src/presentation/views/screen/home_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/views/screen/anime_navigation_screen.dart';
import '../../presentation/views/page/anime_page.dart';
import '../../presentation/views/page/manga_page.dart';
import '../../presentation/views/screen/detail_anime_screen.dart';
import '../../presentation/views/screen/empty_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          path: '/',
          initial: true,
          children: [
            AutoRoute(
              page: AnimeNavigationRoute.page,
              path: 'anime',
              children: [
                AutoRoute(
                  page: AnimeRoute.page,
                  path: 'anime-list',
                  initial: true,
                  children: [
                    AutoRoute(
                      page: EmptyRoute.page,
                      path: 'empty',
                      initial: true,
                    ),
                    AutoRoute(
                      page: DetailAnimeRoute.page,
                      path: 'detail-anime/:malId/episodes/:episodes/synopsis/:synopsis',
                    ),
                  ],
                ),
                AutoRoute(
                  page: DetailAnimeRoute.page,
                  path: 'detail-anime/:malId/episodes/:episodes/synopsis/:synopsis',
                ),
              ],
            ),
            AutoRoute(
              page: MangaRoute.page,
              path: 'manga',
            ),
          ],
        ),
      ];
}

final appRouter = AppRouter();
