import 'dart:async';
import './ticker.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:collection';

enum Direction { up, down, left, right }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Random random;
  StreamSubscription tickerSubscription;
  Ticker ticker;
  Direction direction;
  Queue<int> snakePosition;

  @override
  void dispose() {
    tickerSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    snakePosition = Queue();
    direction = Direction.right;
    ticker = Ticker();
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
      snakePosition.removeLast();
    });
    random = Random();
    snakePosition.add(random.nextInt(139));
  }

  left() {
    setState(() {
      if (snakePosition.first % 10 == 0) {
        snakePosition.addFirst(snakePosition.first + 9);
      } else {
        snakePosition.addFirst(snakePosition.first - 1);
      }
    });
  }

  right() {
    setState(() {
      if (snakePosition.first % 10 == 9) {
        snakePosition.addFirst(snakePosition.first - 9);
      } else {
        snakePosition.addFirst(snakePosition.first + 1);
      }
    });
  }

  up() {
    setState(() {
      if (snakePosition.first - 10 < 0) {
        snakePosition.addFirst(snakePosition.first - 10 + 140);
      } else {
        snakePosition.addFirst(snakePosition.first - 10);
      }
    });
  }

  down() {
    setState(() {
      if (snakePosition.first + 10 >= 140) {
        snakePosition.addFirst(snakePosition.first + 10 - 140);
      } else {
        snakePosition.addFirst(snakePosition.first + 10);
      }
    });
  }

  addTail() {
    setState(() {
      snakePosition.add(snakePosition.last);
    });
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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              color: Colors.black,
              child: GridView.builder(
                itemCount: 140,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  crossAxisCount: 10,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: snakePosition.contains(index)
                          ? Colors.yellow
                          : Colors.grey[800],
                      border: Border.all(
                        width: 1.0,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          IconButton(
            icon: Icon(Icons.arrow_circle_up),
            onPressed: () {
              setState(() {
                if (direction != Direction.down) direction = Direction.up;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left_rounded),
                onPressed: () {
                  setState(() {
                    if (direction != Direction.right)
                      direction = Direction.left;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_right_rounded),
                onPressed: () {
                  setState(() {
                    if (direction != Direction.left)
                      direction = Direction.right;
                  });
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.arrow_circle_down),
            onPressed: () {
              setState(() {
                if (direction != Direction.up) direction = Direction.down;
              });
            },
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addTail();
        },
      ),
    );
  }
}
