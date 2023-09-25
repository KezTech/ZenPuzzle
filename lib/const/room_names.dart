import 'dart:math';

const kDefaultRoomNames = [
  'जिजीविषा',
  'आशा ',
  'मुदित',
  'मह्यम्',
  'मनस्ताप',
  'मत्तः',
  'भूः',
  'प्रान्त',
  'पराणि',
  'निरर्थकं',
];

String generateDefaultRoomName() =>
    kDefaultRoomNames[Random().nextInt(kDefaultRoomNames.length)];
