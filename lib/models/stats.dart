class Satitics {
  String name;
  int count;

  Satitics(this.name, this.count);

  @override
  String toString() {
    return '{ ${this.name}, ${this.count} }';
  }
}
