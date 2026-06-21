import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'screens/connect_screen.dart';
import 'screens/history_screen.dart';
import 'screens/live_screen.dart';
import 'theme.dart';

void main() => runApp(const ProviderScope(child: FirepawApp()));

class FirepawApp extends StatelessWidget {
  const FirepawApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firepaw',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(bleControllerProvider).connected != null;
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          ConnectScreen(onConnected: () => setState(() => _index = 1)),
          const LiveScreen(),
          const HistoryScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.surfaceHigh)),
          boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, -4))],
        ),
        child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppColors.primary.withValues(alpha: 0.14),
          labelTextStyle: WidgetStatePropertyAll(AppTheme.labelCaps(size: 10)),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            const NavigationDestination(icon: Icon(Icons.bluetooth_searching), label: 'CONNECT'),
            NavigationDestination(
              icon: Icon(connected ? Icons.speed : Icons.speed_outlined),
              label: 'LIVE',
            ),
            const NavigationDestination(icon: Icon(Icons.history), label: 'HISTORY'),
          ],
        ),
      ),
      ),
    );
  }
}
