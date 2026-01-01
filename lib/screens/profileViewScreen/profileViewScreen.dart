import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_event_explorer_frontend/apis/repository/profile/profileRepository.dart';
import 'package:smart_event_explorer_frontend/models/UserModel.dart';
import 'package:smart_event_explorer_frontend/screens/splash/SplashScreen.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';
import 'package:smart_event_explorer_frontend/utils/AnimatedNavigator/AnimatedNavigator.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return FutureBuilder<User>(
      future: ProfileRepository().getUserProfile(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          if (snapshot.error.toString().contains("AUTH_EXPIRED")) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(
                    "Session Ended, Login Again !!",
                    style: MyTextTheme.NormalStyle(color: Colors.black),
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
              style: MyTextTheme.NormalStyle(color: Colors.white),
            ),
          );
        }

        final User user = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Text(
                "Personal Details",
                style: MyTextTheme.HeadingStyle(),
                overflow: .fade,
                maxLines: 1,
              ),
              Container(
                width: .infinity,
                padding: EdgeInsets.only(top: 25, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  spacing: 20,
                  children: [
                    ClipRRect(
                      borderRadius: .circular(25),
                      child: Container(
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: user.avatar,
                          fit: .cover,
                          filterQuality: .high,
                        ),
                      ),
                    ),

                    Text(
                      "UID : ${user.id}",
                      style: MyTextTheme.smallStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),

              Container(
                width: .infinity,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  spacing: 20,
                  children: [
                    nameSection("Name", user.name),
                    nameSection("Bio", user.bio),
                    nameSection("Email", user.email),
                    nameSection("Organization Status", user.organizerStatus),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget socialLink(User user) {
    final links = user.socialLinks.entries.toList();

    return ListView.builder(
      itemCount: links.length,
      itemBuilder: (_, index) {
        final entry = links[index];
        return ListTile(
          leading: Icon(Icons.link),
          title: Text(entry.key),
          subtitle: Text(entry.value),
        );
      },
    );
  }

  Widget nameSection(String keyword, String data) {
    return Row(
      spacing: 18,
      crossAxisAlignment: .start,
      mainAxisAlignment: .start,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: .circular(45),
          ),
          child: Icon(Icons.person, color: Colors.red),
        ),
        Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .start,
          children: [
            Text(
              "$keyword : ",
              style: MyTextTheme.smallStyle(color: Colors.grey),
            ),
            Text(data, style: MyTextTheme.NormalStyle()),
          ],
        ),
      ],
    );
  }
}
