void main() {

  final kevin = Person('developer',name:'kevin',age:25,email:'kk@gamil.com');
  final mike = Person.developer(age:25,name:'mike',email:'mm@gamil.com');
  final chris = Person.factory('chris');

  print(kevin.email);
  print(kevin.name);
  print(kevin.age);

  kevin.hello();
  mike.hello();
  chris.hello();

}

class Person {
  final String name;
  final int age;
  final String email;
  String position;

  //方法一
  Person(this.position, {this.name,  this.age,  this.email});

  //方法二
  Person.developer({ this.name,  this.age,  this.email}) {
    this.position = 'developer';
  }

  //方法三
  factory Person.factory(String name) {
    return Person('developer', name: name, age: 25, email: 'factory@gamil.com');
  }

  void hello() {
    print('hello, i\'m $name. my position is $position');
  }
}