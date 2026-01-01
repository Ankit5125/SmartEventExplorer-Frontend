import 'package:flutter/material.dart';
import 'package:smart_event_explorer_frontend/apis/repository/events/EventRepository.dart';
import 'package:smart_event_explorer_frontend/controllers/NavController.dart';
import 'package:smart_event_explorer_frontend/models/EventModel.dart';
import 'package:smart_event_explorer_frontend/screens/createEventScreen/CreateEventScreen.dart';
import 'package:smart_event_explorer_frontend/screens/profileViewScreen/profileViewScreen.dart';
import 'package:smart_event_explorer_frontend/screens/searchEventScreen/SearchEventScreen.dart';
import 'package:smart_event_explorer_frontend/screens/splash/SplashScreen.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';
import 'package:smart_event_explorer_frontend/utils/AnimatedNavigator/AnimatedNavigator.dart';
import 'package:smart_event_explorer_frontend/utils/DateFormatter/DateFormatter.dart';
import 'package:smart_event_explorer_frontend/widgets/AllEventScreenWidget/AllEventsScreen.dart';
import 'package:smart_event_explorer_frontend/widgets/CustomNavBar/CustomNavBar.dart';
import 'package:smart_event_explorer_frontend/widgets/MyAppBar/MyAppBar.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  DateTime dateTime = DateTime.now();
  TextEditingController searchController = TextEditingController();
  late Future<List<Event>> _allEvents;
  late Future<List<Event>> _trendingEvents;
  late TabController tabController;

  int selected = 1;
  @override
  void initState() {
    super.initState();
    _allEvents = EventRepository().getAllEvents();
    _trendingEvents = EventRepository().getTrendingEvents();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 13, 26),
      // backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .start,
                children: [
                  // App Logo Image
                  MyAppBar(size: size),

                  SizedBox(height: 10),

                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: NavController.selectedIndex,
                      builder: (_, index, _) => IndexedStack(
                        index: index,
                        children: [
                          homeLayout(size),
                          SearchEventScreen(),
                          CreateEventScreen(),
                          ViewProfileScreen(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: .bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomNavBar(size: size),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget allEventsTab(Size size) => RefreshIndicator(
    color: Colors.black,
    backgroundColor: Colors.white,
    onRefresh: () async {
      setState(() {
        _allEvents = EventRepository().getAllEvents();
      });
      return;
    },
    child: FutureBuilder<List<Event>>(
      future: _allEvents,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          if (snapshot.error.toString().contains("AUTH_EXPIRED")) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(
                    "Session Ended, Login Again !!",
                    style: MyTextTheme.NormalStyle(color : Colors.black),
                  ),
                ),
              );
              AnimatedNavigator(SplashScreen(), context);
            });
            return SizedBox.shrink();
          }
          return Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Container(
              height: size.height * 0.6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Image.asset(
                  "lib/assets/gif/loading.gif",
                  height: size.height * 0.2,
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Something Went Wrong!!!",
              style: MyTextTheme.NormalStyle(color : Colors.white),
            ),
          );
        }

        final events = snapshot.data!;

        if (events.isEmpty) {
          return Center(
            child: Text(
              "No Events Right Now!!!",
              style: MyTextTheme.NormalStyle(color : Colors.white),
            ),
          );
        }

        return AllEventScreen(events: events, size: size);
      },
    ),
  );

  Widget trendingEventsTab(Size size) => FutureBuilder<List<Event>>(
    future: _trendingEvents,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        if (snapshot.error == "AUTH_EXPIRED") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  "Session Ended, Login Again !!",
                  style: MyTextTheme.NormalStyle(color : Colors.black),
                ),
              ),
            );
            AnimatedNavigator(SplashScreen(), context);
          });

          return SizedBox.shrink();
        }

        return Center(child: Text("Something went wrong"));
      }

      if (snapshot.connectionState != ConnectionState.done) {
        return Center(
          child: Container(
            height: size.height * 0.6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.asset(
                "lib/assets/gif/loading.gif",
                height: size.height * 0.2,
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
        );
      }

      if (!snapshot.hasData) {
        return Center(
          child: Text(
            "Something Went Wrong!!!",
            style: MyTextTheme.NormalStyle(color : Colors.white),
          ),
        );
      }

      final events = snapshot.data!;

      if (events.isEmpty) {
        return Center(
          child: Text(
            "No Events Right Now!!!",
            style: MyTextTheme.NormalStyle(color : Colors.white),
          ),
        );
      }

      return AllEventScreen(events: events, size: size);
    },
  );

  Widget homeLayout(Size size) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date
          Text(
            "${DateFormatter.getMonthName(dateTime)} ${DateFormatter.getTodayDate(dateTime)}, ${DateFormatter.getFormattedTime(dateTime)}",
            style: MyTextTheme.NormalStyle(color : Colors.grey.withOpacity(0.8)),
          ),

          // Explore Events
          Text("Explore Events", style: MyTextTheme.HeadingStyle(color : Colors.white)),
        ],
      ),

      SizedBox(height: 10),

      TabBar(
        controller: tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.white,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(child: Text("All")),
          Tab(child: Text("Trending")),
        ],
      ),

      SizedBox(height: 20),
      Expanded(
        child: TabBarView(
          controller: tabController,
          children: [allEventsTab(size), trendingEventsTab(size)],
        ),
      ),
    ],
  );
}
