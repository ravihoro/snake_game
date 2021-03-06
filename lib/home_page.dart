import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentDirection = "";
  int initialPosition = 0;

  @override
  void initState() {
    super.initState();
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
                initialPosition -= 10;
                if (initialPosition < 0) {
                  initialPosition += 140;
                }
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
                    if (initialPosition % 10 == 0) {
                      initialPosition += 9;
                    } else {
                      initialPosition--;
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_right_rounded),
                onPressed: () {
                  setState(() {
                    initialPosition += 1;
                    if (initialPosition % 10 == 0) {
                      initialPosition -= 10;
                    }
                  });
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.arrow_circle_down),
            onPressed: () {
              setState(() {
                initialPosition += 10;
                if (initialPosition >= 140) {
                  initialPosition -= 140;
                }
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
