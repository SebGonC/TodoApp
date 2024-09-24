
class Todo{
  final int id;
  final String title;
  final String description;
  bool estado;
  int conteoElimi;
  int conteoComple;
  int conteoIncomple;


  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.estado =false,
    this.conteoElimi = 0,
    this.conteoComple=0,
    this.conteoIncomple=0,
  });

   Todo.empty({
    this.id=0,
    this.title='',
    this.description='',
    this.estado = false,
    this.conteoComple=0,
    this.conteoIncomple=0,
    this.conteoElimi = 0,
  });

  //Object to Map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'estado': estado,
      'conteoElimi': conteoElimi,
      'conteoComple': conteoComple,
      'conteoIncomple': conteoIncomple,
    };
  }

  //Map to Object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
     estado: json['estado'] as bool,
     conteoElimi: json['conteoElimi'] as int,
     conteoComple: json['conteoComple'] as int,
      conteoIncomple:json['conteoIncomple'] as int,
    );
  }

 
}


