import 'dart:io';
import 'dart:math';

import 'package:dart_game/model/character.dart';
import 'package:dart_game/model/monster.dart';

class Game {
  //캐릭터 (`Character`)
  //몬스터 리스트 (`List<Monster>`)
  //물리친 몬스터 개수(`int`) - 몬스터 리스트의 개수보다 클 수 없습니다.
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

  void startGame(Monster monster) async {
    //캐릭터의 체력이 0 이하가 되면 **게임이 종료**됩니다.
    //몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택할 수 있습니다.
    //예) “다음 몬스터와 대결하시겠습니까? (y/n)”
    //설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 **승리**합니다.

    while (character.health > 0) {
      battle(monster);

      //상태 표시
      character.showStatus();
      monster.showStatus();

      if (character.health <= 0) {
        print("캐릭터가 사망하였습니다. 게임을 종료합니다");
        isVictory = false;
        saveResult();
        return;
      } else if (monsters.isEmpty) {
        print("모든 몬스터를 물리쳤습니다! 게임을 종료합니다");
        isVictory = true;
        saveResult();
        return;
      } else if (monster.health <= 0) {
        monster = endOrNextGame(monster);
      }
    }
  }

  Monster endOrNextGame(Monster monster) {
    print("다음 몬스터와 싸우시겠습니까? 남은 몬스터: ${monsters.length}마리 (y/n)");
    isVictory = false;
    while (true) {
      String? continueYesNo = stdin.readLineSync() ?? '';
      if (continueYesNo == 'y' || continueYesNo == 'Y') {
        print("\n!!!!!!!새로운 몬스터가 나타났습니다!!!!!!!!");
        final random = Random();
        monster = monsters[random.nextInt(monsters.length)];
        monster.showStatus();
        return monster;
      } else if (continueYesNo == 'n' || continueYesNo == 'N') {
        print("게임을 종료합니다");
        saveResult();
        return monster;
      } else {
        print("잘못 입력하셨습니다 다시 입력해주세요 (y/n)?");
      }
    }
  }

  saveResult() {
    print("결과를 저장하시겠습니까? (y/n)");
    var saveYesNo = stdin.readLineSync() ?? '';
    if (saveYesNo == 'y' || saveYesNo == 'Y') {
      final file = File('${character.name}.txt');
      file.writeAsStringSync(
        "캐릭터 이름: ${character.name}, 남은 체력: ${character.health}, 게임 결과: ${isVictory ? "승리" : "패배"}",
      );
      print("결과를 저장했습니다");
    } else if (saveYesNo == 'n' || saveYesNo == 'N') {
      print("결과를 저장하지 않았습니다");
    } else {
      print("잘못 입력하셨습니다 다시 입력해주세요 (y/n)?");
    }
  }

  battle(Monster monster) {
    //게임 중에 사용자는 매 턴마다 **행동을 선택**할 수 있습니다.
    //예) 공격하기(1), 방어하기(2)
    //매 턴마다 몬스터는 사용자에게 공격만 가합니다.
    //캐릭터는 몬스터 리스트에 있는 몬스터들 중 랜덤으로 뽑혀서 **대결을** 합니다.
    //처치한 몬스터는 몬스터 리스트에서 삭제되어야 합니다.
    //캐릭터의 체력은 대결 **간에 누적**됩니다.
    print("\n${character.name}의 턴");
    print("현재 캐릭터의 남은 체력: ${character.health}");
    print("공격에 성공 시 몬스터의 남은 체력: ${monster.health - character.attack}");
    print("행동을 선택하세요 1. 공격, 2. 방어: ");
    while (true) {
      String? action = stdin.readLineSync() ?? '';
      if (action == '1') {
        character.attackTarget(monster);
        break;
      } else if (action == '2') {
        character.characterDefend();
        break;
      } else {
        print("잘못 입력하셨습니다");
      }
    }

    //몬스터 공격 턴 시작
    monster.attackTarget(character);

    if (monster.health <= 0) {
      monsters.remove(monster);
      defeatedMonsters++;
      print("몬스터를 물리쳤습니다! 총 $defeatedMonsters 마리 물리쳤습니다.");
    }
  }

  Monster getRandomMonster() {
    //Random() 을 사용하여 몬스터 리스트에서 랜덤으로 몬스터를 반환하여 대결합니다.
    print("\n!!!!!!새로운 몬스터가 나타났습니다!!!!!!");
    final random = Random();
    Monster randomMonster = monsters[random.nextInt(monsters.length)];

    //몬스터 상태 표시
    randomMonster.showStatus();
    return randomMonster;
  }
}
