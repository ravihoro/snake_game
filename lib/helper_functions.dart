import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/direction.dart';
import 'package:snake_game/images.dart';

int getRow(int index, int side) {
  return index ~/ side;
}

int getColumn(int index, int side) {
  return index % side;
}

List<List<Direction>> getGrid(int side) {
  return List.generate(
    side,
    (_) => List.generate(
      side,
      (_) => Direction.right,
    ),
  );
}

void showAlertDialog(
  BuildContext context,
  void Function() onRestart,
  void Function() onExit,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: Text("Game Over"),
        content: Text(
          'Restart Game',
        ),
        actions: [
          ElevatedButton(
            child: Text("Restart"),
            onPressed: onRestart,
          ),
          ElevatedButton(
            child: Text("Exit Game"),
            style: ButtonStyle(),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      );
    },
  );
}

String getImage(
  int index,
  int side,
  int head,
  int tail,
  Direction dir,
  int length,
) {
  if (head == index) {
    if (dir == Direction.up ||
        dir == Direction.leftTop ||
        dir == Direction.rightTop) {
      return length == 1 ? snakeTop : headTop;
    } else if (dir == Direction.down ||
        dir == Direction.leftBottom ||
        dir == Direction.rightBottom) {
      return length == 1 ? snakeBottom : headBottom;
    } else if (dir == Direction.left ||
        dir == Direction.topLeft ||
        dir == Direction.bottomLeft) {
      return length == 1 ? snakeLeft : headLeft;
    } else {
      return length == 1 ? snakeRight : headRight;
    }
  } else if (tail == index) {
    switch (dir) {
      case Direction.up:
        return tailTop;
      case Direction.down:
        return tailBottom;
      case Direction.left:
        return tailLeft;
      case Direction.right:
        return tailRight;
      case Direction.topLeft:
        return tailLeft;
      case Direction.topRight:
        return tailRight;
      case Direction.bottomLeft:
        return tailLeft;
      case Direction.bottomRight:
        return tailRight;
      case Direction.leftTop:
        return tailTop;
      case Direction.leftBottom:
        return tailBottom;
      case Direction.rightTop:
        return tailTop;
      default:
        return tailBottom;
    }
  } else {
    switch (dir) {
      case Direction.up:
        return bodyVertical;
      case Direction.down:
        return bodyVertical;
      case Direction.left:
        return bodyHorizontal;
      case Direction.right:
        return bodyHorizontal;
      case Direction.topLeft:
        return turnBottomLeft;
      case Direction.topRight:
        return turnBottomRight;
      case Direction.bottomLeft:
        return turnTopLeft;
      case Direction.bottomRight:
        return turnTopRight;
      case Direction.leftTop:
        return turnTopRight;
      case Direction.leftBottom:
        return turnBottomRight;
      case Direction.rightTop:
        return turnTopLeft;
      default:
        return turnBottomLeft;
    }
  }
}
