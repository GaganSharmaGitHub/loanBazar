class ExUser {
  String name, profession;
  num income;
  List favourites;
  ExUser({
    this.favourites,
    this.income,
    this.name,
    this.profession,
  });
  Map<String, dynamic> toMap() {
    Map<String, dynamic> p = {
      'favourites': favourites ?? [],
      'income': income ?? 1000,
      'name': name,
      'profession': profession
    };
    return p;
  }

  static ExUser fromMap(Map p) {
    return ExUser(
        favourites: p['favourites'],
        income: p['income'],
        name: p['name'],
        profession: p['profession']);
  }
}
