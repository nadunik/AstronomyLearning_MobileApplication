import 'package:flutter/material.dart';
import 'package:astronomy_application/models/image_model.dart';
import 'package:astronomy_application/services/image_service.dart';
import 'package:astronomy_application/pages/image_preview_page.dart';

class AllImagesPage extends StatefulWidget {
  const AllImagesPage({super.key});

  @override
  State<AllImagesPage> createState() => _AllImagesPageState();
}

class _AllImagesPageState extends State<AllImagesPage> {
  late Future<List<AstronomyImage>> futureImages;

  @override
  void initState() {
    super.initState();
    futureImages = ImageService().fetchAstronomyImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B003B),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 0, 59),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("All Images", style: TextStyle(color: Colors.white),),
      ),
      body: FutureBuilder<List<AstronomyImage>>(
        future: futureImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: \${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No images found."));
          } else {
            final images = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final img = images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewPage(
                          imageUrl: img.url,
                          title: img.title,
                          description: img.description,
                        ),
                      ),
                    );
                  },
                  /*child: Hero(
                    tag: img.url,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        img.url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: img.url,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              img.url,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        img.title,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
