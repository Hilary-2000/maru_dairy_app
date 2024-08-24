import "dart:async";
import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as rq;
class ApiConnection{
  String apiLink = "192.168.88.236:8000";

  //   process login
  Future<String> processLogin(String username, String password) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/login");
    var body = jsonEncode({"username":username, "password":password});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  //   process login
  Future<String> check_token(String token) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/token");
    var body = jsonEncode({"token":token,});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  //   process login
  Future<String> getTechnicianData(String token) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/technician/$token");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }
  //   process login
  Future<String> getTechnicianDashboard(String token, String period) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/technician/dashboard/$period");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  //   process login
  Future<String> saveNewMember(
      String fullname,
      String phone_number,
      String email,
      String id_number,
      String gender,
      String region,
      String username,
      String password
      ) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/register_member");
    var body = jsonEncode({
      "fullname":fullname,
      "phone_number": phone_number,
      "email": email,
      "gender": gender,
      "region": region,
      "username": username,
      "password": password,
      "national_id": id_number
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get members
  Future<String> getMembers(String token) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/members");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getMemberData(String token, String memberId) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/members/$memberId");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> collectMilkData(String token, String memberId, String milkAmount) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/members/$memberId/uploadMilk");
    var body = jsonEncode({
      "collection_amount" : milkAmount
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> collectHistory(String token, String period) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/technician/collection_history/$period");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> collectionDetails(String token, String id) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/technician/collection/$id");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> updateCollection(String token, String amount, String collection_id) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/collection/update");
    var body = jsonEncode({
      "collection_amount" : amount,
      "collection_id" : collection_id
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getCollection(String token, String status, String period) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/collection/");
    var body = jsonEncode({
      "collection_status" : status,
      "collection_period" : period,
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getTechnicianDetails(String token) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/technician/details/$token");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> updateTechnician(
  String token,
  String fullname,
  String gender,
  String phonenumber,
  String email,
  String residence,
  String region,
  String username,
  String national_id
  ) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/technician/update/details");
    var body = jsonEncode({
      "fullname" : fullname,
      "gender" : gender,
      "phone_number" : phonenumber,
      "email" : email,
      "residence": residence,
      "region": region,
      "username": username,
      "national_id": national_id
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> updatePassword(
      String token,
      String username,
      String password
      ) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/technician/update/credentials");
    var body = jsonEncode({
      "username": username,
      "password": password
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getMemberDash(String period) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/member/dashboard/$period");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getMemberHistory() async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/member/history");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getMilkDetails(String collection_id) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/member/milk_details/$collection_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> changeMilkStatus(String status, String collection_id) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/member/milk_status/$collection_id");
    var body = jsonEncode({
      "status": status
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getMemberDetails() async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/member/profile");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> updateMemberDetails(var datapass) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/member/updateprofile");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> adminDashboard(String period) async{
    var client = rq.Client();
    var url = Uri.http(apiLink,"/api/admin/dashboard/$period");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication_code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }
}
