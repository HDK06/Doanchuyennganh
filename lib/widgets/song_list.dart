import 'package:flutter/material.dart';
import '../models/song.dart';

class SongList extends StatelessWidget {
  final List<Song> songs;
  final int currentSongIndex;
  final Function(int) onSongSelected;

  const SongList({
    Key? key,
    required this.songs,
    required this.currentSongIndex,
    required this.onSongSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final isSelected = index == currentSongIndex;

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(song.coverImage),
          ),
          title: Text(
            song.title,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            song.artist,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.play_arrow, color: Colors.blue)
              : null,
          onTap: () => onSongSelected(index),
        );
      },
    );
  }
}
