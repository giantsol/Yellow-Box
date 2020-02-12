
import 'package:flutter/widgets.dart';
import 'package:yellow_box/ui/home/HomeBloc.dart';
import 'package:yellow_box/ui/home/HomeState.dart';

class HomeScreen extends StatefulWidget {

  @override
  State createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Widget _buildUI(HomeState state) {
    return Container(
      child: Center(
        child: Text('HomeScreen'),
      ),
    );
  }

}
