import 'package:flutter/material.dart';

typedef ConstrainedBuilder = Widget Function(
  BuildContext context,
  BoxConstraints costraints,
);

class ConstrainedLayout extends StatelessWidget {
  final ConstrainedBuilder builder;
  const ConstrainedLayout(this.builder, {Key key})
      : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return builder(context, constraints);
      }),
    );
  }
}
