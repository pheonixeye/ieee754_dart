<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

JS implementation of ieee754.

## Features

Contains two methods to read and write.

## Getting started

Use this package as a library
Depend on it
Run this command:

With Dart:
 $ dart pub add ieee754_dart

With Flutter:
 $ flutter pub add ieee754_dart

This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):

dependencies:
  ieee754_dart: ^0.0.1

Alternatively, your editor might support dart pub get or flutter pub get. Check the docs for your editor to learn more.

Import it
Now in your Dart code, you can use:

import 'package:ieee754_dart/ieee754_dart.dart';

## Usage

The `Ieee754` class has the following functions:

```
Ieee754.read = function (buffer, offset, isLE, mLen, nBytes)
Ieee754.write = function (buffer, value, offset, isLE, mLen, nBytes)
```

The arguments mean the following:

- buffer = the buffer(Uint8List)
- offset = offset into the buffer
- value = value to set (only for `write`)
- isLe = is little endian?
- mLen = mantissa length
- nBytes = number of bytes

## Additional information

The IEEE Standard for Floating-Point Arithmetic (IEEE 754) is a technical standard for floating-point computation. [Read more](http://en.wikipedia.org/wiki/IEEE_floating_point).
