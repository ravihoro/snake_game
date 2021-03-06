class Ticker {
  Stream<int> tick() {
    return Stream.periodic(Duration(milliseconds: 250), (x) {
      return 1;
    });
  }
}
