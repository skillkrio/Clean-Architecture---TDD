import 'dart:io';

String fixture(String jsonFileName) =>
    File('test/fixtures/$jsonFileName').readAsStringSync();
