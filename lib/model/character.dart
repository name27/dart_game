import 'dart:io';
import 'dart:math';

import 'package:dart_game/model/unit.dart';
import 'package:dart_game/model/monster.dart';
import 'package:dart_game/utils/io_util.dart';

class Character extends Unit {
  static const double healthBuffChance = 0.3;
  static const int healthBuffAmount = 10;
  static const int attackBuffAmount = 10;

  bool isItemUsed;

  Character({
    required super.name,
    required super.health,
    required super.attack,
    required super.defense,
    this.isItemUsed = false,
  });

  //캐릭터 데이터 불러오기
  static Future<Character> loadCharacterStats() async {
    try {
      final file = File('assets/characters.txt');
      final contents = await file.readAsString();
      final stats = contents.split(',');
      if (stats.length != 3) throw FormatException('Invalid character data');

      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      String name = await getCharacterName();
      Character character = Character(
        name: name,
        health: health,
        attack: attack,
        defense: defense,
      );
      return character;
    } catch (e) {
      printError('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  //캐릭터 이름 입력, 검증
  static Future<String> getCharacterName() async {
    return await promptInput(
      '캐릭터 이름을 입력하세요',
      validator: (name) {
        if (RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
          return null;
        } else {
          return '잘못 입력하셨습니다. 다시 입력해주세요.\n영문(대·소문자) 또는 한글로만 이루어진 1글자 이상 문자열 (숫자, 특수문자, 공백 불가)';
        }
      },
    );
  }

  // Monster만 공격할 수 있도록 메서드 시그니처 변경
  void attackMonster(Monster monster) {
    int damage = calculateDamage(attack, monster.defense);
    monster.takeDamage(damage);
    print("$name이(가) ${monster.name}에게 $damage의 데미지를 입혔습니다.\n");
  }

  // Unit 클래스의 attackTarget 메서드 오버라이드 (타입 안전성을 위해)
  @override
  void attackTarget(Unit target) {
    if (target is Monster) {
      attackMonster(target);
    } else {
      print("캐릭터는 몬스터만 공격할 수 있습니다.");
    }
  }

  characterDefend() {
    //방어력만큼 체력을 회복
    heal(defense);
    print("$name이(가) 방어 태세를 취하여 $defense 만큼 체력을 얻었습니다.");
  }

  //30% 확률로 캐릭터의 health를 10 증가
  void healthBuff() {
    Random random = Random();
    double chance = random.nextDouble();
    if (chance < healthBuffChance) {
      heal(healthBuffAmount);
      print("\n[보너스 체력을 얻었습니다! 현재 체력: $health]");
    }
  }

  //공격력 버프
  void attackBuff() {
    if (!isItemUsed) {
      attack += attackBuffAmount;
      print("한 턴 동안 공격력 버프를 얻었습니다! 현재 공격력: $attack");
      isItemUsed = true;
    }
  }

  //공격력 너프
  void attackDebuff() {
    if (isItemUsed) {
      attack -= attackBuffAmount;
    }
  }
}
