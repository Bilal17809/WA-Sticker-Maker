import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import '/presentation/splash/view/splash_view.dart';
import 'core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ProviderScope(child: const WaStickerMaker()));
}

class WaStickerMaker extends ConsumerWidget {
  const WaStickerMaker({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learn Japanese',
        theme: AppTheme.lightTheme,
        home: const SplashView(),
      ),
    );
  }
}
