import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toastification/toastification.dart';
import '/presentation/splash/view/splash_view.dart';
import 'core/theme/theme.dart';
import 'core/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  OnesignalService.init();
  runApp(ProviderScope(child: const WaStickerMaker()));
}

class WaStickerMaker extends ConsumerWidget {
  const WaStickerMaker({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WA Sticker Maker',
        theme: AppTheme.lightTheme,
        home: const SplashView(),
      ),
    );
  }
}
