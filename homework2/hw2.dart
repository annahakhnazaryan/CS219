import 'dart:io';

void taskMovies() {
  List<String> movies = ["Harry Potter and the Philosopher's Stone", "Up", "Divergent"];
  List<int> years = [2001, 2009, 2014];

  print("My Top 3 Favorite Movies:");
  for (int i = 0; i < movies.length; i++) {
    print("${movies[i]} - released in ${years[i]}");
  }
}

void taskStringManipulation() {
  String og = "Ronald is fun";
  String combined = og + " and creative!";
  String part = og.substring(0, 6);
  String upper = part.toUpperCase();
  String lower = og.substring(7).toLowerCase();

  print("Original: $og");
  print("Combined: $combined");
  print("Uppercase part: $upper");
  print("Lowercase part: $lower");
}

void taskMap() {
  Map<String, int> favoriteNumbers = {"Anna": 7, "Harry": 3, "Hermione": 5};

  print("Favorite numbers of characters:");
  favoriteNumbers.forEach((key, value) {
    print("$key -> $value");
  });
}

String checkNumberSign(int number) {
  if (number == 0) return "The number is zero.";
  else if (number > 0) return "The number is positive.";
  else return "The number is negative.";
}

void askAndGreet() {
  stdout.write("Enter your name: ");
  String? name = stdin.readLineSync();

  stdout.write("Enter your age: ");
  int age = int.parse(stdin.readLineSync()!);

  print("Hello, $name!");

  if (age < 18) {
    print("You're young");
  } else if (age < 60) {
    print("You're an adult");
  } else {
    print("You are too old");
  }
}

void divideNumbers(num a, num b) {
  try {
    num result = a / b;
    print("Result: $a ÷ $b = $result");
  } catch (e) {
    print('Error: You can\'t divide by zero.');
  }
}


void showCurrentDateTime() {
  DateTime now = DateTime.now();
  print("Current date and time: $now");
}

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void showDetails() {
    print("$name is $age years old.");
  }
}

class LifeStage extends Person {
  LifeStage(String name, int age) : super(name, age);

  String getLifeStage() {
    if (age < 13) return "Child";
    else if (age < 20) return "Teenager";
    else return "Adult";
  }
}

void filterEvenNumbers() {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 16, 32, 67, 202];
  List<int> evens = numbers.where((n) => n % 2 == 0).toList();
  print("Even numbers: $evens");
}

void main() {
  taskMovies();
  taskStringManipulation();
  taskMap();
  print(checkNumberSign(5));
  askAndGreet();
  divideNumbers(10, 2);
  showCurrentDateTime();

  Person p1 = Person("Anna", 21);
  p1.showDetails();

  LifeStage p2 = LifeStage("Harry", 16);
  p2.showDetails();
  print("Life stage: ${p2.getLifeStage()}");

  filterEvenNumbers();
}
