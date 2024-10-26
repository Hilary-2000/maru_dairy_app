import "dart:async";
import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as rq;
import "package:maru/pages/admin/membership.dart";
class ApiConnection{
  // String apiLink = "192.168.88.236:8000";
  String apiLink = "maru.ladybirdsmis.com";

  //   process login
  Future<String> processLogin(String username, String password) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/login");
    var body = jsonEncode({"username":username, "password":password});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/token");
    var body = jsonEncode({"token":token,});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/technician/$token");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/technician/dashboard/$period");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/register_member");
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
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/members");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/members/$memberId");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> adminMemberDetails(String memberId) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/members/$memberId");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/members/$memberId/uploadMilk");
    var body = jsonEncode({
      "collection_amount" : milkAmount
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/technician/collection_history/$period");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/technician/collection/$id");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/collection/update");
    var body = jsonEncode({
      "collection_amount" : amount,
      "collection_id" : collection_id
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/collection/");
    var body = jsonEncode({
      "collection_status" : status,
      "collection_period" : period,
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/technician/details/$token");
    var body = jsonEncode({});
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/technician/update/details");
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
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/technician/update/credentials");
    var body = jsonEncode({
      "username": username,
      "password": password
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/member/dashboard/$period");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/member/history");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/member/milk_details/$collection_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/member/milk_status/$collection_id");
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
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/member/profile");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/member/updateprofile");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
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
    var url = Uri.https(apiLink,"/api/admin/dashboard/$period");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> adminMembers() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/members");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> adminUpdateMember(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/update");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> adminMemberHistory(String member_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/history/$member_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> adminAddMember(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/new");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> viewAdminProfile() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/info");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> updateAdminProfile(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/update_profile");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getMilkPrices() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/milk_prices");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> addMilkPrices(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/milk_price/insert");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getCurrentMilkPrice() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/milk_prices");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> getEditMilkDetails(String price_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/milk_price/details/$price_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> updateMilkPrice(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/milk_price/update");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> getMilkPrice() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/milk_price/get");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> deleteMilkData(String collection_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/milk_collection/delete/$collection_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> deleteMember(String member_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/delete/$member_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> getMemberMembership(String member_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/membership/$member_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> acceptMemberPayment(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/accept-earning");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  //
  Future<String> declineMemberPayment(String payment_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/deletePayment/$payment_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  // make payment
  Future<String> paySubscription(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/member/pay_subscription");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  // make payment
  Future<String> paymentData(String payment_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/payments/details/$payment_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // make technicians
  Future<String> displayTechnicians() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/technicians");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> technicianDetails(String technicianId) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/technician/details/$technicianId");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  // get member data
  Future<String> updateTechnicianDetails(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/technician/update");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> deleteTechnician(String technician_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/technician/delete/$technician_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> registerTechnician(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/technician/new");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }
  // make technicians
  Future<String> displayAdministrators() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/administrator");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // make technicians
  Future<String> administratorDetails(String administrator_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/administrator/view/$administrator_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  Future<String> deleteAdministrator(String admin_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/administrator/delete/$admin_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  // get member data
  Future<String> updateAdministratorDetails(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/administrator/update");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> registerAdministrator(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/administrator/new");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  // make technicians
  Future<String> displaySuperAdmin() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/super_administrator");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  // make technicians
  Future<String> superAdministratorDetails(String super_administrator_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/super_administrator/view/$super_administrator_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  Future<String> deleteSuperAdministrator(String super_admin_id) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/super_administrator/delete/$super_admin_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> updateSuperAdministratorDetails(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/super_administrator/update");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> registerSuperAdministrator(var datapass) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/super_administrator/new");
    var body = jsonEncode(datapass);
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getDeductions() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/deductions");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> deleteDeductions({required String deduction_id}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/deductions/delete/$deduction_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }
  // get member data
  Future<String> updateDeduction({required String deduction_id, required String deduction_name}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/deductions/update");
    var body = jsonEncode({
      "deduction_id": deduction_id,
      "deduction_name": deduction_name
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> addDeductions({required String deduction_name}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/deductions/add");
    var body = jsonEncode({
      "deduction_name": deduction_name
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> changeDeductionStatus({required int deduction_id, required String deduction_status}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/deductions/update_status");
    var body = jsonEncode({
      "deduction_id": deduction_id,
      "deduction_status": deduction_status
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getRegions() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/regions");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> updateRegion({required String region_id, required String region_name}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/region/update");
    var body = jsonEncode({
      "region_id": region_id,
      "region_name": region_name
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> deleteRegion({required String region_id}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/region/delete/$region_id");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> addRegions({required String region_name}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/regions/add");
    var body = jsonEncode({
      "region_name": region_name
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  // get member data
  Future<String> changeRegionStatus({required String region_id, required String region_status}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/region/update_status");
    var body = jsonEncode({
      "region_id": region_id,
      "region_status": region_status
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getActiveRegions() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/regions/active");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getActiveDeductions() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/admin/deductions/active");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> resetPassword({required String username}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/login/resetpassword");
    var body = jsonEncode({
      "username" : username
    });
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }


  // get member data
  Future<String> getMemberMessages({required String member_id, required String send_status}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/chats/member");
    var body = jsonEncode({
      "member_id" : member_id,
      "send_status" : send_status
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> sendMessage({required String member_id, required String message, String message_status = "received"}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/chats/send_message");
    var body = jsonEncode({
      "member_id" : member_id,
      "message" : message,
      "message_status" : message_status
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getChats() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/chats/get_chats");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> deleteChatThreads({List<String> chat_thread_ids = const []}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/chats/delete_chat_threads");
    var body = jsonEncode({
      "chat_thread_ids": chat_thread_ids
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> deleteChat({List<String> chat_ids = const []}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/chats/delete_chats");
    var body = jsonEncode({
      "chat_ids": chat_ids
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getNotification({String entity = "admin"}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/notification/count");
    var body = jsonEncode({
      "entity": entity
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> getMemberNotification({String entity = "admin"}) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/notification/member/count");
    var body = jsonEncode({
      "entity": entity
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> checkMemberFCM() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/user/checkfcm");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> updateMemberFCM(String FCMToken) async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/user/updatefcm");
    var body = jsonEncode({
      "fcm_token" : FCMToken
    });
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }

  // get member data
  Future<String> logout() async{
    var client = rq.Client();
    var url = Uri.https(apiLink,"/api/user/logout");
    var body = jsonEncode({});
    FlutterSecureStorage storage = new FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'maru-authentication-code' : token!
          },
          body: body
      ).timeout(Duration(seconds: 60));
      return response.body.length > 0 ? (response.body.substring(response.body.length-1) != "}" ? response.body+"}" : response.body) : "{\"success\":false, \"message\":\"No response!\"}";
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }
}
