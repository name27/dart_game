import 'dart:io';
import 'dart:math';

import 'package:dart_game/model/unit.dart';
import 'package:dart_game/model/monster.dart';
import 'package:dart_game/utils/io_util.dart';

class Character extends Unit {
  bool isItemUsed;

  Character({
    required super.name,
    required super.health,
    required super.attack,
    required super.defense,
    this.isItemUsed = false,
  });

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

  @override
  void attackTarget(Unit target) {
    // target이 Monster일 때만 공격
    if (target is Monster) {
      //캐릭터가 캐릭터를 공격하지 않게 확인 작업 ㄷㄷ
      int damage = (attack - target.defense) < 0
          ? 0
          : (attack - target.defense);
      target.health -= damage;
      print("$name이(가) ${target.name}에게 $damage의 데미지를 입혔습니다.\n");
    }
  }

  characterDefend() {
    //방어력만큼 체력을 회복합니다.
    health += defense;
    print("$name이(가) 방어 태세를 취하여 $defense 만큼 체력을 얻었습니다.");
  }

  //30% 확률로 캐릭터의 health를 10 증가시킵니다
  void healthBuff() {
    Random random = Random();
    double chance = random.nextDouble();
    if (chance < 0.3) {
      health += 10;
      print("\n[보너스 체력을 얻었습니다! 현재 체력: $health]");
    }
  }

  //공격력 버프
  void attackBuff() {
    if (!isItemUsed) {
      attack += 10;
      print("한 턴 동안 공격력 버프를 얻었습니다! 현재 공격력: $attack");
      isItemUsed = true;
    }
  }

  //공격력 너프
  void attackDebuff() {
    if (isItemUsed) {
      attack -= 10;
    }
  }
}
