import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:todo_app_test/DB/todo_data.dart';
import 'package:todo_app_test/entities/todo.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';



class EditPage extends StatefulWidget {
  
  static const String ROUTE = '/EditPage';
  

  
const EditPage({required this.todo,super.key});

   final Todo todo;
   
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
final _formKey = GlobalKey<FormBuilderState>();
TodoData todoData = TodoData();
late http.Response response;

void updateData()async{
  if (_formKey.currentState!.saveAndValidate()) {
    final data = _formKey.currentState!.value;
    final todo = Todo(
      id: widget.todo.id,
      title: data['title'],   
      description: data['description'],
    ); 

    response = await todoData.updateTodoData(id: widget.todo.id, todo: todo);
  }
  if (!mounted) return;
  Navigator.pop(context,true); 
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:const Icon(HugeIcons.strokeRoundedArrowLeft02, size: 25,color: Colors.white),
        onPressed: () {Navigator.of(context).pop();}),
        titleSpacing: -1,
        title: const Text("Editar Tarea", 
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      backgroundColor: const Color.fromARGB(226, 10, 0, 0), 
       
      ),
      body:  Container(
        height:800,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-4,-2),
            end: Alignment(3,0.5),
            colors: [  
             Color.fromRGBO(2,37,78,1),
              Color.fromARGB(255, 9, 43, 88), 
              Color.fromARGB(255, 36, 255, 222)
            ] 
          )
        ),
        child: Padding(
          padding:const EdgeInsets.all(10),
          child: FormBuilder(
            key: _formKey,
            initialValue: {
                          'title' : widget.todo.title,
                          'description': widget.todo.description,
                        },
                  child: Column(
                    children: [               
                      FormBuilderTextField(
                        name: 'title',
                        style: const TextStyle(color: Colors.white,fontSize: 20),
                        decoration: const InputDecoration(labelText: 'Descripción',labelStyle: TextStyle(color:Colors.white)),
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(),])
                      ),
                      const SizedBox(height: 30,),
                      FormBuilderTextField(
                        name: 'description',
                        style: const TextStyle(color: Colors.white,fontSize: 20),
                        decoration: const InputDecoration(labelText: 'Descripción',labelStyle: TextStyle(color:Colors.white), counterStyle:TextStyle(color:Colors.white)),
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(),])
                      ),
                      const SizedBox(height:40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [                
                          ElevatedButton(
                            onPressed:  (){
                              Navigator.pop(context);
                            }, 
                            child: const Text('Cancelar')
                          ),
                          const SizedBox(width:40),
                          ElevatedButton(
                            onPressed:  (){
                              updateData();    
                            }, 
                            child: const Text('Actualizar')
                          )
                        ]
                      )
                    ],
                  ),
                  ) 

      )
    
      )
    );
  }
  
}