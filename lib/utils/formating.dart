extension loanUIext on num {
  String toCurrecyWords() {
    double ok = this.ceilToDouble();
    if (ok < 1000) {
      return '$ok';
    }
    if (ok < 100000) {
      ok = (ok / 1000).roundToDouble();
      return '$ok K';
    }
    if (ok < 10000000) {
      ok = (ok / 100000).roundToDouble();
      return '$ok L';
    }
    ok = (ok / 10000000).roundToDouble();
    return '$ok Cr';
  }

  double roundTwoPlaces() {
    return (this * 100).ceil() / 100;
  }
}
