<h1 align="center">
  <br>
  <a href=""><img src="https://user-images.githubusercontent.com/4879766/86593020-75942500-bfcf-11ea-8980-a96d5e6ba472.png" alt="Yellow Box" width="200"></a>
  <br>
  Yellow Box
  <br>
</h1>

<h3 align="center">A brainstorming app made with <a href="https://flutter.dev" target="_blank">Flutter</a>. Supports English and Korean.</h3>

<p align="center">
  <a href="#screenshots">Screenshots</a> •
  <a href="#download">Download</a> •
  <a href="#description">Description</a> •
  <a href="#feedback">Feedback</a> •
  <a href="#license">License</a> •
</p>

## Screenshots

<img src="https://user-images.githubusercontent.com/4879766/87249466-3ddb2080-c49a-11ea-85b6-c8d17bd478c5.gif" width="200" />

<p float="left">
  <img src="https://user-images.githubusercontent.com/4879766/86593214-c4da5580-bfcf-11ea-8b07-0e70cfe20414.png" width="150" />
  <img src="https://user-images.githubusercontent.com/4879766/86593253-d4f23500-bfcf-11ea-91ea-942deac11906.png" width="150" /> 
  <img src="https://user-images.githubusercontent.com/4879766/86593296-ea675f00-bfcf-11ea-8484-ef705abc96ea.png" width="150" />
  <img src="https://user-images.githubusercontent.com/4879766/86593305-edfae600-bfcf-11ea-85d6-88638088fc73.png" width="150" />
</p>

## Download

<a href='https://play.google.com/store/apps/details?id=com.giantsol.yellow_box'>
  <img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png' width='200'/>
</a>

## Description

Simple brainstorming app built with Flutter and BLoC pattern. This app largely demonstrates:

1. applying BLoC and Clean Architecture in Flutter app.
2. using MethodChannel to communicate with native Android code.
3. using intricate animations.
4. adding tutorial.
5. applying localizations.

Everything runs locally, so it's easy to setup and run for yourself: clone the repository, run ```flutter pub get``` from the cloned directory, and run the app.

Code is largely divided into five packages: **ui**, **usecase**, **entity**, **repository**, and **datasource**. It's implemented in the way I follow clean architecture.

The floating button shown in the last screenshot above is implemented in native Android using [Flutter's MethodChannel](https://flutter.dev/docs/development/platform-integration/platform-channels). Related code is largely in [MiniBoxRepository](https://github.com/giantsol/Yellow-Box/blob/master/lib/repository/MiniBoxRepository.dart).

## Feedback

Feel free to leave any feedback!

Email: giantsol64@gmail.com

## License

MIT
