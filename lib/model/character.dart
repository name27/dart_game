import 'dart:io';

import 'package:dart_game/model/abstract.dart';
import 'package:dart_game/model/monster.dart';

class Character extends Unit {
  Character({
    required super.name,
    required super.health,
    required super.attack,
    required super.defense,
  });

  static Future<Character> loadCharacterStats() async {
    try {
      final file = File('lib/utils/characters.txt');
      final contents = await file.readAsStringSync();
      final stats = contents.split(',');
      if (stats.length != 3) throw FormatException('Invalid character data');

      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      String name = getCharacterName();
      Character character = Character(
        name: name,
        health: health,
        attack: attack,
        defense: defense,
      );
      return character;
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  static String getCharacterName() {
    while (true) {
      print('캐릭터 이름을 입력하세요:');
      String? name = stdin.readLineSync() ?? '';
      if (RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
        return name;
      } else {
        print("잘못 입력하셨습니다 다시 입력해주세요");
        print("영문(대·소문자) 또는 한글로만 이루어진 1글자 이상 문자열 (숫자, 특수문자, 공백 불가)");
      }
    }
  }

  @override
  void attackTarget(Unit target) {
    // target이 Monster일 때만 공격
    if (target is Monster) {
      target.health -= attack;
      print("${name}이(가) ${target.name}에게 ${attack}의 데미지를 입혔습니다.\n");
    }
  }

  characterDefend() {
    //방어력만큼 체력을 회복합니다.
    health += defense;
    print("${name}이(가) 방어 태세를 취하여 ${defense} 만큼 체력을 얻었습니다.\n");
  }
}
