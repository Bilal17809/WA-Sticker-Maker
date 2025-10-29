import 'utils.dart';

class FeatureUtil {
  static final carouselItems = [
    {'title': 'Gallery', 'lottiePath': Assets.galleryLottie},
    {'title': 'Library', 'lottiePath': Assets.libraryLottie},
  ];
  static final List<Map<String, dynamic>> gridList = [
    {
      'title': 'AI Generator',
      'lottie': Assets.aiLottie,
      'route': 'ai-generator',
    },
    {
      'title': 'Sticker Store',
      'lottie': Assets.storeLottie,
      'route': 'sticker-store',
    },
  ];
}
