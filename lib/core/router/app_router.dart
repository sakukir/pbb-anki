import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocard/presentation/pages/home/home_page.dart';
import 'package:mocard/presentation/pages/deck/deck_list_page.dart';
import 'package:mocard/presentation/pages/deck/deck_detail_page.dart';
import 'package:mocard/presentation/pages/deck/deck_form_page.dart';
import 'package:mocard/presentation/pages/card/card_form_page.dart';
import 'package:mocard/presentation/pages/review/review_page.dart';
import 'package:mocard/presentation/pages/review/review_summary_page.dart';
import 'package:mocard/presentation/pages/search/search_page.dart';
import 'package:mocard/presentation/pages/stats/stats_page.dart';
import 'package:mocard/presentation/pages/settings/settings_page.dart';

/// 路由路径常量
class AppRoutes {
  static const home = '/';
  static const decks = '/decks';
  static const deckDetail = '/decks/:deckId';
  static const deckCreate = '/decks/new';
  static const deckEdit = '/decks/:deckId/edit';
  static const cardCreate = '/decks/:deckId/cards/new';
  static const cardEdit = '/decks/:deckId/cards/:cardId/edit';
  static const review = '/review';
  static const reviewSummary = '/review/summary';
  static const search = '/search';
  static const stats = '/stats';
  static const settings = '/settings';
}

/// 底部导航壳页面
class ShellPage extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const ShellPage({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onTap(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              activeIcon: Icon(Icons.folder),
              label: '卡组',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: '统计',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.decks);
        break;
      case 2:
        context.go(AppRoutes.stats);
        break;
      case 3:
        context.go(AppRoutes.settings);
        break;
    }
  }
}

/// 路由配置
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    // ── 底部导航页面 ──
    ShellRoute(
      builder: (context, state, child) {
        int index = 0;
        final location = state.uri.path;
        if (location.startsWith('/decks')) {
          index = 1;
        } else if (location.startsWith('/stats')) {
          index = 2;
        } else if (location.startsWith('/settings')) {
          index = 3;
        }
        return ShellPage(currentIndex: index, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/decks',
          builder: (context, state) => const DeckListPage(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const DeckFormPage(),
            ),
            GoRoute(
              path: ':deckId',
              builder: (context, state) {
                final deckId = state.pathParameters['deckId']!;
                return DeckDetailPage(deckId: deckId);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final deckId = state.pathParameters['deckId']!;
                    return DeckFormPage(deckId: deckId);
                  },
                ),
                GoRoute(
                  path: 'cards/new',
                  builder: (context, state) {
                    final deckId = state.pathParameters['deckId']!;
                    return CardFormPage(deckId: deckId);
                  },
                ),
                GoRoute(
                  path: 'cards/:cardId/edit',
                  builder: (context, state) {
                    final deckId = state.pathParameters['deckId']!;
                    final cardId = state.pathParameters['cardId']!;
                    return CardFormPage(deckId: deckId, cardId: cardId);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
    // ── 全屏页面（无底部导航） ──
    GoRoute(
      path: '/review',
      builder: (context, state) {
        final deckId = state.uri.queryParameters['deckId'];
        return ReviewPage(deckId: deckId);
      },
    ),
    GoRoute(
      path: '/review/summary',
      builder: (context, state) => const ReviewSummaryPage(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
  ],
);
