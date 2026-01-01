import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_event_explorer_frontend/apis/repository/organizerApplication/organizerApplicationRepository.dart';
import 'package:smart_event_explorer_frontend/models/ApplicationStatusModel.dart';
import 'package:smart_event_explorer_frontend/screens/splash/SplashScreen.dart';
import 'package:smart_event_explorer_frontend/theme/TextTheme.dart';
import 'package:smart_event_explorer_frontend/utils/AnimatedNavigator/AnimatedNavigator.dart';
import 'package:smart_event_explorer_frontend/widgets/SubmitButton/SubmitButton.dart';
import 'package:smart_event_explorer_frontend/widgets/TextFormField/TextFormFieldWidget.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late final TextEditingController eventNameController;
  late final TextEditingController organizationNameController;
  late final TextEditingController reasonController;
  late final TextEditingController descriptionController;
  late final TextEditingController socialLinksController;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    organizationNameController = TextEditingController();
    reasonController = TextEditingController();
    descriptionController = TextEditingController();
    socialLinksController = TextEditingController();
  }

  @override
  void dispose() {
    eventNameController.dispose();
    organizationNameController.dispose();
    reasonController.dispose();
    descriptionController.dispose();
    socialLinksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return FutureBuilder<ApplicationStatus>(
      future: OrganizerApplicationRepository().fetchLatestStatus(),
      builder: (_, snapshot) {
        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
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

        if (snapshot.hasError) {
          return Center(
            child: Text("Error Checking Status: ${snapshot.error}"),
          );
        }

        final statusData = snapshot.data;
        final status = statusData?.status.toLowerCase() ?? "none";

        if (status == "pending") {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: const Icon(Icons.done, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  "Hang on Tight!!",
                  style: MyTextTheme.NormalStyle(color: Colors.white),
                ),
                Text(
                  "We are Reviewing your Application!",
                  style: MyTextTheme.NormalStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }

        if (status == "rejected") {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(75),
                    ),
                    child: const Icon(Icons.clear, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Application Rejected",
                    style: MyTextTheme.BigStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),

                  // ⚡️ SHOW THE REASON from Admin
                  Text(
                    "Reason: ${statusData?.adminNotes ?? 'Details not provided.'}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),
                  CustomSubmitButton(
                    buttonText: "Apply Again",
                    backgroundColor: Colors.orange,
                    onPressed: () {
                      postEventForm(); // Open the form again
                    },
                  ),
                ],
              ),
            ),
          );
        }

        if (status == "approved") {
          // You can return the actual "Create Event Form" widget here
          // or navigate to a dedicated dashboard.
          return Center(
            child: Text("🎉 You are Approved! (Render Create Event UI here)"),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(75),
                ),
                child: const Icon(
                  Icons.question_mark_outlined,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Want to Post your Event ?",
                style: MyTextTheme.NormalStyle(color: Colors.white),
              ),
              Text(
                "You Can Apply Here!",
                style: MyTextTheme.NormalStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              CustomSubmitButton(
                buttonText: "Click to Apply!",
                backgroundColor: Colors.orange,
                onPressed: () {
                  postEventForm();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void postEventForm() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      elevation: 2,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Post Your Event Form",
                  style: MyTextTheme.BigStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),

              // Organization Name
              CustomTextFormFieldWidget(
                controller: organizationNameController,
                isPasswordField: false,
                text: "Organization Name",
              ),
              const SizedBox(height: 10),

              // Reason
              CustomTextFormFieldWidget(
                controller: reasonController,
                isPasswordField: false,
                text: "Reason",
                maxLines: 3,
                keyboardType: .multiline,
              ),
              const SizedBox(height: 10),

              // Event Name
              CustomTextFormFieldWidget(
                controller: eventNameController,
                isPasswordField: false,
                text: "Event Name",
              ),
              const SizedBox(height: 10),

              // Description
              CustomTextFormFieldWidget(
                controller: descriptionController,
                isPasswordField: false,
                text: "Event Description",
                maxLines: 5,
              ),
              const SizedBox(height: 10),

              // Optional social links
              CustomTextFormFieldWidget(
                controller: socialLinksController,
                isPasswordField: false,
                text: "Social Link",
              ),

              const SizedBox(height: 20),
              Text(
                "Note : Make sure fill All the details propely!! we will personally check your application and then verify you*",
                style: GoogleFonts.josefinSans(color: Colors.red),
              ),
              const SizedBox(height: 10),
              Row(
                spacing: 10,
                children: [
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStatePropertyAll(
                          Theme.of(
                            context,
                          ).colorScheme.onPrimary.withOpacity(0.1),
                        ),
                        backgroundColor: const MaterialStatePropertyAll(
                          Colors.white,
                        ),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.josefinSans(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: CustomSubmitButton(
                        buttonText: "Submit",
                        onPressed: () {
                          submitApplication();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void submitApplication() async {
    Map<String, dynamic> applicationDetails =
        await OrganizerApplicationRepository().sendApplication(
          organizationNameController.text.trim().toString(),
          reasonController.text.trim().toString(),
          eventNameController.text.trim().toString(),
          descriptionController.text.trim().toString(),
          socialLinksController.text.trim().toString(),
        );

    if (applicationDetails['isError'] == false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Application Succesfull !")));
      AnimatedNavigator(SplashScreen(), context);
    }
    if (applicationDetails['isError'] == true) {
      if (applicationDetails['msg'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(applicationDetails['msg'] ?? "Error !")),
        );
      }
      if (applicationDetails['errors'][0]['msg'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(applicationDetails['errors'][0]['msg'] ?? "Error !"),
          ),
        );
      }
    }
  }
}
