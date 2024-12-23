import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loanmanagmentapp/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loanmanagmentapp/helpers/format_date.dart';

const _storage = FlutterSecureStorage();

enum FetchState {
  loading,
  loaded,
  error
}

final fetchDataNotifierProvider = StateNotifierProvider<FetchNotifier, FetchState>((ref) {
  return FetchNotifier();
});


class FetchNotifier extends StateNotifier<FetchState> {

  List<String> _clients = [];
  String _name = "";
  String _email = "";
  String _clentName = "";
  String _clientEmail = "";
  String _clientPhone = "";
  String _imageUrl = "";
  late double _loanAmount;
  late double _emiAmount;
  List<String> _emiDate = [];
  List<bool> _emiStatus = [];

  FetchNotifier(): super(FetchState.loading);

  List<String> get clients => _clients;
  String get name => _name;
  String get email => _email;
  String get clientName => _clentName;
  String get clientEmail => _clientEmail;
  String get clientPhone => _clientPhone;
  String get imageUrl => _imageUrl;
  double get loanAmount => _loanAmount;
  double get emiAmount => _emiAmount;
  List<String> get emiDates => _emiDate;
  List<bool> get emiStatus => _emiStatus;

  Future<void> fetchClientsId() async {
    state = FetchState.loading;

    try {

      final userId = await _storage.read(key: "user_id");

      if(userId == null) {
        throw Exception("User id not found");
      }

      final getClientsUrl = Uri.parse(getClientIds);
      final clientResponse = await http.post(getClientsUrl, body: jsonEncode({
        "userId": userId
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      );


      if(clientResponse.statusCode == 200) {
        final responseBody = jsonDecode(clientResponse.body);

        if(responseBody["success"] == true) {
          _clients = List<String>.from(responseBody["data"]);
          state = FetchState.loaded;
        } else {
          throw Exception(responseBody['message'] ?? "Failed to fetch clients");
        }

      } else {
        throw Exception("HTTP error: ${clientResponse.statusCode}");
      }
      
    } catch (e) {
      throw Exception("Failed to fetch clients: $e");
    }
  }

  Future<void> fetchData(clientId) async {
    try {

      final fetchUrl = Uri.parse(clientDataUrl);
      final response = await http.post(fetchUrl, body: jsonEncode({
          "client": clientId,
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      );

      final responseBody = jsonDecode(response.body);
  
      _clentName = responseBody['data']['name'];
      _clientEmail = responseBody['data']['email'];
      _clientPhone = responseBody['data']['phone'];
      _loanAmount = responseBody['data']['loanAmount'].toDouble();
      _emiAmount = responseBody['data']['emiAmount'].toDouble();
      _imageUrl = responseBody['data']['profileImage'] ?? "";
      
    } catch (e) {
      throw Exception("Failed to fetch client datadata: $e");
    }
  }

  Future<void> getUserDetails() async {
    try {
      final userId = await _storage.read(key: "user_id");

      if(userId == null) {
        throw Exception("User id not found");
      }



      final fetchUrl = Uri.parse(getUserDetail);
      final response = await http.post(fetchUrl, body: jsonEncode({
          "userId": userId,
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      );

  

      final responseBody = jsonDecode(response.body);

      _name = responseBody['data']['fullName'];
      _email = responseBody['data']['email'];

      state = FetchState.loaded;
      
    } catch (e) {
      throw Exception("Failed to fetch user details: $e");
    }
  }


  Future<void> fetchEmi(clientId) async {

    try {

      final fetchUrl = Uri.parse(getEmi);
      final response = await http.post(fetchUrl, body: jsonEncode({
          "client": clientId,
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      );


      final responseBody = jsonDecode(response.body);

  

      if(responseBody['success'] == true) {
        List<dynamic> data = responseBody['data'];

        if(data.isNotEmpty) {

          List<Map<String, dynamic>> emiDateObjects = List<Map<String, dynamic>>.from(data[0]['emiDate']);
          List<String> initialEmiStatus = emiDateObjects.map((emiObj) => emiObj['status'].toString()).toList();
          List<String> emiDates = emiDateObjects.map((emiObj) => emiObj['emiDate'].toString()).toList();
          _emiDate = formatDateList(emiDates);
          _emiStatus = initialEmiStatus.map((status) => status == "true" ? true : false).toList();

        
        } else {
          throw Exception("No EMI data found");
        }

      }
      
    } catch (e) {
      throw Exception("Failed to fetch EMI data: $e");
    }
  }

  Future<void> updateEmiStatus(String clientId, int emiIndex, bool newStatus) async {
    try {
      final updateUrl = Uri.parse(updateEmiStatusUrl);
      final response = await http.patch(updateUrl, body: jsonEncode({
          "clientId": clientId,
          "emiIndex": emiIndex,
          "status": newStatus,
        }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      );

      final responseBody = jsonDecode(response.body);

      if (responseBody['success'] == true) {
        _emiStatus[emiIndex] = newStatus;
      } else {
        throw Exception(responseBody['message'] ?? "Failed to update EMI status");
      }

    } catch (e) {
      throw Exception("Failed to update EMI status: $e");
    }
  }

  
}