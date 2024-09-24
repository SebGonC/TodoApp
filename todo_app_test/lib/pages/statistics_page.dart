import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:todo_app_test/entities/todo.dart';
import 'package:todo_app_test/DB/todo_data.dart';

import 'package:todo_app_test/widgets/indicator.dart';
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}
class _StatisticsPageState extends State<StatisticsPage> {
  TodoData todoData = TodoData();
  List<Todo> todos = [];
  bool isLoading = true;
 int touchedIndex = -1;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    todos = await todoData.getTodoData();
    setState(() {
      isLoading = false; // Cambia el estado a cargado una vez que se obtiene la data
    });
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold (
      appBar:  AppBar(
        backgroundColor: const Color.fromARGB(226, 10, 0, 0),  
        leading: IconButton(icon:const Icon(HugeIcons.strokeRoundedArrowLeft02, size: 25,color: Colors.white),
        onPressed: () {Navigator.of(context).pop();}),
        titleSpacing: -1,
        title: const Text("Estadísticas", 
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      body: 
      Container(
        height: 2000,
        width: 2000,
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
        child:AspectRatio(
      aspectRatio: 1.3,
      child: Row(
         mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width:150,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 4,
                  centerSpaceRadius: 30,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        const  
           Column(
            mainAxisAlignment: MainAxisAlignment.end,
           crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Colors.green,
                text: 'Eliminados   ',
                isSquare: false,
                textColor: Colors.white,
              ),
              SizedBox(
                height: 8,
              ),
              Indicator(
                color: Colors.blue,
                text: 'Completados',
                isSquare: false,
                textColor: Colors.white,
              ),
              SizedBox(
                height: 8,
              ),
              Indicator(
                color: Colors.purple,
                text: 'Incompletos',
                isSquare: false,
                textColor: Colors.white,
              ),
              SizedBox(
                height:50,
              ),
            
              SizedBox(
                height: 100,
              ),
            ],
          ),
          const SizedBox(
            width: 50,
          ),
        ]
    )
    )
    ));
  }

  List<PieChartSectionData> showingSections() {
    int conteoElimi = todos.isNotEmpty ? todos[0].conteoElimi : 0;
    int conteoComple = todos.isNotEmpty ? todos[0].conteoComple : 0;
    int conteoIncomple = todos.isNotEmpty ? todos[0].conteoIncomple : 0;
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 20.0;
      final radius = isTouched ? 60.0 : 80.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 20)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: conteoElimi.toDouble(),
            title: '$conteoElimi',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blue,
            value: conteoComple.toDouble(),
            title: ' $conteoComple',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: conteoIncomple.toDouble(),
            title: '$conteoIncomple',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}