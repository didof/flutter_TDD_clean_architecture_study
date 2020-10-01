import 'package:TDD_clean_architecture/core/util/presentation/constrained_layout.dart';
import 'package:TDD_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:TDD_clean_architecture/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:TDD_clean_architecture/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: ConstrainedLayout((context, constraints) {
        return BlocProvider(
          create: (context) => sl<NumberTriviaBloc>(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                _NumberTriviaDisplay(constraints),
                _NumberTriviaCockpit(constraints),
              ],
            ),
          ),
        );
      }),
      resizeToAvoidBottomInset: true,
    );
  }
}

class _NumberTriviaCockpit extends StatefulWidget {
  final BoxConstraints constraints;
  const _NumberTriviaCockpit(
    this.constraints, {
    Key key,
  }) : super(key: key);

  @override
  __NumberTriviaCockpitState createState() => __NumberTriviaCockpitState();
}

class __NumberTriviaCockpitState extends State<_NumberTriviaCockpit> {
  String inputString;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.constraints.maxWidth,
      height: widget.constraints.maxHeight / 2 - 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              inputString = value;
            },
            onSubmitted: (_) => dispatchConcrete(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input a positive integer',
            ),
            keyboardType: TextInputType.number,
            enableSuggestions: true,
            textInputAction: TextInputAction.search,
            controller: _controller,
          ),
          Container(
            width: widget.constraints.maxWidth,
            height: widget.constraints.maxHeight / 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: dispatchConcrete,
                  label: Text('Search'),
                  icon: Icon(Icons.search),
                  color: Theme.of(context).primaryColor,
                ),
                RaisedButton.icon(
                  onPressed: dispatchRandom,
                  label: Text('Random'),
                  icon: Icon(Icons.cake),
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void dispatchConcrete() {
    if (inputString != null) {
      BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaForConcreteNumber(inputString));
      _controller.clear();
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('You need to input a number'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

class _NumberTriviaDisplay extends StatelessWidget {
  final BoxConstraints constraints;
  const _NumberTriviaDisplay(
    this.constraints, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight / 2 - 8,
      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case NumberTriviaInitial:
              return MessageDisplay(MESSAGE_INITIAL);
            case NumberTriviaLoading:
              return LinearProgressIndicator();
            case NumberTriviaLoaded:
              var s = state as NumberTriviaLoaded;
              return MessageDisplay(
                s.trivia.text,
                number: s.trivia.number.toString(),
              );
            case NumberTriviaError:
              return MessageDisplay((state as NumberTriviaError).message);
          }
          return Placeholder();
        },
      ),
    );
  }
}

const MESSAGE_INITIAL =
    'Digit a number and get fun trivia for it!\nOr else just roll the dices with the random functionality!';
