import 'package:final_tree_app/components/single_pub.dart';
import 'package:flutter/material.dart';
import 'package:final_tree_app/main.dart';

class TenPubs extends StatefulWidget {
  const TenPubs({super.key});

  @override
  State<TenPubs> createState() => _TenPubsState();
}

class _TenPubsState extends State<TenPubs> {
  final Stream _getPubs = supabase
      .from('tr_posts')
      .stream(
        primaryKey: ['id'],
      )
      // .inFilter(
      //   'from',
      //   [supabase.auth.currentUser!.id],
      // )
      .order('created_at')
      .limit(100);

  // .listen(List<Map<String, dynamic>> data) {
  // D
  // @override
  // void initState() {
  //   super.initState();
  //   // debugPrint("initState() called");
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _getPubs,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // debugPrint(snapshot.connectionState.toString());
            return const Center(
              child: Text("Aucune publication"),
              // child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return const Text("Erreur de chargement");
          }
          //debugPrint(snapshot.data as String?);
          // return const Text(snapshot.data[]media);
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                // return Container(
                //   height: 10.0,
                //   color: Colors.red,
                // );
                return SinglePub(snapshot.data![index]);
              });
        });
    // return const Column(
    //   children: [
    //     SinglePub(),
    //     SinglePub(),
    //     SinglePub(),
    //     SinglePub(),
    //     SinglePub(),
    //   ],
    // );
  }
}
