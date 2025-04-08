import 'dart:math';
import '../models/song.dart';

class SongList {
  static final Random _random = Random();

  static final List<Song> _allSongs = [
    Song(
      title: 'Ái Nộ',
      artist: 'Masew, Khôi Vũ',
      coverImage: 'assets/images/ai_no.png',
      audioPath: 'assets/audio/ai_no.mp3',
    ),
    Song(
      title: 'Dữ Liệu Quý',
      artist: 'Dương Domic',
      coverImage: 'assets/images/du_lieu_quy.png',
      audioPath: 'assets/audio/du_lieu_quy.mp3',
    ),
    Song(
      title: 'Bad Guy',
      artist: 'Billie Eilish',
      coverImage: 'assets/images/bad_guy.png',
      audioPath: 'assets/audio/bad_guy.mp3',
    ),
    Song(
      title: 'Chìm Sâu',
      artist: 'RPT MCK',
      coverImage: 'assets/images/chim_sau.png',
      audioPath: 'assets/audio/chim_sau.mp3',
    ),
    Song(
      title: 'Tại Vì Sao',
      artist: 'RPT MCK',
      coverImage: 'assets/images/tai_vi_sao.png',
      audioPath: 'assets/audio/tai_vi_sao.mp3',
    ),
    Song(
      title: 'Chúng Ta Của Hiện Tại',
      artist: 'Sơn Tùng M-TP',
      coverImage: 'assets/images/chung_ta_cua_hien_tai.png',
      audioPath: 'assets/audio/chung_ta_cua_hien_tai.mp3',
    ),
    Song(
      title: 'Đơn Giản',
      artist: 'Low G',
      coverImage: 'assets/images/don_gian.png',
      audioPath: 'assets/audio/don_gian.mp3',
    ),
    Song(
      title: 'Flower',
      artist: 'Jisso',
      coverImage: 'assets/images/flower.png',
      audioPath: 'assets/audio/flower.mp3',
    ),
    Song(
      title: 'See Tình',
      artist: 'Hoàng Thùy Linh',
      coverImage: 'assets/images/see_tinh.png',
      audioPath: 'assets/audio/see_tinh.mp3',
    ),
    Song(
      title: 'Exit Sign',
      artist: 'HIEUTHUHAI',
      coverImage: 'assets/images/exit_sign.png',
      audioPath: 'assets/audio/exit_sign.mp3',
    ),
    Song(
      title: 'See You Again',
      artist: 'Wiz Khalifa',
      coverImage: 'assets/images/see_you_again.png',
      audioPath: 'assets/audio/see_you_again.mp3',
    ),
    Song(
      title: 'See You Again',
      artist: 'Wiz Khalifa',
      coverImage: 'assets/images/see_you_again.png',
      audioPath: 'assets/audio/see_you_again.mp3',
    ),
  ];

  // Lấy danh sách bài hát ngẫu nhiên
  static List<Song> getRandomSongs({int count = 4}) {
    List<Song> shuffledList = List.from(_allSongs)..shuffle(_random);
    return shuffledList.sublist(0, count.clamp(0, _allSongs.length));
  }

  // Lấy tất cả bài hát
  static List<Song> getAllSongs() {
    return List.from(_allSongs);
  }

  // Tìm kiếm bài hát theo tên
  static List<Song> searchByTitle(String query) {
    final String lowerQuery = query.toLowerCase();
    return _allSongs
        .where((song) => song.title.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Tìm kiếm bài hát theo nghệ sĩ
  static List<Song> searchByArtist(String query) {
    final String lowerQuery = query.toLowerCase();
    return _allSongs
        .where((song) => song.artist.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Lấy danh sách bài hát yêu thích
  static List<Song> getFavoriteSongs() {
    return _allSongs.where((song) => song.isFavorite).toList();
  }

  // Chuyển đổi trạng thái yêu thích của bài hát
  static void toggleFavorite(Song song) {
    final index = _allSongs
        .indexWhere((s) => s.title == song.title && s.artist == song.artist);

    if (index != -1) {
      _allSongs[index].isFavorite = !_allSongs[index].isFavorite;
    }
  }
}
