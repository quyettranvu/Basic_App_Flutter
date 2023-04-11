class Task {
  String task;
  DateTime time;

  //constructor
  Task({required this.task, required this.time});

  /*
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      age: json['age'],
      occupation: json['occupation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'occupation': occupation,
    };
  }*/

  //methods for converting to model object from String and from map
  factory Task.fromString(String task){
    return Task(
      task: task,
      time: DateTime.now(),
    );
  }

  factory Task.fromMap(Map<String, dynamic> map){
    return Task(
      task: map['task'],
      time: DateTime.fromMicrosecondsSinceEpoch(map['time'])
    );
  }

  Map<String, dynamic> getMap() {
    return {
      'task' : task,
      'time': time.millisecondsSinceEpoch,
    };
  }
}