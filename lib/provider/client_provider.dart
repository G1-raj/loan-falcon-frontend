import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loanmanagmentapp/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loanmanagmentapp/helpers/calculate_emi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loanmanagmentapp/helpers/phone_no_format.dart';
import 'package:http_parser/http_parser.dart';

const _storage = FlutterSecureStorage();

List<String> _dates = [];



enum DataState {
  loading,
  loaded,
  error
}


final dataNotifierProvider = StateNotifierProvider<DataNotifier, DataState>((ref) {
  return DataNotifier();
});


class DataNotifier extends StateNotifier<DataState> {
  DataNotifier(): super(DataState.loading);

  Future<void> getData(agentId, name, email, phone, address, city, state, pincode, loanAmount, loanDuration, loanStartDate, emiAmount, File? profileImage) async {
    try {

      final formatedDate = DateTime.parse(loanStartDate).toIso8601String();
      final fortmatedPhoneNo = formatPhoneNumber(phone);

      final registerUrl = Uri.parse(clientRegisterUrl);
      final request = http.MultipartRequest('POST', registerUrl);

      request.fields.addAll({
        "agent": agentId,
        "name": name,
        "email": email,
        "phone": fortmatedPhoneNo,
        "address": address,
        "city": city,
        "state": state,
        "pincode": pincode,
        "loanAmount": loanAmount,
        "loanDuration": loanDuration,
        "loanStartDate": formatedDate,
        "emiAmount": emiAmount
      });

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          profileImage.path,
          contentType: MediaType('image', 'jpeg'), 
        ));
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

  
      if (response.statusCode == 200) {
      

        final data = jsonDecode(response.body);
        final clientName = data['data']['name'];
        final clientId = data['data']['_id'];
        
        await _storage.write(key: 'client_id_$clientName', value: clientId);

        _dates = calculateEmiDates(formatedDate, loanDuration, emiAmount);

        final List<Map<String, dynamic>> formattedEmiDates = _dates.map((date) {
        return {
          "emiDate": date,
          "status": false,
        };
      }).toList();


        final detailEmi = Uri.parse(setEmiUrl);
        final emiResponse = await http.post(detailEmi, body: jsonEncode({
            "client": clientId,
            "emiAmount": emiAmount,
            "emiDate": formattedEmiDates,
          }),

          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          } 
        
        );

        if (emiResponse.statusCode == 200) {
          state = DataState.loaded;
        } else {
          state = DataState.error;
        }

      } else {
        state = DataState.error;
      }
      
    } catch (e) {
      throw Exception(e);
    }
  }


}