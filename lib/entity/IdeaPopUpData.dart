
class IdeaPopUpData {
  static const NONE = IdeaPopUpData("", 0);
  static const TYPE_NEW = 0;
  static const TYPE_EXISTS = 1;
  static const TYPE_BLOCKED = 2;

  final String title;
  final int type;

  const IdeaPopUpData(
    this.title,
    this.type,
    );

  bool isValid() => title.isNotEmpty;
}