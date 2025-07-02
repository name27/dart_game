import 'package:dart_game/model/character.dart';
import 'package:dart_game/model/game.dart';
import 'package:dart_game/model/monster.dart';

Future<void> main() async {
  Character character = await Character.loadCharacterStats();
  Game game = Game(
    character: character,
    monsters: await Monster.loadMonsterStats(),
    defeatedMonsters: 0,
  );

  print("\n[게임을 시작합니다!]");
  character.showStatus();
  character.healthBuff();
  await game.startGame(game.getRandomMonster());
}
