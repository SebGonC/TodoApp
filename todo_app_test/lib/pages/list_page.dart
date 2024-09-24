import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:todo_app_test/DB/todo_data.dart';
import 'package:todo_app_test/pages/edit_page.dart';
import 'package:todo_app_test/pages/statistics_page.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app_test/entities/todo.dart';
import 'package:todo_app_test/pages/add_page.dart';



class ListPage extends StatefulWidget {
  const ListPage({super.key});
  static const String ROUTE = '/';

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TodoData todoData = TodoData();
  late List<Todo> data = [];
late http.Response response;
bool isTaskCompleted = false;
Todo todo = Todo.empty();

void updateData(int id,bool estado)async{
 bool nuevoEstado = !estado;
 response = await todoData.updateTodoEstado(id: id, nuevoEstado: nuevoEstado);
  if (response.statusCode >= 200 && response.statusCode <= 299) {
    setState(() {
      int index = data.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        data[index].estado = nuevoEstado;
      }
    });
  } else {
    print("Error al actualizar el estado en la base de datos");
  }
}

void toggleButton() {
    setState(() {
      isTaskCompleted = !isTaskCompleted;
    });
  }
    void getData()async{
    data = await todoData.getTodoData();
    setState(() {});
  }

  void deleteData(int id)async{
    
   response = await todoData.deleteTodoData(id: id);
    setState(() {});
    if (!mounted) return;
    Navigator.pop(context,true);
  }


  @override
 void initState(){
  getData();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    return 
    Scaffold(
      floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: ()async{
              final result = await showDialog(
                barrierColor: Colors.transparent,
                barrierDismissible:false,
                context: context,
                builder: (context){
                  return const FormSave() ;
                }
              );
              if (result == true) {
                              getData();
                            }
            }
      ),
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text("Lista de Tareas", 
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color.fromARGB(226, 10, 0, 0),
        actions: <Widget>[
          IconButton(
            constraints: BoxConstraints.tight( const Size(70, 65)),
            icon: const Icon(Ionicons.stats_chart, size: 25,color: Colors.white, ),
            tooltip: 'Statistics Icon',
            onPressed: () {
             

Navigator.push(context,
  MaterialPageRoute(
    builder: (context) => const StatisticsPage(),
  ),
);

              }
             
          )
        ]
      ),
      body: Container(
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
        child:ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    color: Colors.black.withOpacity(0.2),
                    child:ListTile(
                        onTap: () async {  
                           final result = await Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) {
                              
                                return EditPage(todo:data[index]);
                              },
                            )
                           ); 
                            if (result == true) {
                              getData();
                            }
                        },
                        contentPadding: const EdgeInsets.all(10),
                        minLeadingWidth:10,
                        minVerticalPadding: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius : BorderRadius.circular(30)
                        ),
                        isThreeLine: true,
                        dense: true,                  
                        leading:const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                             Icon(Ionicons.receipt_outline, color: Colors.white,),
                          ]
                        ),
                        title: Text(data[index].title,style: TextStyle(decoration: data[index].estado ? TextDecoration.lineThrough : null,color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        subtitle: Text(data[index].description, style: TextStyle(decoration: data[index].estado ? TextDecoration.lineThrough : null,color:Colors.white,fontSize: 17,fontWeight: FontWeight.w100)
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min, 
                              children: <Widget>[
                                IconButton(
                                onPressed: ()async{
                                  final result = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const  Text("¿Está segur@ que desea borrar la tarea?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Cancelar"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Borrar"),
                                            onPressed: () {
                                              deleteData(data[index].id);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                   if (result == true) {
                                    getData();
                                  }
                                }, 
                                icon: const Icon(HugeIcons.strokeRoundedDelete02,color: Colors.white)
                              ),
                              const SizedBox(width: 1),
                              IconButton(
                                onPressed: (){
                                 updateData(data[index].id,data[index].estado);
                                  //toggleButton();
                                  
                                }, 
                                icon: Icon(data[index].estado ? Icons.check_box : Icons.check_box_outline_blank,color: Colors.white,)
                              )
                              ]
                            )
                          ] 
                        )
                    )
                );
              },
            ), 
      )
    );
  }
}

