import 'package:flutter/material.dart';
import '../../data/song_list.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  final List<Song> songList;
  final int initialIndex;

  const NowPlayingScreen({
    Key? key,
    required this.song,
    required this.songList,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late Song _currentSong;
  late int _currentIndex;
  bool _isPlaying = true;
  double _currentSliderValue = 20;

  @override
  void initState() {
    super.initState();
    _currentSong = widget.song;
    _currentIndex = widget.initialIndex;
  }

  void _playNextSong() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.songList.length;
      _currentSong = widget.songList[_currentIndex];
      _currentSliderValue = 0;
    });
  }

  void _playPreviousSong() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.songList.length) % widget.songList.length;
      _currentSong = widget.songList[_currentIndex];
      _currentSliderValue = 0;
    });
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần header với nút quay lại
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Đang Phát',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Hình ảnh album
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(_currentSong.coverImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Thông tin bài hát
              Text(
                _currentSong.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                _currentSong.artist,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 24),

              // Thanh tiến trình
              Slider(
                value: _currentSliderValue,
                min: 0,
                max: 100,
                activeColor: const Color(0xFF31C934),
                inactiveColor: Colors.grey.shade800,
                onChanged: (value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_currentSliderValue.toInt()),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      _formatDuration(100),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Các nút điều khiển
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shuffle, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 36),
                    onPressed: _playPreviousSong,
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF31C934),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: _togglePlay,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 36),
                    onPressed: _playNextSong,
                  ),
                  IconButton(
                    icon: const Icon(Icons.repeat, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    // Giả lập thời gian dựa trên giá trị của slider (0-100)
    final minutes = (seconds * 3 ~/ 100); // Giả sử bài hát dài 3 phút
    final remainingSeconds = (seconds * 180 ~/ 100) % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
