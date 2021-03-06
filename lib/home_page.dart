import 'dart:async';
import './ticker.dart';
import 'package:flutter/material.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentDirection = "";
  int initialPosition;
  Random random;
  StreamSubscription tickerSubscription;
  Ticker ticker;
  Direction direction;

  @override
  void initState() {
    super.initState();
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
    });
    random = Random();
    initialPosition = random.nextInt(139);
  }

  left() {
    setState(() {
      if (initialPosition % 10 == 0) {
        initialPosition += 9;
      } else {
        initialPosition--;
      }
    });
  }

  right() {
    setState(() {
      initialPosition += 1;
      if (initialPosition % 10 == 0) {
        initialPosition -= 10;
      }
    });
  }

  up() {
    setState(() {
      initialPosition -= 10;
      if (initialPosition < 0) {
        initialPosition += 140;
      }
    });
  }

  down() {
    setState(() {
      initialPosition += 10;
      if (initialPosition >= 140) {
        initialPosition -= 140;
      }
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
              color: Colors.grey,
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
                      color: index == initialPosition
                          ? Colors.yellow
                          : Colors.white,
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
    );
  }
}
