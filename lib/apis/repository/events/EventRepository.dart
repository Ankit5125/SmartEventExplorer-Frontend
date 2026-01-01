import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_event_explorer_frontend/apis/storage/LocalStorage.dart';
import 'package:smart_event_explorer_frontend/models/EventModel.dart';

class EventRepository {
  static final String baseURL = dotenv.env['baseURL'] ?? "http://10.0.2.2:5000";

  List<Event> _allEventsCache = [];
  List<Event> _trendingEventsCache = [];
  DateTime? _lastFetch;

  Future<List<Event>> getAllEvents() async {
    final token = await _getToken();

    // Cache valid for 10 minutes
    if (_allEventsCache.isNotEmpty &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!).inMinutes < 10) {
      return _allEventsCache;
    }

    final response = await http.get(
      Uri.parse("$baseURL/api/events/"),
      headers: {"x-auth-token": token},
    );

    _handleTokenError(response);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      _allEventsCache = data.map((e) => Event.fromJson(e)).toList();
      _lastFetch = DateTime.now();
      print("GET Events Successful");
      return _allEventsCache;
    }

    // print("GET Events Error: ${response.body}");
    // throw Exception("FAILED_TO_FETCH_EVENTS");
    if (response.statusCode == 401) {
      print("GET Events Error: ${response.body}");
      return Future.error("AUTH_EXPIRED");
    }

    print("SOMETHING WENT WRONG WHILE GET EVENTS!!!");
    return Future.error("SOMETHING_WENT_WRONG");
  }

  Future<List<Event>> getTrendingEvents() async {
    final token = await _getToken();

    // Cache valid for 10 minutes
    if (_trendingEventsCache.isNotEmpty &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!).inMinutes < 10) {
      return _trendingEventsCache;
    }

    final response = await http.get(
      Uri.parse("$baseURL/api/events/trending"),
      headers: {"x-auth-token": token},
    );

    _handleTokenError(response);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      _trendingEventsCache = data.map((e) => Event.fromJson(e)).toList();
      _lastFetch = DateTime.now();
      print("GET Trending Events Successful");
      return _trendingEventsCache;
    }

    // print("GET Trending Events Error: ${response.body}");
    // throw Exception("AUTH_EXPIRED");
    if (response.statusCode == 401) {
      print("GET Events Error: ${response.body}");
      return Future.error("AUTH_EXPIRED");
    }

    print("SOMETHING WENT WRONG WHILE GET TRENDING EVENTS!!!");
    return Future.error("SOMETHING_WENT_WRONG");
  }

  Future<List<Event>> refreshEvents() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseURL/api/events/"),
      headers: {"x-auth-token": token},
    );

    _handleTokenError(response);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      _allEventsCache = data.map((e) => Event.fromJson(e)).toList();
      _lastFetch = DateTime.now();
      print("Events refreshed");
      return _allEventsCache;
    }

    print("Refresh Error: ${response.body}");
    throw Exception("FAILED_TO_REFRESH");
  }

  Future<Event> getMoreEventInfo(String eventID) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseURL/api/events/$eventID"),
      headers: {"x-auth-token": token},
    );

    _handleTokenError(response);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Event.fromJson(data);
    }

    print("Event Details Error: ${response.body}");
    throw Exception("FAILED_TO_FETCH_EVENT_DETAILS");
  }

  // sort by name, newest
  Future<List<Event>> searchEvent(
    String keyword, {
    bool isFree = true,
    String sortBy = "newest",
  }) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseURL/api/events/search?keyword=$keyword"),
      headers: {"x-auth-token": token},
    );

    _handleTokenError(response);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final List eventData = data['events'];
      print("SEARCH :::: $data");
      List<Event> searchedEvents = eventData
          .map((e) => Event.fromJson(e))
          .toList();

      print("Search EVENT ::::: ${searchedEvents.toString()}");

      print("SEARCH Events Successful");
      return searchedEvents;
    }

    print("GET Events Error: ${response.body}");
    throw Exception("FAILED_TO_SEARCH_EVENTS");
  }

  void _handleTokenError(http.Response response) async {
    if (response.statusCode == 401 ||
        response.body.contains("invalid") ||
        response.body.contains("expired")) {
      await LocalStorage().delete("token");
      throw Exception("AUTH_EXPIRED");
    }
    return;
  }

  Future<String> _getToken() async {
    return await LocalStorage().get("token") ?? "";
  }
}
