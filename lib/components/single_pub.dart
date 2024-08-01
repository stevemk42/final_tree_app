import 'package:final_tree_app/components/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:final_tree_app/components/full_pub.dart';

class SinglePub extends StatelessWidget {
  final Map<String, dynamic>? data;
  const SinglePub(this.data, {super.key});

  // var data = widget.data as Map<String, dynamic>;
  @override
  Widget build(BuildContext context) {
    // final wide = MediaQuery.of(context).size.width;
    // final high = MediaQuery.of(context).size.width;
    // var data;

    // return Container(
    //     width: wide, height: high, child: Text(widget.data?["caption"][0]));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FullPost(pub: data)));
        },
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: Colors.blueGrey,
              child: videoExt(data?["media"][0] as String)
                  ? SafeArea(
                      // child: const VideoWidget(theFile: "lets go"),
                      child: VideoWidget(theFile: data?["media"][0] as String),
                    )
                  : Image.network(data?["media"][0] as String),

              // child: widget.data?["media"][0].split('.').last != 'mp4'
              //     ? Image.network(widget.data?["media"][0] as String)
              //     : VideoPlaying(widget.data?["media"][0] as String),
            ),
            Text(data?["caption"][0] as String),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // InkWell(
                    // onTap: () {
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) => const AlertDialog(
                    //       title: Text('Commentaire'),
                    //       content: Text('input here'),
                    //     ),
                    //   );
                    // },
                    // child: Ink(
                    //   height: 20.0,
                    //   width: 20.2,
                    //   color: Colors.red,
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(
                    //         vertical: 4.0, horizontal: 20.0),
                    //     child: Icon(Icons.chat, size: 40.0),
                    //   ),
                    // ),
                    // ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                      child: Icon(Icons.chat, size: 40.0),
                    ),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                      child: Icon(Icons.send, size: 40.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
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
    debugPrint("test");
    debugPrint(test);
    debugPrint(test.split(".").last);
    return test.split(".").last == "mp4" ? true : false;
  }
}
