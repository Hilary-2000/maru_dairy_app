import "dart:async";
import "dart:convert";

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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
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
      ).timeout(Duration(seconds: 10));
      client.close();
      return response.body;
    }on TimeoutException {
      return "{\"success\":false, \"message\":\"No connection!\"}";// Handle the timeout exception
    } catch(e){
      return "{\"success\":false, \"message\":\"$e\"}";
    }finally{
      client.close();
    }
  }
}
