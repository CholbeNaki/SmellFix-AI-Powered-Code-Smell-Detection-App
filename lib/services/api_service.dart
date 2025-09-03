import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:logger/logger.dart';
var logger = Logger();

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/';

  // Sign Up API
  Future<Map<String, dynamic>> signUp(String name,
      String username,
      String password,
      String dob,
      String bio,
      File? image,) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + 'auth/signup'));

    request.fields['name'] = name;
    request.fields['username'] = username;
    request.fields['password'] = password;
    request.fields['dob'] = dob;
    request.fields['bio'] = bio;


    // Attach the image file if it is provided
    if (image != null) {
      var imageBytes = await image.readAsBytes(); // Read image file as bytes
      var fileExtension = image.path
          .split('.')
          .last;
      var mimeType = "image/$fileExtension";

      request.files.add(
          http.MultipartFile.fromBytes('image', imageBytes, filename: image.path
              .split('/')
              .last, contentType: MediaType.parse(mimeType))
      );
    }

    try {
      var response = await request.send();


      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return json.decode(responseData);
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      throw Exception('Error during sign-up: $e');
    }
  }

  // Login API
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl + 'auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData.containsKey('token') && responseData['token'] != null) {
          return responseData;
        } else {
          throw Exception('Login failed: Token not found in the response');
        }
      } else {
        throw Exception('Login failed: ${response.body}');
      }

    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }


  // Fetch user data (name, username, bio, photo)
  Future<Map<String, dynamic>> getUserData(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'auth/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  // File Upload API (for .py/.java files)
  Future<Map<String, dynamic>> uploadFile(String token, String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + 'uploads/upload-file'));
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    var file = await http.MultipartFile.fromPath('file', filePath);
    request.files.add(file);
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return json.decode(responseData);
      } else {
        throw Exception('Failed to upload file.}');
      }
    }

// Analysis
  Future<Map<String, dynamic>> getAnalysisResults(String token, String historyId) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl + 'analysis/analyze'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'historyId': historyId,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        logger.e("Response of analysis api: $responseData");
        return responseData;
      } else {
        throw Exception('Failed to fetch analysis results2');
      }
    } catch (e) {
      throw Exception('Error during analysis fetch3: $e');
    }
  }

  // Get History List
  Future<List<dynamic>> getHistory(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl+'history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch history');
      }
    } catch (e) {
      throw Exception('Error fetching history: $e');
    }
  }


  // Delete History Item
  Future<void> deleteHistory(String token, String historyId) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl+'history/$historyId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete history item');
      }
    } catch (e) {
      throw Exception('Error deleting history item: $e');
    }
  }

  // Rename History Item
  Future<void> renameHistory(String token, String historyId, String newFileName) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl+'history/rename/$historyId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'newFileName': newFileName}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to rename history item');
      }
    } catch (e) {
      throw Exception('Error renaming history item: $e');
    }
  }

  // Get a specific history item (View)
  Future<Map<String, dynamic>> getHistoryItem(String token, String historyId) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl+'history/$historyId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch history item');
      }
    } catch (e) {
      throw Exception('Error fetching history item: $e');
    }
  }
}