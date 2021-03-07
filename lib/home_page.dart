import 'dart:async';
import './ticker.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:collection';
import './model/food.dart';
import './button.dart';
import 'direction.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.green,
    Colors.orange,
  ];

  Random random;
  StreamSubscription tickerSubscription;
  Ticker ticker;
  Direction direction;
  Queue<int> snakePosition;
  Set<int> indexes;
  Food food;

  @override
  void dispose() {
    tickerSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Game Over"),
            content: Text(
              'Restart Game',
            ),
            actions: [
              RaisedButton(
                child: Text("Restart"),
                onPressed: () {
                  Navigator.of(context).pop();
                  initializeGame();
                },
              ),
            ],
          );
        });
  }

  initializeGame() {
    ticker = Ticker();
    random = Random();
    indexes = Set();
    snakePosition = Queue();
    direction = Direction.right;
    snakePosition.add(random.nextInt(559));
    tickerSubscription = ticker.tick().listen((val) {
      if (direction == Direction.left) {
        left();
      } else if (direction == Direction.right) {
        right();
      } else if (direction == Direction.up) {
        up();
      } else {
        down();
      }
      if (snakePosition.first == food.index) {
        addTail();
        newFood();
      }
      int index = snakePosition.removeLast();
      indexes.remove(index);
    });
    food = Food(
      index: random.nextInt(559),
      color: colors[random.nextInt(3)],
    );
  }

  left() {
    setState(() {
      if (snakePosition.first % 20 == 0) {
        if (indexes.contains(snakePosition.first + 19)) {
          tickerSubscription.pause();
          _showAlertDialog(context);
        } else {
          snakePosition.addFirst(snakePosition.first + 19);
          indexes.add(snakePosition.first);
        }
      } else {
        if (indexes.contains(snakePosition.first - 1)) {
          tickerSubscription.pause();
          _showAlertDialog(context);
        } else {
          snakePosition.addFirst(snakePosition.first - 1);
          indexes.add(snakePosition.first);
        }
      }
    });
  }

  right() {
    print(snakePosition.first);
    setState(() {
      if (snakePosition.first % 20 == 19) {
        if (indexes.contains(snakePosition.first - 19)) {
          tickerSubscription.pause();
          _showAlertDialog(context);
        } else {
          snakePosition.addFirst(snakePosition.first - 19);
          indexes.add(snakePosition.first);
        }
      } else {
        if (indexes.contains(snakePosition.first + 1)) {
          tickerSubscription.pause();
          _showAlertDialog(context);
        } else {
          snakePosition.addFirst(snakePosition.first + 1);
          indexes.add(snakePosition.first);
        }
      }
    });
  }

  up() {
    setState(() {
      if (snakePosition.first - 20 < 0) {
        if (indexes.contains(snakePosition.first - 20 + 560)) {
          tickerSubscription.pause();
          _showAlertDialog(context);
        } else {
          snakePosition.addFirst(snakePosition.first - 20 + 560);
          indexes.add(snakePosition.first);
        }
      } else {
        if (indexes.contains(snakePosition.first - 20)) {
          tickerSubscription.pause();
          _showAlertDialog(context);
        } else {
          snakePosition.addFirst(snakePosition.first - 20);
          indexes.add(snakePosition.first);
        }
      }
    });
  }

  down() {
    setState(() {
      if (snakePosition.first + 20 >= 560) {
        if (indexes.contains(snakePosition.first + 20 - 560)) {
          tickerSubscription.pause();
          _showAlertDialog(context);
        } else {
          snakePosition.addFirst(snakePosition.first + 20 - 560);
          indexes.add(snakePosition.first);
        }
      } else {
        if (indexes.contains(snakePosition.first + 20)) {
          tickerSubscription.pause();
          _showAlertDialog(context);
        } else {
          snakePosition.addFirst(snakePosition.first + 20);
          indexes.add(snakePosition.first);
        }
      }
    });
  }

  newFood() {
    setState(() {
      do {
        food = Food(
          index: random.nextInt(559),
          color: colors[random.nextInt(3)],
        );
      } while (indexes.contains(food.index));
    });
  }

  addTail() {
    setState(() {
      snakePosition.add(snakePosition.last);
      indexes.add(snakePosition.last);
    });
  }

  Widget _buttons() {
    return Column(
      children: [
        Button(
          direction: Direction.up,
          onTap: () {
            HapticFeedback.heavyImpact();
            setState(() {
              if (direction != Direction.down) direction = Direction.up;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              direction: Direction.left,
              onTap: () {
                HapticFeedback.heavyImpact();
                setState(() {
                  if (direction != Direction.right) direction = Direction.left;
                });
              },
            ),
            Button(
              direction: Direction.right,
              onTap: () {
                HapticFeedback.heavyImpact();
                setState(() {
                  if (direction != Direction.left) direction = Direction.right;
                });
              },
            ),
          ],
        ),
        Button(
          direction: Direction.down,
          onTap: () {
            HapticFeedback.heavyImpact();
            setState(() {
              if (direction != Direction.up) direction = Direction.down;
            });
          },
        ),
      ],
    );
  }

  Widget _grid() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      color: Colors.black,
      child: GridView.builder(
        itemCount: 560,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          crossAxisCount: 20,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: snakePosition.contains(index)
                  ? Colors.yellow
                  : food.index == index
                      ? food.color
                      : Colors.grey[800],
              border: Border.all(
                width: 1.0,
                color: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Snake Game',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _grid(),
          ),
          SizedBox(
            height: 10.0,
          ),
          _buttons(),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.pause),
        onPressed: () {
          tickerSubscription.pause();
        },
      ),
    );
  }
}
