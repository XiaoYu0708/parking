import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPLay extends StatefulWidget {
  final String videoPath;

  const VideoPLay({
    super.key,
    required this.videoPath,
  });

  @override
  State<VideoPLay> createState() => _VideoPLayState();
}

class _VideoPLayState extends State<VideoPLay> {
  late VideoPlayerController _controller;
  late String videoPath;

  @override
  void initState() {
    super.initState();
    videoPath = widget.videoPath;

    _controller = VideoPlayerController.networkUrl(Uri.parse(videoPath))
      ..initialize().then((_) {
        _controller.setLooping(true);
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(
                color: Colors.grey,
                child: const MyLoadingAnimatedIcon(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MyLoadingAnimatedIcon extends StatefulWidget {
  const MyLoadingAnimatedIcon({super.key});

  @override
  State<MyLoadingAnimatedIcon> createState() => _MyLoadingAnimatedIconState();
}

class _MyLoadingAnimatedIconState extends State<MyLoadingAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedIcon(
          icon: AnimatedIcons.pause_play,
          progress: animation,
          size: 72.0,
          semanticLabel: 'Show menu',
        ),
      ),
    );
  }
}
