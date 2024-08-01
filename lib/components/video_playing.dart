import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:video_controls/video_controls.dart';

class VideoPlaying extends StatefulWidget {
  final String? videoUrl;
  final bool controls;
  const VideoPlaying(
      {super.key, @required this.videoUrl, required this.controls});

  @override
  State<VideoPlaying> createState() => _VideoPlayingState();
}

class _VideoPlayingState extends State<VideoPlaying> {
  // ignore: non_constant_identifier_names
  late VideoController _VideoController;
  late Future<void> _initVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    // debugPrint("widget.videoUrl");
    // debugPrint(widget.videoUrl);

    _VideoController =
        // VideoController.asset(widget.videoUrl);
        VideoController.network(widget.videoUrl as String);
    _initVideoPlayerFuture = _VideoController.initialize();
    //.then((_) {
    //  _VideoController.pause();
    //_VideoController.play();
    //_VideoController.setLooping(true);
    //  setState(() {});
    // });
    super.initState();
    // _VideoController.addListener(() {
    //   if (startedPlaying && !_VideoController.value.isPlaying) {
    //     Navigator.pop(context);
    //   }
    // });
  }

  @override
  void dispose() {
    _VideoController.dispose();
    super.dispose();
  }

  // Future<bool> started() async {
  //   _VideoController.initialize().then((_) {
  //     // _VideoController.play();
  //     // _VideoController.setLooping(true);
  //     setState(() {});
  //   });
  //   // setState(() {});
  //   // await _VideoController.play();
  //   // startedPlaying = true;
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FutureBuilder<void>(
          future: _initVideoPlayerFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            // if (snapshot.data ?? false) {
            if (snapshot.connectionState == ConnectionState.done) {
              //  _VideoController.pause();
              return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 750),
                  child: AspectRatio(
                    aspectRatio: _VideoController.value.aspectRatio,
                    child: VideoPlayer(_VideoController),
                  ) //;
                  //VideoPlayer(_VideoController),
                  );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
              // const Text('Chargement de la vidéo');
            }
          },
        ),
      ),
    );
  }

  Widget playControl(IconData icon, Function action) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: action(),
      splashColor: Colors.red,
      child: Icon(
        icon,
        size: 48,
        color: Colors.white,
      ),
    );
  }
}
