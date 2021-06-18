import 'package:async/async.dart';
import 'package:flutter/material.dart';

class FutureBuilderSuccess extends StatefulWidget {
  final Widget? child;
  final Future future;

  const FutureBuilderSuccess({Key? key, this.child, required this.future})
      : super(key: key);

  @override
  _FutureBuilderSuccessState createState() => _FutureBuilderSuccessState();
}

class _FutureBuilderSuccessState extends State<FutureBuilderSuccess> {
  AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getFuture(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return widget.child ?? Container();
          } else {
            return Container();
          }
        }
    );
  }

  Future<void> _getFuture() {
    return _memoizer.runOnce(() async => await widget.future);
  }
}
