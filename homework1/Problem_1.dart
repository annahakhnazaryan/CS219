

String numberToWords(int number) {
  if (number == 0) return "zero";
  const numbers_1to10 = [
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
  ];
  const numbers_10To20 = [
    "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
    "sixteen", "seventeen", "eighteen", "nineteen"
  ];
  const tens = [
    "",
    "",
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety"
  ];

  String convert1To99(int n) {
    if (n < 10) {
      return numbers_1to10[n - 1];
    } else if (n < 20) {
      return numbers_10To20[n - 10];
    }

    int tens_ = n ~/ 10;
    int u = n % 10;

    if (u == 0) {
      return tens[tens_];
    } else {
      return "${tens[tens_]} ${numbers_1to10[u-1]}";
    }
  }


  String convert1To999(int n) {
    if (n < 100) {
      return convert1To99(n);
    }

    int h_100 = n ~/ 100;
    int reminder = n % 100;

    if (reminder == 0) {
      return "${numbers_1to10[h_100-1]} hundred";
    } else {
      return "${numbers_1to10[h_100-1]} hundred ${convert1To99(reminder)}";
    }
  }

  int millions = number ~/ 1000000;
  int thousands = (number % 1000000) ~/ 1000;
  int hundreds = number % 1000;

  List<String> arr = [];

  if (millions > 0) arr.add("${convert1To999(millions)} million");
  if (thousands > 0) arr.add("${convert1To999(thousands)} thousand");
  if (hundreds > 0) arr.add(convert1To999(hundreds));

  return arr.join(' ');
}

void main() {
  List<int> randomNumbers = [
    579012,43562,891,1234,2,3109023,21
  ];

  for (var num in randomNumbers) {
    print("$num -> ${numberToWords(num)}");
  }
}
