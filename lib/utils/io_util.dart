import 'dart:io';

/// y/n 입력을 받아 true/false로 반환
Future<bool> promptYesNo(String message) async {
  while (true) {
    stdout.write('$message (y/n): ');
    String? input = stdin.readLineSync();
    if (input == null) continue;
    if (input.toLowerCase() == 'y') return true;
    if (input.toLowerCase() == 'n') return false;
    print('잘못 입력하셨습니다. 다시 입력해주세요.');
  }
}

/// 일반 문자열 입력
Future<String> promptInput(
  String message, {
  String? Function(String)? validator,
}) async {
  while (true) {
    stdout.write('$message: ');
    String? input = stdin.readLineSync();
    if (input == null || input.isEmpty) {
      print('입력이 비어 있습니다. 다시 입력해주세요.');
      continue;
    }
    if (validator != null) {
      final error = validator(input);
      if (error != null) {
        print(error);
        continue;
      }
    }
    return input;
  }
}

/// 에러 메시지 출력
void printError(String message) {
  stderr.writeln('[에러] $message');
}
