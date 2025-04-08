import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PlayerControls({
    Key? key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.backwardStep),
          iconSize: 30,
          color: Colors.white,
          onPressed: onPrevious,
        ),
        IconButton(
          icon: Icon(
            isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
          ),
          iconSize: 40,
          color: Colors.white,
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: const Icon(FontAwesomeIcons.forwardStep),
          iconSize: 30,
          color: Colors.white,
          onPressed: onNext,
        ),
      ],
    );
  }
}
