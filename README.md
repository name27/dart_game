# 전투 RPG 게임

간단한 콘솔 기반 RPG 게임입니다.
플레이어는 캐릭터를 생성하고, 여러 몬스터와 차례로 전투를 벌입니다.
승리 또는 패배 시 결과를 파일로 저장할 수 있습니다.

---

## 폴더 구조

```
dart_game/
  bin/
    dart_game.dart         # 메인 실행 파일
  lib/
    model/                 # 게임 주요 클래스 (Character, Monster, Game 등)
    utils/
      io_util.dart         # 입출력/유효성 검사 유틸 함수
  assets/
    characters.txt         # 캐릭터 기본 능력치 데이터
    monsters.txt           # 몬스터 데이터
  test/
    dart_game_test.dart    # 테스트 코드
  README.md
  pubspec.yaml
```

---

## 실행 방법

1. **의존성 설치**

   ```
   dart pub get
   ```

2. **게임 실행**
   ```
   dart run bin/dart_game.dart
   ```

---

## 주요 기능

- **캐릭터 생성**: 이름 입력 및 능력치 로드
- **몬스터와 전투**: 공격/방어 선택, 몬스터 랜덤 등장
- **결과 저장**: 게임 종료 후 결과를 파일로 저장할 수 있음
- **입출력/유효성 검사**: 모든 입력은 유틸 함수로 일원화

---

## 데이터 파일 포맷

- `assets/characters.txt`

  ```
  50,10,5
  ```

  (체력, 공격력, 방어력)

- `assets/monsters.txt`
  ```
  Batman,30,20
  Spiderman,20,30
  Superman,30,10
  ```
  (이름, 체력, 최대공격력)

---

---

## 학습 기록

- https://www.notion.so/Flutter-3377d32b3bda4878abd1bb2763b523fa
