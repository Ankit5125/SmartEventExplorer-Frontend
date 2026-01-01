import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_event_explorer_frontend/models/EventModel.dart';
import 'package:smart_event_explorer_frontend/screens/eventScreen/EventScreen.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';
import 'package:smart_event_explorer_frontend/utils/DateFormatter/DateFormatter.dart';

class AllEventScreen extends StatelessWidget {
  final List<Event> events;
  final Size size;
  const AllEventScreen({required this.events, required this.size, super.key});
  final Color textColor = Colors.white;
  final Color gradientColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length + 1,
      itemBuilder: (_, index) {
        if (index == events.length) {
          return Container(height: 100);
        }

        if (events[index].status == "pending" ||
            events[index].status == "rejected") {
          return Container();
        }
        final e = events[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventScreen(eventID: e.id, size: size),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(25),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: e.posterImage ?? "",
                      fit: .cover,
                      filterQuality: .low,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: size.height * 0.25,
                      width: .infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: .bottomCenter,
                          end: .topCenter,
                          colors: [gradientColor, Colors.transparent],
                          tileMode: .mirror,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 20,
                    child: Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          DateFormatter.getFormattedDateTime(e.startTime),
                          style: GoogleFonts.josefinSans(
                            color: Colors.grey,
                            fontSize: size.width * 0.035,
                          ),
                        ),
                        Text(
                          e.name,
                          style: MyTextTheme.BigStyle(color : textColor),
                          overflow: .fade,
                          maxLines: 1,
                        ),
                        Text(
                          e.location['address'],
                          style: GoogleFonts.josefinSans(
                            color: textColor,
                            fontSize: size.width * 0.039,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
