import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_test/entities/todo.dart';

const String baseUri =  'https://192.168.1.14:5000/api/Todos'; 

class TodoData with ChangeNotifier  {

Future<http.Response> addTodoData({required Todo todo}) async{
  final uri = Uri.parse (baseUri);
  late http.Response response;

    try{
     response = await http.post(
      uri, headers: <String,String>{'Content-type' : 'application/json; charset=utf-8'},
      body:json.encode(todo),
    );
    }catch(e){
      return response;   
    }
  notifyListeners();
  return response;
  }

Future<List<Todo>> getTodoData() async{
  List<Todo> data = [];
  final uri = Uri.parse (baseUri);
  final response = await http.get(
    uri,
    headers: <String,String>{
    'Content-type' : 'application/json; charset=utf-8'}
  ); 

  if (response.statusCode >= 200 && response.statusCode <=299 ){
    try{
      final List<dynamic> jsonData = json.decode(response.body);
      data = jsonData.map((json) => Todo.fromJson(json)).toList();    
    }catch(e){     
      return data;   
    }
  }
  notifyListeners();
  return data;
  
  }

Future<http.Response> updateTodoData({required int id, required Todo todo}) async{
  final uri = Uri.parse ("$baseUri/$id");
  late http.Response response;

    try{
     response = await http.put(
      uri, headers: <String,String>{'Content-type' : 'application/json; charset=utf-8'},
      body:json.encode(todo),
    ); 
    }catch(e){
     
      return response;   
    }
  notifyListeners();
  return response;
  }

Future<http.Response> deleteTodoData({required int id}) async{
  final uri = Uri.parse ("$baseUri/$id");
  late http.Response response;

    try{
     response = await http.delete(
      uri, headers: <String,String>{'Content-type' : 'application/json; charset=utf-8'},
    );
    }catch(e){
      return response;   
    } 
  notifyListeners();
  return response;
  }


Future<http.Response> updateTodoEstado({required int id, required bool nuevoEstado}) async {
  final uri = Uri.parse("$baseUri/$id");
  http.Response response = http.Response('Error', 500);

  // Obtiene el Todo actual de la base de datos para no perder sus otros campos
  Todo? todoExistente;
  
  // Llama a la API para obtener el Todo actual por su ID
  final getResponse = await http.get(uri, headers: <String, String>{'Content-type': 'application/json; charset=utf-8'});
  
  if (getResponse.statusCode >= 200 && getResponse.statusCode <= 299) {
    try {
      final jsonData = json.decode(getResponse.body);
      todoExistente = Todo.fromJson(jsonData);
    } catch (e) {
      return response; 
    }
  }

  // Si el todo existe, procede a cambiar su estado
  if (todoExistente != null) {
    Todo todoActualizado = Todo(
      id: todoExistente.id,
      title: todoExistente.title,
      description: todoExistente.description,
      estado: nuevoEstado,
      
    );
    try {
      response = await http.put(
        uri,
        headers: <String, String>{'Content-type': 'application/json; charset=utf-8'},
        body: json.encode(todoActualizado.toJson()), // Convierte el objeto actualizado a JSON
      );
    } catch (e) {
      return response; // En caso de error al intentar hacer el update
    }

    notifyListeners(); // Notifica a los listeners
  }
  
  return response; // Retorna la respuesta final de la API
}




}