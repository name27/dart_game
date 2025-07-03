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

  // 데미지 계산 메서드
  int calculateDamage(int attackerAttack, int targetDefense) {
    int damage = (attackerAttack - targetDefense);
    return damage > targetDefense ? damage : targetDefense;
  }

  // 체력이 0 이하인지 확인
  bool isDead() {
    return health <= 0;
  }

  // 체력 회복 메서드
  void heal(int amount) {
    health += amount;
  }

  // 데미지 받기 메서드
  void takeDamage(int damage) {
    health -= damage;
    if (health < 0) health = 0;
  }

  void attackTarget(Unit target);
}
