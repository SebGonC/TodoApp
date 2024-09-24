import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_test/DB/todo_data.dart';
import 'package:todo_app_test/entities/todo.dart';


class FormSave extends StatefulWidget {
 const FormSave({super.key});
  @override
  State<FormSave> createState() => FormSaveState();
}

class FormSaveState extends State<FormSave> {
  TodoData todoData = TodoData();
  TodoData todoDataadd = TodoData();
  late List<Todo> data = [];
  late TextEditingController _todoControllerTitulo;
  late TextEditingController _todoControllerDescription;
  final _formKeyadd = GlobalKey<FormBuilderState>();
  late http.Response response;

void addData() async{
  
   if (_formKeyadd.currentState!.saveAndValidate()) {
    final data = _formKeyadd.currentState!.value;
    final todo = Todo(
      id:0,
      title: data['title'],
      description:  data['description'],
    );
    response = await todoDataadd.addTodoData(todo: todo);  
  }
  if (!mounted) return;
  Navigator.pop(context,true);
}

  void getData()async{
    data = await todoData.getTodoData();
    setState(() {});
  }

   @override
  void initState(){
    getData();
    _todoControllerTitulo = TextEditingController();
    _todoControllerDescription = TextEditingController();
    super.initState();
   }

  @override
  void dispose(){
    _todoControllerTitulo.dispose();
    _todoControllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Nivel de desenfoque
                    child:AlertDialog (
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius : BorderRadius.circular(20)),
                        title: const Text('Ingrese una nueva tarea'),
                          content:Padding(
                            padding:const EdgeInsets.all(10),
                              child: FormBuilder(
                                key: _formKeyadd,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [               
                    FormBuilderTextField(
                      name: 'title',
                      controller: _todoControllerTitulo,
                      decoration: const InputDecoration(labelText: 'Tarea'),
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(),])
                    ),
                    const SizedBox(height: 15,),
                    FormBuilderTextField(
                      name: 'description',
                      controller: _todoControllerDescription,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required(),])
                    ),
                    const SizedBox(height:40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [                
                        ElevatedButton(
                          onPressed:  (){
                          _todoControllerTitulo.clear();
                          _todoControllerDescription.clear();     
                            Navigator.pop(context);
                          }, 
                          child: const Text('Cancelar')
                        ),
                        const SizedBox(width:20),
                        ElevatedButton(
                          onPressed:  (){
                            if (_todoControllerTitulo.text.isEmpty || _todoControllerDescription.text.isEmpty) {  
                            Flushbar(
                              backgroundColor: const Color.fromARGB(255, 48, 48, 48),
                              title: 'Error:',
                              titleSize: 20,
                              titleColor: const Color.fromARGB(255, 255, 0, 0),
                              message: "Debe ingresar los datos requeridos",
                              messageColor: const Color.fromARGB(255, 252, 252, 252),                 
                              messageSize: 18,
                              duration: const Duration(milliseconds: 2500),
                              ).show(context);
                          }
                          else{
                            addData();   
                          } 
                          }, 
                          child: const Text('Guardar')
                        )
                      ]
                    )
                  ],
                ),)  
    ),           
                    )
                    );
      
 }
}