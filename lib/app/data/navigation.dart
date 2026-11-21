import 'package:e1547/follow/follow.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:e1547/topic/topic.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';

const String _drawerSearchGroup = 'search';
const String _drawerFollowsGroup = 'follows';
const String _drawerCollectionsGroup = 'collections';
const String _drawerSettingsGroup = 'settings';

final List<RouterDrawerDestination> rootDestintations = [
  NamedRouterDrawerDestination(
    path: '/',
    name: 'Home',
    icon: const Icon(Icons.home),
    builder: (context) => const HomePage(),
    unique: true,
    group: _drawerSearchGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/hot',
    name: 'Hot',
    icon: const Icon(Icons.whatshot),
    builder: (context) => const HotPage(),
    unique: true,
    group: _drawerSearchGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/search',
    name: 'Search',
    icon: const Icon(Icons.search),
    builder: (context) => const PostsPage(),
    group: _drawerSearchGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/favorites',
    name: 'Favorites',
    icon: const Icon(Icons.favorite),
    builder: (context) => const FavPage(),
    unique: true,
    group: _drawerFollowsGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/timeline',
    name: 'Timeline',
    icon: const Icon(Icons.feed),
    builder: (context) => const FollowsTimelinePage(),
    unique: true,
    group: _drawerFollowsGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/subscriptions',
    name: 'Subscriptions',
    icon: const Icon(Icons.person_add),
    builder: (context) => const FollowsSubscriptionsPage(),
    unique: true,
    group: _drawerFollowsGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/bookmarks',
    name: 'Bookmarks',
    icon: const Icon(Icons.bookmark),
    builder: (context) => const FollowsBookmarkPage(),
    unique: true,
    group: _drawerFollowsGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/pools',
    name: 'Pools',
    icon: const Icon(Icons.collections),
    builder: (context) => const PoolsPage(),
    unique: true,
    group: _drawerCollectionsGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/forum',
    name: '论坛',
    icon: const Icon(Icons.forum),
    builder: (context) => const TopicsPage(),
    unique: true,
    group: _drawerCollectionsGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/history',
    name: 'History',
    icon: const Icon(Icons.history),
    builder: (context) => const HistoriesPage(),
    group: _drawerSettingsGroup,
  ),
  RouterDrawerDestination(
    path: '/blacklist',
    builder: (context) => const DenyListPage(),
  ),
  NamedRouterDrawerDestination(
    path: '/tasks',
    name: 'Tasks',
    icon: const Icon(Icons.task_alt),
    builder: (context) => const TasksPage(),
    enabled: _nonRecursive<TasksPage>,
    group: _drawerSettingsGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/settings',
    name: 'Settings',
    icon: const Icon(Icons.settings),
    builder: (context) => const SettingsPage(),
    enabled: _nonRecursive<SettingsPage>,
    group: _drawerSettingsGroup,
  ),
  NamedRouterDrawerDestination(
    path: '/about',
    name: 'About',
    icon: const DrawerUpdateIcon(),
    builder: (context) => const AboutPage(),
    group: _drawerSettingsGroup,
  ),
];

bool _nonRecursive<T extends Widget>(BuildContext context) =>
    context.findAncestorWidgetOfExactType<T>() == null;
