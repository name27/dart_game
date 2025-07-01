abstract class Unit {
  String name;
  int health;
  int attack;
  int defense;

  Unit({
    required this.name,
    required this.health,
    required this.attack,
    required this.defense,
  });

  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack, 방어력: $defense");
  }

  void attackTarget(Unit target);
}
