import 'dart:io';
import 'dart:math';

import 'package:dart_game/model/character.dart';
import 'package:dart_game/model/unit.dart';
import 'package:dart_game/utils/io_util.dart';

class Monster extends Unit {
  static const double defenseDebuffChance = 0.3;

  final int maxAttack;

  //   - 이름 (`String`)
  // - 체력 (`int`)
  // - 랜덤으로 지정할 공격력 범위 최대값 (`int`)
  // → 몬스터의 공격력은 캐릭터의 방어력보다 작을 수 없습니다. 랜덤으로 지정하여 캐릭터의 방어력과 랜덤 값 중 최대값으로 설정해주세요.
  // - 방어력(`int`) = 0
  // → 몬스터의 방어력은 0이라고 가정합니다.
  Monster({
    required super.name,
    required super.health,
    required super.attack,
    required this.maxAttack,
  }) : super(defense: 0);

  static Future<List<Monster>> loadMonsterStats() async {
    try {
      List<Monster> monsters = [];
      final file = File('assets/monsters.txt');
      final lines = await file.readAsString();
      for (final line in lines.split('\n')) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts.length != 3) {
          throw FormatException('Invalid monster data in line: $line');
        }

        final name = parts[0];
        final health = int.parse(parts[1]);
        final maxAttack = int.parse(parts[2]);

        Monster monster = Monster(
          name: name,
          health: health,
          attack: maxAttack, // 초기 공격력은 maxAttack으로 설정
          maxAttack: maxAttack,
        );
        monsters.add(monster);
      }
      return monsters;
    } catch (e) {
      printError('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  @override
  void attackTarget(Unit target) {
    final random = Random();
    int randomAttack = maxAttack > 0 ? random.nextInt(maxAttack) + 1 : 1;

    int damage = calculateDamage(randomAttack, target.defense);
    target.takeDamage(damage);
    print("\n[$name의 턴]");
    print("$name이(가) ${target.name}에게 $damage 데미지를 입혔습니다.\n");
  }

  //캐릭터 방어력 너프
  bool defenseDebuff(Character character) {
    Random random = Random();
    double chance = random.nextDouble();
    if (chance < defenseDebuffChance) {
      character.defense = 0;
      print("\n[한 턴 동안 $name이(가) 방어력을 무력화시켰습니다! 현재 방어력: ${character.defense}]");
      return true;
    }
    return false;
  }
}
