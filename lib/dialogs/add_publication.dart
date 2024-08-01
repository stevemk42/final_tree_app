import "package:flutter/material.dart";
import 'package:getwidget/getwidget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_tree_app/components/video_playing.dart';
import 'package:final_tree_app/treeCustoms/assets.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// Syntax to fetch Images
// final List<FileObject> results = await supabase.storage.from('bucketName').list();

// Syntax to remove file
// final List<FileObject> result = await supabase.storage.from('bucketName').remove(['folderName/image1.png']);

class AddPublication extends StatefulWidget {
  const AddPublication({super.key});

  @override
  State<AddPublication> createState() => _AddPublicationState();
}

// void onUpload(String imageUrlResponse) {}

class _AddPublicationState extends State<AddPublication> {
  bool isUploading = false;
  bool blank = true;
  bool story = false;
  // late Future<dynamic> imageUrlResponse;
  final SupabaseClient supabase = Supabase.instance.client;
  String theImageUrl = "";
  String mediaType = "image";
  // Uri? fileObj;
  TextEditingController titleController = TextEditingController();

  Future<void> onUpload(String imageUrl, String mediaType) async {
    debugPrint('uploaded');
    debugPrint('imageUrl: $imageUrl');
    debugPrint('mediaType: $mediaType');
    setState(() {
      mediaType = mediaType;
      theImageUrl = imageUrl;
      isUploading = false;
      // fileObj = file;
    });
  }

/*
  Future<void> deleteImage(String imageName, BuildContext context) async {
    try {
      await supabase.storage
          .from('publications')
          .remove(["${supabase.auth.currentUser!.id}/$imageName"]);
      setState(() {});
    } catch (e) {
      // ignore: use_build_context_synchronously
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Une erreur est survenue là bas")));
    }
  }
*/
  Future<void> savePub(String saveType, BuildContext context) async {
    if (theImageUrl == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sauvegarde impossible sans média'),
        ),
      );
    } else {
      try {
        // debugPrint(theImageUrl);
        // debugPrint(titleController.text as String?);
        // debugPrint(supabase.auth.currentUser!.id);
        // debugPrint(story ? 'true' : 'false');
        // debugPrint(saveType);

        await supabase.from("tr_posts").insert({
          'media': [theImageUrl],
          'caption': [titleController.text],
          'from': supabase.auth.currentUser!.id,
          'story': story ? 'true' : 'false',
          'published': saveType == 'draft' ? 'false' : 'true'
        });
        // debugPrint(data);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(saveType == 'draft' ? 'Brouillon sauvegardé' : 'Publié'),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
/*
try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      _usernameController.text = (data['username'] ?? '') as String;
      _websiteController.text = (data['website'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    } on PostgrestException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

        */
      } catch (e) {
        debugPrint(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: SnackBar(
              content: Text('Erreur survenue'),
            ),
          ),
        );
      }
    }
  }

  // Future uploadVFile(ImageSource media) async {
  //   final picker = ImagePicker();

  //   var videoFile = await picker.pickImage(
  //     source: media,
  //     maxWidth: 800,
  //     maxHeight: 800,
  //   );
  // }

  Future uploadFile(
      ImageSource media, String type, BuildContext context) async {
    final picker = ImagePicker();

    var imageFile = type == 'image'
        ? await picker.pickImage(
            source: media,
            maxWidth: 800,
            maxHeight: 800,
          )
        : await picker.pickVideo(
            source: media,
          );

    if (imageFile != null) {
      setState(() {
        isUploading = true;
        // mediaType = type;
        // fileObj = imageFile as File?;
      });
      try {
        // debugPrint("trying");
        final bytes = await imageFile.readAsBytes();
        final fileExt = imageFile.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = '${supabase.auth.currentUser!.id}./.$fileName';
        // theImageUrl = filePath;
        await supabase.storage.from('publications').uploadBinary(
              filePath,
              bytes,
              // fileOptions: FileOptions(contentType: imageFile.mimeType),
            );
        debugPrint(imageFile.mimeType.toString());
        final imageUrlResponse =
            supabase.storage.from('publications').getPublicUrl(filePath);
        debugPrint('results');
        debugPrint(filePath);
        // fileObj = imageUrlResponse as Uri;
        onUpload(imageUrlResponse, type);
      } on StorageException catch (error) {
        // if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        // }
      } catch (error) {
        // if (mounted) {
        debugPrint("Error here");
        debugPrint(error.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Une erreur est survenue ici'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajout publication"),
      ),
      body: Column(
        children: [
          Expanded(
            child: (theImageUrl != "")
                ? (mediaType == 'image'
                    ? Image.network(theImageUrl)
                    : VideoPlaying(videoUrl: theImageUrl, controls: true))
                : const Icon(Icons.photo, size: 120),
          ),
          uploadButton("Prendre une photo", Icons.image, ImageSource.camera,
              "image", context),
          uploadButton("Sélectionner une photo", Icons.image,
              ImageSource.gallery, "image", context),
          uploadButton("Prendre une vidéo", Icons.video_file,
              ImageSource.gallery, "video", context),
          uploadButton("Sélectionner une vidéo", Icons.video_file,
              ImageSource.camera, "video", context),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text('Mettre en story (24h)'),
              ),
              GFToggle(
                onChanged: (val) {
                  setState(
                    () {
                      story = !story;
                    },
                  );
                },
                value: story,
                type: GFToggleType.custom,
                enabledText: 'Story',
                //disabledText: 'Story',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Légende",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                treeElevatedButton(() => savePub('draft', context), isUploading,
                    '...chargement image', 'Sauvegarder le brouillon'),
                treeElevatedButton(() => savePub('ok', context), isUploading,
                    '...chargement image', 'Publier'),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
    //   floatingActionButton: isUploading
    //       ? const CircularProgressIndicator()
    //       : FloatingActionButton(
    //           onPressed: uploadFile,
    //           child: const Icon(Icons.add_a_photo),
    //         ),
    // );
  }

  nothing() {}

  // ignore: non_constant_identifier_names
  Widget uploadButton(
      textStr, iconDt, ImageSource media, String type, BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.lightBlue,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(iconDt),
        color: Colors.white,
        onPressed: () => uploadFile(media, type, context),
      ),
    );
  }

  // getUrl() {
  //   setState(() {
  //     imageUrlResponse = imageUrlResponse;
  //   });
  //   return imageUrlResponse;
  // }
}
