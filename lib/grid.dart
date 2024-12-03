import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:snake_game/direction.dart';
import 'package:snake_game/helper_functions.dart';
import 'package:snake_game/images.dart';

class Grid extends StatelessWidget {
  final int side;
  final int totalGrids;
  final Queue<int> snakePosition;
  final int food;
  final List<List<Direction>> directionGrid;
  final int points;

  const Grid({
    Key? key,
    required this.side,
    required this.totalGrids,
    required this.snakePosition,
    required this.food,
    required this.directionGrid,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: totalGrids,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                crossAxisCount: side,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: food == index
                        ? DecorationImage(image: AssetImage(fruit))
                        : snakePosition.contains(index)
                            ? DecorationImage(
                                image: AssetImage(
                                  getImage(
                                      index,
                                      side,
                                      snakePosition.first,
                                      snakePosition.last,
                                      directionGrid[getRow(index, side)]
                                          [getColumn(index, side)]),
                                ),
                              )
                            : null,
                    color: Colors.grey[800],
                    border: Border.all(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            "Points: $points",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
