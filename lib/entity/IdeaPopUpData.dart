
class IdeaPopUpData {
  static const NONE = IdeaPopUpData("", false);

  final String title;
  final bool isNew;

  const IdeaPopUpData(
    this.title,
    this.isNew,
    );

  bool isValid() => title.isNotEmpty;
}