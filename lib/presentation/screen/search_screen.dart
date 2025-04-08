import 'package:flutter/material.dart';
import '../../data/song_list.dart';
import '../../models/song.dart';
import 'now_playing_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Song> _searchResults = [];
  bool _isSearchingByTitle = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _performSearch();
    });
  }

  void _performSearch() {
    if (_searchQuery.isEmpty) {
      _searchResults = [];
      return;
    }

    setState(() {
      if (_isSearchingByTitle) {
        _searchResults = SongList.searchByTitle(_searchQuery);
      } else {
        _searchResults = SongList.searchByArtist(_searchQuery);
      }
    });
  }

  void _toggleSearchType() {
    setState(() {
      _isSearchingByTitle = !_isSearchingByTitle;
      _performSearch();
    });
  }

  void _onSongTapped(Song song, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          song: song,
          songList: _searchResults,
          initialIndex: index,
        ),
      ),
    );
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
                'Tìm Kiếm',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Thanh tìm kiếm
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: _isSearchingByTitle
                              ? 'Tìm theo tên bài hát...'
                              : 'Tìm theo tên nghệ sĩ...',
                          border: InputBorder.none,
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _toggleSearchType,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF31C934),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        _isSearchingByTitle ? Icons.music_note : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Hiển thị loại tìm kiếm hiện tại
              Center(
                child: Text(
                  _isSearchingByTitle
                      ? 'Đang tìm theo tên bài hát'
                      : 'Đang tìm theo tên nghệ sĩ',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Hiển thị kết quả tìm kiếm
              Expanded(
                child: _searchQuery.isEmpty
                    ? const Center(
                        child: Text(
                          'Nhập để tìm kiếm bài hát hoặc nghệ sĩ',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : _searchResults.isEmpty
                        ? const Center(
                            child: Text(
                              'Không tìm thấy kết quả phù hợp',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final song = _searchResults[index];
                              return ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(song.coverImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  song.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  song.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    song.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: song.isFavorite
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      SongList.toggleFavorite(song);
                                    });
                                  },
                                ),
                                onTap: () => _onSongTapped(song, index),
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
            icon: Icon(Icons.search, color: Color(0xFF31C934)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: '',
          ),
        ],
        currentIndex: 1,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/favorites');
          }
        },
      ),
    );
  }
}
