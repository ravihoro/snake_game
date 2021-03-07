import 'package:flutter/material.dart';
import 'direction.dart';

class Button extends StatelessWidget {
  final Function onTap;
  final Direction direction;
  final IconData icon;

  Button({
    this.onTap,
    this.direction,
  }) : icon = direction == Direction.up
            ? Icons.keyboard_arrow_up
            : direction == Direction.down
                ? Icons.keyboard_arrow_down
                : direction == Direction.left
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1.0,
          ),
        ),
        child: Icon(
          icon,
          size: 45,
        ),
      ),
      onTap: onTap,
    );
  }
}
