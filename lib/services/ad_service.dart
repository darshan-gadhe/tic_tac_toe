import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // Use test IDs for development. Replace with your own IDs before publishing.
  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-5338834409326278/2365228943'
      : 'ca-app-pub-5338834409326278/2365228943';

  static String get interstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-5338834409326278/7983724421'
      : 'ca-app-pub-5338834409326278/7983724421';

  static String get rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-5338834409326278/4403134698'
      : 'ca-app-pub-5338834409326278/4403134698';

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  /// Loads an interstitial ad.
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('InterstitialAd loaded.');
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  /// Shows the interstitial ad if it's loaded.
  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: Interstitial ad is not loaded yet.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd(); // Pre-load the next one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  /// Loads a rewarded ad.
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          print('RewardedAd loaded.');
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  /// Shows the rewarded ad if it's loaded.
  void showRewardedAd({required Function onReward}) {
    if (_rewardedAd == null) {
      print('Warning: Rewarded ad is not loaded yet.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd(); // Pre-load the next one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadRewardedAd();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      print('Reward earned: ${reward.amount} ${reward.type}');
      onReward();
    });
    _rewardedAd = null;
  }
} // <-- THE FIX: THIS BRACE WAS MISSING