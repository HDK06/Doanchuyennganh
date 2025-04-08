import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/song_list.dart';
import 'now_playing_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  int _selectedTabIndex = 0;

  // Danh sách bài hát được đề xuất ngẫu nhiên
  late List<Song> _recommendedSongs;
  // Danh sách album nổi tiếng ngẫu nhiên
  late List<Song> _popularAlbums;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

    // Tạo danh sách đề xuất ngẫu nhiên
    _shuffleRecommendations();
  }

  // Hàm tạo danh sách đề xuất ngẫu nhiên
  void _shuffleRecommendations() {
    // Lấy 4 bài hát ngẫu nhiên
    _recommendedSongs = SongList.getRandomSongs(count: 6);
    // Lấy 4 album ngẫu nhiên
    _popularAlbums = SongList.getRandomSongs(count: 6);
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi đăng xuất: ${e.toString()}')),
        );
      }
    }
  }

  // Xử lý khi người dùng nhấn vào một bài hát
  void _onSongTapped(Song song, List<Song> songList, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          song: song,
          songList: songList,
          initialIndex: index,
        ),
      ),
    );
  }

  // Điều hướng đến màn hình tìm kiếm
  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  // Điều hướng đến màn hình yêu thích
  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Hàng đầu với avatar và tab
                Row(
                  children: [
                    // Avatar người dùng
                    GestureDetector(
                      onTap: _signOut,
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(width: 15),

                    // Tab Tất Cả, Nhạc, Podcasts
                    Expanded(
                      child: Row(
                        children: [
                          _buildTabButton('Tất Cả', 0),
                          const SizedBox(width: 15),
                          _buildTabButton('Nhạc', 1),
                          const SizedBox(width: 15),
                          _buildTabButton('Podcasts', 2),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Phần Được Đề Xuất Cho Hôm Nay
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Được Đề Xuất Cho Hôm Nay',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFF31C934)),
                      onPressed: () {
                        setState(() {
                          _shuffleRecommendations();
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Danh sách bài hát được đề xuất - ListView cuộn ngang
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recommendedSongs.length,
                    itemBuilder: (context, index) {
                      final song = _recommendedSongs[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index != _recommendedSongs.length - 1 ? 15 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              _onSongTapped(song, _recommendedSongs, index),
                          child: _buildMusicItem(song.title, song.artist,
                              song.coverImage, song.isFavorite, () {
                            setState(() {
                              SongList.toggleFavorite(song);
                            });
                          }),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // Phần Album Và Đĩa Nổi Tiếng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Album Và Đĩa Nổi Tiếng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFF31C934)),
                      onPressed: () {
                        setState(() {
                          _shuffleRecommendations();
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Danh sách album nổi tiếng - ListView cuộn ngang
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _popularAlbums.length,
                    itemBuilder: (context, index) {
                      final album = _popularAlbums[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index != _popularAlbums.length - 1 ? 15 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              _onSongTapped(album, _popularAlbums, index),
                          child: _buildAlbumItem(album.title, album.artist,
                              album.coverImage, album.isFavorite, () {
                            setState(() {
                              SongList.toggleFavorite(album);
                            });
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFF31C934)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, color: Colors.grey),
            label: '',
          ),
        ],
        currentIndex: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
            _navigateToSearch();
          } else if (index == 2) {
            _navigateToFavorites();
          }
        },
      ),
    );
  }

  // Widget xây dựng nút tab
  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF31C934) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Widget xây dựng item bài hát
  Widget _buildMusicItem(String title, String artist, String imagePath,
      bool isFavorite, VoidCallback onFavoritePressed) {
    return Container(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bài hát
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Nút yêu thích
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: onFavoritePressed,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Tên bài hát
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Tên nghệ sĩ
          Text(
            artist,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget xây dựng item album
  Widget _buildAlbumItem(String title, String artist, String imagePath,
      bool isFavorite, VoidCallback onFavoritePressed) {
    return Container(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh album
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Nút yêu thích
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: onFavoritePressed,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Tên album
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Tên nghệ sĩ
          Text(
            artist,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
