import 'package:flutter/material.dart';
import 'package:astronomy_application/models/image_model.dart';
import 'package:astronomy_application/services/image_service.dart';
import 'package:astronomy_application/widgets/image_tile.dart';
import 'package:astronomy_application/pages/all_image_page.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key});

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  late Future<List<AstronomyImage>> futureImages;

  @override
  void initState() {
    super.initState();
    futureImages = ImageService().fetchAstronomyImages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Images",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllImagesPage()),
                );
              },
              child: const Text(
                "See All",
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: FutureBuilder<List<AstronomyImage>>(
            future: futureImages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: \${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No images available."));
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final img = snapshot.data![index];
                    return ImageTile(
                      imageUrl: img.url,
                      title: img.title,
                      description: img.description,
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
