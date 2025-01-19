import 'dart:async';
import 'package:snake_game/grid.dart';
import 'package:snake_game/helper_functions.dart';
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
  late Random random;
  late Ticker ticker;
  late Direction direction;
  late Queue<int> snakePosition;
  late Set<int> indexes;
  late Food food;

  late StreamController<Direction> controller;
  late Timer timer;
  late StreamSubscription<Direction> stream;

  int side = 12;
  late int totalGrids = side * side;

  late List<List<Direction>> directionGrid = getGrid(side);

  int durationMilliseconds = 250;

  int points = 0;

  @override
  void dispose() {
    timer.cancel();
    stream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    points = 0;
    ticker = Ticker();
    random = Random();
    indexes = Set();
    snakePosition = Queue();
    direction = Direction.right;
    int startPosition = random.nextInt(totalGrids);
    snakePosition.add(startPosition);

    controller = StreamController<Direction>();

    timer = Timer.periodic(
      Duration(milliseconds: durationMilliseconds),
      (timer) {
        controller.add(direction);
      },
    );

    stream = controller.stream.listen(
      (dir) async {
        int dirRow = getRow(snakePosition.first, side);
        int dirCol = getColumn(snakePosition.first, side);

        directionGrid[dirRow][dirCol] = dir;

        setState(() {});

        if (dir == Direction.left ||
            dir == Direction.topLeft ||
            dir == Direction.bottomLeft) {
          left();
        } else if (dir == Direction.right ||
            dir == Direction.topRight ||
            dir == Direction.bottomRight) {
          right();
        } else if (dir == Direction.up ||
            dir == Direction.leftTop ||
            dir == Direction.rightTop) {
          up();
        } else if (dir == Direction.down ||
            dir == Direction.leftBottom ||
            dir == Direction.rightBottom) {
          down();
        }

        dirRow = getRow(snakePosition.first, side);
        dirCol = getColumn(snakePosition.first, side);

        directionGrid[dirRow][dirCol] = dir;

        if (snakePosition.first == food.index) {
          addTail();
          newFood();
        }

        int index = snakePosition.removeLast();
        indexes.remove(index);

        await Future.delayed(
          Duration(
            milliseconds: durationMilliseconds,
          ),
        );
      },
    );

    food = Food(
      index: random.nextInt(totalGrids),
    );
  }

  void pauseGame() {
    stream.pause();
    showAlertDialog(
      context,
      () {
        Navigator.of(context).pop();
        controller.close();
        timer.cancel();
        stream.cancel();
        initializeGame();
      },
      () {
        SystemNavigator.pop();
      },
    );
  }

  void left() {
    setState(
      () {
        if (snakePosition.first % side == 0) {
          int nextPos = snakePosition.first + (side - 1);
          if (indexes.contains(nextPos)) {
            pauseGame();
          } else {
            snakePosition.addFirst(nextPos);
            indexes.add(snakePosition.first);
          }
        } else {
          int nextPos = snakePosition.first - 1;
          if (indexes.contains(nextPos)) {
            pauseGame();
          } else {
            snakePosition.addFirst(nextPos);
            indexes.add(snakePosition.first);
          }
        }
      },
    );
  }

  void right() {
    setState(
      () {
        if (snakePosition.first % side == (side - 1)) {
          int nextPos = snakePosition.first - (side - 1);
          if (indexes.contains(nextPos)) {
            pauseGame();
          } else {
            snakePosition.addFirst(nextPos);
            indexes.add(snakePosition.first);
          }
        } else {
          int nextPos = snakePosition.first + 1;
          if (indexes.contains(nextPos)) {
            pauseGame();
          } else {
            snakePosition.addFirst(nextPos);
            indexes.add(snakePosition.first);
          }
        }
      },
    );
  }

  void up() {
    setState(
      () {
        if (snakePosition.first - side < 0) {
          int nextPos = snakePosition.first - side + (totalGrids);
          if (indexes.contains(nextPos)) {
            pauseGame();
          } else {
            snakePosition.addFirst(nextPos);
            indexes.add(snakePosition.first);
          }
        } else {
          int nextPos = snakePosition.first - side;
          if (indexes.contains(nextPos)) {
            pauseGame();
          } else {
            snakePosition.addFirst(nextPos);
            indexes.add(snakePosition.first);
          }
        }
      },
    );
  }

  void down() {
    setState(
      () {
        if (snakePosition.first + side >= (totalGrids)) {
          int nextPos = snakePosition.first + side - (totalGrids);
          if (indexes.contains(nextPos)) {
            pauseGame();
          } else {
            snakePosition.addFirst(nextPos);
            indexes.add(snakePosition.first);
          }
        } else {
          int nextPos = snakePosition.first + side;
          if (indexes.contains(nextPos)) {
            pauseGame();
          } else {
            snakePosition.addFirst(nextPos);
            indexes.add(snakePosition.first);
          }
        }
      },
    );
  }

  void newFood() {
    points++;
    setState(
      () {
        do {
          food = Food(
            index: random.nextInt(totalGrids),
          );
        } while (indexes.contains(food.index));
      },
    );
  }

  void addTail() {
    setState(
      () {
        snakePosition.add(snakePosition.last);
        indexes.add(snakePosition.last);
      },
    );
  }

  Widget _buttons() {
    return Column(
      children: [
        Button(
          direction: Direction.up,
          onTap: () async {
            if (direction != Direction.down) {
              if (direction == Direction.left) {
                controller.add(Direction.leftTop);
              } else if (direction == Direction.right) {
                controller.add(Direction.rightTop);
              }

              direction = Direction.up;
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Button(
              direction: Direction.left,
              onTap: () async {
                if (direction != Direction.right) {
                  if (direction == Direction.up) {
                    controller.add(Direction.topLeft);
                  } else if (direction == Direction.down) {
                    controller.add(Direction.bottomLeft);
                  }

                  direction = Direction.left;
                }
              },
            ),
            Button(
              direction: Direction.right,
              onTap: () async {
                if (direction != Direction.left) {
                  if (direction == Direction.up) {
                    controller.add(Direction.topRight);
                  } else if (direction == Direction.down) {
                    controller.add(Direction.bottomRight);
                  }

                  direction = Direction.right;
                }
              },
            ),
          ],
        ),
        Button(
          direction: Direction.down,
          onTap: () async {
            if (direction != Direction.up) {
              if (direction == Direction.left) {
                controller.add(Direction.leftBottom);
              } else if (direction == Direction.right) {
                controller.add(Direction.rightBottom);
              }

              direction = Direction.down;
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Snake Game',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Grid(
                side: side,
                totalGrids: totalGrids,
                snakePosition: snakePosition,
                food: food.index,
                directionGrid: directionGrid,
                points: points),
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
    );
  }
}
