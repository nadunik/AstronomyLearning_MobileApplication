import 'package:astronomy_application/pages/profile_page.dart';
import 'package:astronomy_application/pages/star_map_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:astronomy_application/widgets/support_widget.dart';
import 'package:astronomy_application/services/news_service.dart';
import 'package:astronomy_application/services/image_service.dart';
import 'package:astronomy_application/models/news_model.dart';
import 'package:astronomy_application/models/image_model.dart';
import 'package:astronomy_application/widgets/news_tile.dart';
import 'package:astronomy_application/widgets/image_tile.dart';
import 'package:astronomy_application/pages/all_image_page.dart';
import 'package:astronomy_application/pages/all_news_page.dart';
import 'package:astronomy_application/services/video_service.dart';
import 'package:astronomy_application/models/video_model.dart';
import 'package:astronomy_application/widgets/video_tile.dart';
import 'package:astronomy_application/pages/all_videos_page.dart';
import 'package:astronomy_application/models/live_event_model.dart';
import 'package:astronomy_application/services/live_event_service.dart';
import 'package:astronomy_application/widgets/live_event_banner.dart';
import 'package:astronomy_application/pages/learn_page.dart';
//import 'package:astronomy_application/pages/ar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astronomy_application/pages/search_results.dart';
import 'package:astronomy_application/pages/StarScannerDemo.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<NewsArticle>>? futureNews;
  Future<List<AstronomyImage>>? futureImages;
  //Future<List<AstronomyVideo>>? futureVideos;
  Future<List<Video>>? futureVideos;
  Future<List<LiveEvent>>? futureLiveEvents;

  int currentEventIndex = 0;
  late Timer _timer;

  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  String greeting = "";

  Future<String?> _getProfileImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_path');
  }

  @override
  void initState() {
    super.initState();
    futureNews = NewsService().fetchNASAHeadlines();
    futureImages = ImageService().fetchAstronomyImages();
    futureVideos = VideoService().fetchVideos();
    futureLiveEvents = LiveEventService().fetchLiveEvents();

    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      futureLiveEvents!.then((events) {
        if (!mounted || events.isEmpty) return;
        setState(() {
          currentEventIndex = (currentEventIndex + 1) % events.length;
        });
      });
    });

    setGreeting();
  }

  void setGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 18) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              //height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 71, 18, 108), Color(0xFF1B003B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: Column(
  mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text("Hello, world!", style: TextStyle(color: Colors.white)),  // Testing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello!",
                                style: AppWidget.boldTextFieldStyle(),
                              ),
                              Text(
                                greeting,
                                style: AppWidget.lighttextFieldStyle(),
                              ),
                            ],
                          ),
                         
                          FutureBuilder<String?>(
                            future: _getProfileImagePath(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                );
                              } else {
                                final path = snapshot.data;
                                final imageWidget =
                                    path != null && File(path).existsSync()
                                        ? FileImage(File(path))
                                        : const AssetImage('images/boy.jpg');

                                return CircleAvatar(
                                  radius: 25,
                                  backgroundImage: imageWidget as ImageProvider,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      //search bar
Container(
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 94, 68, 143),
    borderRadius: BorderRadius.circular(10),
  ),
  width: double.infinity,
  child: TextField(
    controller: _searchController,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: "Search Content",
      hintStyle: AppWidget.lighttextFieldStyle(),
      prefixIcon: const Icon(
        Icons.search,
        color: Color.fromARGB(255, 175, 136, 175),
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.arrow_forward, color: Colors.white),
        onPressed: () {
          String query = _searchController.text.trim();
          if (query.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchResultsPage(query: query),
              ),
            );
          }
        },
      ),
    ),
  ),
),


                      // live event banner
                      FutureBuilder<List<LiveEvent>>(
                        future: futureLiveEvents,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error loading live events"),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const SizedBox(); // no live events
                          } else {
                            //final event = snapshot.data![currentEventIndex];
                            final events = snapshot.data!;
                            final event =
                                events[currentEventIndex.clamp(
                                  0,
                                  events.length - 1,
                                )];

                            return LiveEventBanner(event: event);
                          }
                        },
                      ),

                      //news section
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "📰 News",
                            style: AppWidget.boldTextFieldStyle(),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AllNewsPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "See All",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        height: 200,
                        child:
                            futureNews == null
                                ? Center(child: CircularProgressIndicator())
                                : FutureBuilder<List<NewsArticle>>(
                                  future: futureNews,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Center(
                                        child: Text('No news available.'),
                                      );
                                    } else {
                                      List<NewsArticle> newsList =
                                          snapshot.data!;
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            newsList.length > 5
                                                ? 5
                                                : newsList
                                                    .length, // show only 5 items
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 300, // Adjust card width
                                            margin: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            child: NewsTile(
                                              news: newsList[index],
                                            ), // Ensure NewsTile is responsive
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                      ),
                      const SizedBox(height: 20),

                      //images section
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "🖼️ Images",
                            style: AppWidget.boldTextFieldStyle(),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AllImagesPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "See All",
                              style: TextStyle(color: Colors.white70),
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: \${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No images available.'),
                              );
                            } else {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final image = snapshot.data![index];
                                  return ImageTile(
                                    imageUrl: image.url,
                                    title: image.title,
                                    description: image.description,
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),

                      // Videos Section
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "🎬 Videos",
                            style: AppWidget.boldTextFieldStyle(),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllVideosPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "See All",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: FutureBuilder<List<Video>>(
                          future: futureVideos,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No videos available.'),
                              );
                            } else {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    snapshot.data!.length > 5
                                        ? 5
                                        : snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return VideoTile(
                                    video: snapshot.data![index],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          

          LearnPage(),

          StarMapPage(),

          StarScannerDemoPage(),

          ProfilePage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 94, 68, 143),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'SkyMap'),
          BottomNavigationBarItem(icon: Icon(Icons.view_in_ar), label: 'AR'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

