class Event {
  final String id;
  final String name;
  final Map<String, dynamic> organizer;
  final String description;
  final List<String> category;
  final Map<String, dynamic> location;

  final DateTime startTime;
  final DateTime endTime;
  final DateTime? registrationDeadline;

  final int? capacity;
  final String? posterImage;
  final bool isFree;
  final String status;

  final List<Map<String, dynamic>> chatbotData;

  Event({
    required this.id,
    required this.name,
    required this.organizer,
    required this.description,
    required this.category,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.registrationDeadline,
    required this.capacity,
    required this.posterImage,
    required this.isFree,
    required this.status,
    required this.chatbotData,
  });

  // factory Event.fromJson(Map<String, dynamic> json) {
  //   return Event(
  //     id: json['_id'] ?? "",
  //     name: json['name'] ?? "",
  //     organizer: json['organizer'] ?? {},
  //     description: json['description'] ?? "",

  //     // category must be a LIST<String>
  //     category: List<String>.from(json['category'] ?? []),

  //     // location is a map containing type, coordinates, address
  //     location: json['location'] ?? {},

  //     // parse dates
  //     startTime: DateTime.parse(json['startTime']),
  //     endTime: DateTime.parse(json['endTime']),
  //     registrationDeadline: json['registrationDeadline'] != null
  //         ? DateTime.parse(json['registrationDeadline'])
  //         : null,

  //     // int or null
  //     capacity: json['capacity'] != null ? json['capacity'] as int : null,

  //     // optional string
  //     posterImage: json['posterImage'],

  //     // boolean
  //     isFree: json['isFree'] ?? false,

  //     status: json['status'] ?? "Pending",

  //     // chatbotData is a list of maps
  //     chatbotData: List<Map<String, dynamic>>.from(json['chatbotData'] ?? []),
  //   );
  // }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",

      organizer: json['organizer'] is Map ? json['organizer'] : {},

      description: json['description'] ?? "",

      category: json['category'] is List
          ? List<String>.from(json['category'])
          : [],

      location: json['location'] is Map ? json['location'] : {},

      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),

      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : DateTime.now(),

      registrationDeadline: json['registrationDeadline'] != null
          ? DateTime.parse(json['registrationDeadline'])
          : null,

      capacity: json['capacity'] is int ? json['capacity'] : null,

      posterImage: json['posterImage'] is String ? json['posterImage'] : null,

      isFree: json['isFree'] ?? false,
      status: json['status'] ?? "Unknown",

      chatbotData: json['chatbotData'] is List
          ? List<Map<String, dynamic>>.from(json['chatbotData'])
          : [],
    );
  }
}
