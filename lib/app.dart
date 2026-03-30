import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocard/core/theme/app_theme.dart';
import 'package:mocard/core/router/app_router.dart';
import 'package:mocard/core/constants/app_constants.dart';

class MoCardApp extends ConsumerWidget {
  const MoCardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
