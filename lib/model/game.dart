import 'dart:io';
import 'dart:math';

import 'package:dart_game/model/character.dart';
import 'package:dart_game/model/monster.dart';
import 'package:dart_game/utils/io_util.dart';

class Game {
  static const int monsterDefenseIncreaseTurn = 3;
  static const int monsterDefenseIncreaseAmount = 2;

  final Character character;
  final List<Monster> monsters;
  int defeatedMonsters;
  bool isVictory;

  Game({
    required this.character,
    required this.monsters,
    required this.defeatedMonsters,
    this.isVictory = false,
  });

  //게임 시작 루프
  Future<void> startGame(Monster monster) async {
    int turnCount = 0;

    while (!character.isDead()) {
      turnCount++;

      // 몬스터 방어력 증가 로직
      if (turnCount == monsterDefenseIncreaseTurn) {
        await _increaseMonsterDefense(monster);
        turnCount = 0;
      }

      await battle(monster);

      // 게임 종료 조건 체크
      if (await _checkGameEndConditions(monster)) {
        return;
      }

      // 몬스터 처치 후 다음 몬스터 선택
      if (monster.isDead()) {
        Monster? nextMonster = await endOrNextGame(monster);
        if (nextMonster != null) {
          monster = nextMonster;
        } else {
          return;
        }
      }
    }
  }

  // 몬스터 방어력 증가
  Future<void> _increaseMonsterDefense(Monster monster) async {
    monster.defense += monsterDefenseIncreaseAmount;
    print("\n${monster.name}의 방어력이 증가합니다! 현재 방어력: ${monster.defense}");
  }

  // 게임 종료 조건 체크
  Future<bool> _checkGameEndConditions(Monster monster) async {
    if (character.isDead()) {
      print("[캐릭터가 사망했습니다. 게임을 종료합니다]");
      isVictory = false;
      await saveResult();
      return true;
    } else if (monsters.isEmpty) {
      print("[모든 몬스터를 물리쳤습니다! 게임을 종료합니다]");
      isVictory = true;
      await saveResult();
      return true;
    }
    return false;
  }

  //게임 종료 || 다음 몬스터 대결
  Future<Monster?> endOrNextGame(Monster monster) async {
    print("\n다음 몬스터와 싸우시겠습니까? 남은 몬스터: ${monsters.length} 마리");
    isVictory = false;
    if (await promptYesNo("계속 진행하시겠습니까?")) {
      print("\n!!!!!!!새로운 몬스터가 나타났습니다!!!!!!!!");
      final random = Random();
      monster = monsters[random.nextInt(monsters.length)];
      monster.showStatus();
      return monster;
    } else {
      print("[게임을 종료합니다]");
      await saveResult();
      return null;
    }
  }

  //게임 결과 저장
  Future<void> saveResult() async {
    if (await promptYesNo("결과를 저장하시겠습니까?")) {
      final file = File('${character.name}.txt');
      await file.writeAsString(
        "캐릭터 이름: ${character.name}, 남은 체력: ${character.health}, 게임 결과: ${isVictory ? "승리" : "패배"}",
      );
      print("[결과를 저장했습니다. 게임을 종료합니다]");
    } else {
      print("[결과를 저장하지 않았습니다. 게임을 종료합니다]");
    }
  }

  //몬스터 대결 루프
  Future<void> battle(Monster monster) async {
    //유저 턴
    await _handlePlayerTurn(monster);

    // 몬스터 처치 확인
    if (monster.isDead()) {
      await _handleMonsterDefeat(monster);
    } else {
      await _handleMonsterTurn(monster);
    }
  }

  // 플레이어 턴 처리
  Future<void> _handlePlayerTurn(Monster monster) async {
    print("\n[${character.name}의 턴]");
    if (!character.isItemUsed) {
      print("아이템 사용 시 한 턴 동안 캐릭터의 공격력이 두 배로 변경됩니다.");
      print("행동을 선택하세요 1. 공격, 2. 방어 ,3. 아이템 사용");
    } else {
      print("행동을 선택하세요 1. 공격, 2. 방어");
    }

    while (true) {
      String action = await promptInput("");
      if (action == '1') {
        character.attackMonster(monster);
        break;
      } else if (action == '2') {
        character.characterDefend();
        break;
      } else if (action == '3' && !character.isItemUsed) {
        character.attackBuff();
        character.attackMonster(monster);
        character.attackDebuff();
        break;
      } else {
        print("잘못 입력하셨습니다");
      }
    }
  }

  // 몬스터 처치 처리
  Future<void> _handleMonsterDefeat(Monster monster) async {
    monsters.remove(monster);
    defeatedMonsters++;
    print("몬스터를 물리쳤습니다! 총 $defeatedMonsters 마리 물리쳤습니다.");
    character.showStatus();
  }

  // 몬스터 턴 처리
  Future<void> _handleMonsterTurn(Monster monster) async {
    int saveCharacterDefense = character.defense;
    if (monster.defenseDebuff(character)) {
      monster.attackTarget(character);
      character.showStatus();
      monster.showStatus();
      character.defense = saveCharacterDefense;
      print("\n[방어력이 원래대로 돌아왔습니다! 현재 방어력: ${character.defense}]");
      return;
    }
    monster.attackTarget(character);
    character.showStatus();
    monster.showStatus();
  }

  Monster getRandomMonster() {
    print("\n!!!!!!새로운 몬스터가 나타났습니다!!!!!!");
    final random = Random();
    Monster randomMonster = monsters[random.nextInt(monsters.length)];
    randomMonster.showStatus();
    return randomMonster;
  }
}
