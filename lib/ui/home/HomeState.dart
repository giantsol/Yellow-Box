
class HomeState {
  final String title;

  const HomeState({
    this.title = '',
  });

  HomeState buildNew({
    String title,
  }) {
    return HomeState(
      title: title ?? this.title,
    );
  }
}