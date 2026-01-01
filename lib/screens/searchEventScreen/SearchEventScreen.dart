import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_event_explorer_frontend/apis/repository/events/EventRepository.dart';
import 'package:smart_event_explorer_frontend/models/EventModel.dart';
import 'package:smart_event_explorer_frontend/screens/eventScreen/EventScreen.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';
import 'package:smart_event_explorer_frontend/utils/DateFormatter/DateFormatter.dart';

class SearchEventScreen extends StatefulWidget {
  const SearchEventScreen({super.key});

  @override
  State<SearchEventScreen> createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  late TextEditingController controller;
  List<Event> searchedEvents = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Responsive padding based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04; // 4% of width
    final verticalPadding = screenWidth * 0.04; // 2% of width
    final iconSize = size.width * 0.045;

    return Column(
      children: [
        SizedBox(height: 20),

        TextSelectionTheme(
          data: const TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Colors.grey,
            selectionHandleColor: Colors.grey,
          ),
          child: TextField(
            controller: controller,
            maxLines: 1,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    searchedEvents = [];
                  });
                  controller.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              hintText: "Search Event by Name / Description",
              hintStyle: MyTextTheme.NormalStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
            ),
            style: MyTextTheme.NormalStyle(color: Colors.white),
            onSubmitted: (value) {
              // hit enter // Fetch Events
              fetchEvent();
            },
          ),
        ),
        if (searchedEvents.isNotEmpty) Row(children: [Container()]),

        SizedBox(height: 20),
        if (isLoading)
          Expanded(
            child: Center(
              child: Image.asset("lib/assets/gif/loading.gif", fit: .cover),
            ),
          )
        else if (errorMessage != null)
          Expanded(
            child: Center(
              child: Text(
                errorMessage!,
                style: MyTextTheme.NormalStyle(color : Colors.white),
              ),
            ),
          )
        else if (searchedEvents.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                style: MyTextTheme.NormalStyle(color : Colors.white),
                "Search Specific Events!!!",
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: searchedEvents.length,
              itemBuilder: (_, index) {
                return Container(
                  margin: .symmetric(vertical: 10),
                  width: .infinity,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: .circular(20),
                    border: .all(color: Colors.white, width: 0.1),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventScreen(
                          eventID: searchedEvents[index].id,
                          size: size,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .center,
                      children: [
                        ClipRRect(
                          borderRadius: .circular(15),
                          child: CachedNetworkImage(
                            imageUrl: searchedEvents[index].posterImage
                                .toString(),
                            width: size.width * 0.32,
                            fit: .fitHeight,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: .start,
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  searchedEvents[index].name,
                                  style: MyTextTheme.BigStyle(color : Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  searchedEvents[index].description,
                                  style: MyTextTheme.smallStyle(
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: .ellipsis,
                                ),

                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .start,
                                  children: [
                                    Icon(Icons.timer_outlined, size: iconSize),
                                    SizedBox(width: 10),
                                    Text(
                                      DateFormatter.getFormattedDateTime(
                                        searchedEvents[index].startTime,
                                      ),
                                      style: MyTextTheme.NormalStyle(
                                       color : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: .center,
                                      mainAxisAlignment: .start,
                                      children: [
                                        Icon(
                                          Icons.people_alt_outlined,
                                          size: iconSize,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          searchedEvents[index].capacity
                                              .toString(),
                                          style: MyTextTheme.NormalStyle(
                                            color : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(width: 20),
                                    Row(
                                      crossAxisAlignment: .center,
                                      mainAxisAlignment: .start,
                                      children: [
                                        Icon(
                                          Icons.attach_money_rounded,
                                          size: iconSize,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          searchedEvents[index].isFree
                                              ? "Free"
                                              : "Cost",
                                          style: MyTextTheme.NormalStyle( color : 
                                            Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Row(
                                  crossAxisAlignment: .center,
                                  mainAxisAlignment: .start,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: iconSize,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        searchedEvents[index]
                                            .location['address'],
                                        style: GoogleFonts.josefinSans(
                                          color: Colors.white,
                                          fontSize: size.width * 0.035,
                                        ),
                                        maxLines: 1,
                                        overflow: .ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void fetchEvent() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      List<Event> events = await EventRepository().searchEvent(
        controller.text.toString().trim(),
      );
      setState(() {
        searchedEvents = events;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = "Something Went Wrong";
        isLoading = false;
      });
    }
  }
}
