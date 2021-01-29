import 'dart:io';
import 'dart:math';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/adids.dart';

class FBAdUtils {
  static String _andBannerPid = AdIds.fbandBannerPid;
  static String _iosBannerPid = AdIds.fbiosBannerPid;
  static String _andIntPid = AdIds.fbandIntPid;
  static String _iosIntPid = AdIds.fbiosIntPid;
  static String get bannerId =>
      Platform.isAndroid ? _andBannerPid : _iosBannerPid;
  static String get intId => Platform.isAndroid ? _andIntPid : _iosIntPid;
  static Widget banner() {
    return FacebookBannerAd(
      bannerSize: BannerSize.MEDIUM_RECTANGLE,
      placementId: bannerId,
      listener: (t, q) {},
    );
  }

  static showAd() {
    Random random = Random();
    if (random.nextBool() && random.nextBool()) {
      return;
    }
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: intId,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd();
      },
    );
  }
}
