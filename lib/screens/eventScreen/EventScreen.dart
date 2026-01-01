import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_event_explorer_frontend/apis/repository/events/EventRepository.dart';
import 'package:smart_event_explorer_frontend/models/EventModel.dart';
import 'package:smart_event_explorer_frontend/widgets/mapsWidget/MapsWidget.dart';
import 'package:smart_event_explorer_frontend/screens/splash/SplashScreen.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';
import 'package:smart_event_explorer_frontend/utils/AnimatedNavigator/AnimatedNavigator.dart';
import 'package:smart_event_explorer_frontend/utils/DateFormatter/DateFormatter.dart';
import 'package:smart_event_explorer_frontend/widgets/CategoryBox/CategoryBox.dart';
import 'package:smart_event_explorer_frontend/widgets/EventDetailsSectionWidget/EventDetailsSectionWidget.dart';

class EventScreen extends StatelessWidget {
  final Size size;
  final String eventID;
  const EventScreen({required this.eventID, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<Event>(
          future: EventRepository().getMoreEventInfo(eventID),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
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
              return Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Image.asset(
                    "lib/assets/gif/loading.gif",
                    height: this.size.height * 0.2,
                    repeat: ImageRepeat.repeat,
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

            Event eventData = snapshot.data!;

            return Stack(
              children: [
                ListView(
                  //  physics: BouncingScrollPhysics(),
                  children: [
                    // poster widget
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: eventData.posterImage ?? "",
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: size.height * 0.25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black, Colors.transparent],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // text description ....
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // name
                          Text(
                            eventData.name,
                            style: MyTextTheme.HeadingStyle(color : Colors.white),
                          ),

                          // description
                          Text(
                            " - ${eventData.description}",
                            style: MyTextTheme.NormalStyle(color : Colors.grey),
                          ),

                          // Registration Details
                          EventDetailsSectionWidget(
                            title: "Resgistration Details",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "is Free ? \t${eventData.isFree ? "Yes" : "NO"}",
                                  style: MyTextTheme.NormalStyle(color : Colors.grey),
                                ),
                                Text(
                                  "Registration Last Date : \t${DateFormatter.getFormattedDateTime(eventData.registrationDeadline ?? eventData.startTime)}",
                                  style: MyTextTheme.NormalStyle(color : Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          // Time
                          EventDetailsSectionWidget(
                            title: "Time ⏰",
                            child: Text(
                              "Start Time - ${DateFormatter.getFormattedDateTime(eventData.startTime)}\nEnd Time - ${DateFormatter.getFormattedDateTime(eventData.endTime)}",
                              style: MyTextTheme.NormalStyle(color : Colors.grey),
                            ),
                          ),

                          // Capacity
                          EventDetailsSectionWidget(
                            title: "Capacity",
                            child: Row(
                              children: [
                                Icon(Icons.people_alt_outlined),
                                Text(
                                  "${eventData.capacity}",
                                  style: MyTextTheme.NormalStyle(color : Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          // Organizer Details
                          EventDetailsSectionWidget(
                            title: "Organizer",
                            child: Row(
                              children: [
                                // Avatar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child:
                                      eventData.organizer['avatar'] == null ||
                                          eventData.organizer['avatar']
                                              .toString()
                                              .isEmpty
                                      ? const Icon(Icons.person, size: 40)
                                      : Image.network(
                                          eventData.organizer['avatar'],
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                ),

                                const SizedBox(width: 12),

                                // Name (THIS is the fix)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eventData.organizer['name'] ?? "-",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: MyTextTheme.NormalStyle(
                                          color : Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        eventData
                                                .organizer['organizationName'] ??
                                            "-",
                                        style: MyTextTheme.NormalStyle(
                                         color:  Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Location
                          EventDetailsSectionWidget(
                            title: "Location 📍",
                            child: SizedBox(
                              height: size.height * 0.3,
                              child: Builder(
                                builder: (ctx) {
                                  final coords =
                                      (eventData.location['coordinates']
                                          is List)
                                      ? List.from(
                                          eventData.location['coordinates'],
                                        )
                                      : <dynamic>[];
                                  double lat = 0.0, lng = 0.0;
                                  if (coords.length >= 2) {
                                    lat =
                                        double.tryParse("${coords[0]}") ?? 0.0;
                                    lng =
                                        double.tryParse("${coords[1]}") ?? 0.0;
                                  }
                                  return MapsScreen(
                                    lattitude: lat,
                                    longitude: lng,
                                  );
                                },
                              ),
                            ),
                          ),

                          // category
                          EventDetailsSectionWidget(
                            title: "Category ",
                            child: SizedBox(
                              height: size.height * 0.058,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: eventData.category.length,
                                itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: CategoryBox(
                                    color: Colors.black,
                                    text: eventData.category[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          height: size.height * 0.065,
                          width: size.width * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
