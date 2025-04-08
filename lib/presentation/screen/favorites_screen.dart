import 'package:flutter/material.dart';
import '../../data/song_list.dart';
import '../../models/song.dart';
import 'now_playing_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Song> _favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteSongs();
  }

  void _loadFavoriteSongs() {
    setState(() {
      _favoriteSongs = SongList.getFavoriteSongs();
    });
  }

  void _onSongTapped(Song song, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          song: song,
          songList: _favoriteSongs,
          initialIndex: index,
        ),
      ),
    ).then((_) {
      // Cập nhật lại danh sách khi quay trở lại
      _loadFavoriteSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Tiêu đề trang
              const Text(
                'Bài Hát Yêu Thích',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Danh sách bài hát yêu thích
              Expanded(
                child: _favoriteSongs.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border,
                                size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có bài hát yêu thích',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Nhấn vào biểu tượng trái tim để thêm vào danh sách',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _favoriteSongs.length,
                        itemBuilder: (context, index) {
                          final song = _favoriteSongs[index];
                          return Dismissible(
                            key: Key(song.title + song.artist),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                SongList.toggleFavorite(song);
                                _loadFavoriteSongs();
                              });
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 0,
                              ),
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(song.coverImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                song.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.artist,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    SongList.toggleFavorite(song);
                                    _loadFavoriteSongs();
                                  });
                                },
                              ),
                              onTap: () => _onSongTapped(song, index),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Color(0xFF31C934)),
            label: '',
          ),
        ],
        currentIndex: 2,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/search');
          }
        },
      ),
    );
  }
}
