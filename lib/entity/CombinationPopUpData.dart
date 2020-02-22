
class CombinationPopUpData {
  static const NONE = CombinationPopUpData("", false);

  final String combination;
  final bool isNew;

  const CombinationPopUpData(
    this.combination,
    this.isNew,
    );

  bool isValid() => combination.isNotEmpty;
}