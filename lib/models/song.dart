class Song {
  final String title;
  final String artist;
  final String coverImage;
  final String audioPath;
  bool isFavorite;

  Song({
    required this.title,
    required this.artist,
    required this.coverImage,
    required this.audioPath,
    this.isFavorite = false,
  });
}
