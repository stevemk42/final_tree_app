import 'package:flutter/material.dart';
import 'package:final_tree_app/components/video_playing.dart';

class FullPost extends StatefulWidget {
  final Map<String, dynamic>? pub;
  const FullPost({super.key, this.pub});

  @override
  State<FullPost> createState() => _FullPostState();
}

class _FullPostState extends State<FullPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pub?['caption'][0] as String),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: videoExt(widget.pub?["media"][0] as String)
                    ? VideoPlaying(
                        videoUrl: widget.pub?["media"][0] as String?,
                        controls: true)
                    : Image.network(widget.pub?["media"][0] as String),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 20.0),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Commentaires'),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(Icons.close),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                      child: Center(
                                        child: CircularProgressIndicator.adaptive(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.chat, size: 40.0),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                      child: Icon(Icons.send, size: 40.0),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                      child: Icon(Icons.favorite_border, size: 40.0),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  videoExt(String test) {
    return test.split(".").last == "mp4" ? true : false;
  }
}
