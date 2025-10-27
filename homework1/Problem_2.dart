class Problem_2 {
  int sumNested(dynamic element) {
    return switch (element) {
      int number => number,
      double fraction => fraction.floor(),
      String word => sumAscii(word),
      List group => sumSpecialList(group),
      Map dictionary => sumMap(dictionary),
      (var leftSide, var rightSide) => sumPair((leftSide, rightSide)),
      (first: var firstEl, second: var secondEl) =>
          sumPair((first: firstEl, second: secondEl)),
      _ => 0
    };
  }

  int sumPair(dynamic pairData) {
    return switch (pairData) {
      (var leftSide, var rightSide) =>
      sumNested(leftSide) + sumNested(rightSide),
      (first: var firstEl, second: var secondEl) =>
      sumNested(firstEl) + sumNested(secondEl),
      _ => 0
    };
  }

  int sumAscii(String word) {
    int asciiSum = 0;
    word.runes.forEach((code) {
      asciiSum += switch (code) {
        >= 0 && <= 127 => code,
        _ => 0
      };
    });
    return asciiSum;
  }

  int sumSpecialList(List<dynamic> group) {
    int sumValue = 0;
    for (final item in group) {
      sumValue += sumNested(item);
    }
    return sumValue;
  }

  int sumMap(Map dictionary) {
    int collected = 0;
    dictionary.values.forEach((entry) {
      collected += sumNested(entry);
    });
    return collected;
  }

// Prints explanation with breakdowns
  String explain(dynamic element) {
    return switch (element) {
      int number => "$number → $number",
      double fraction => "$fraction → ${fraction.floor()}",
      String word =>
      '"$word" → ${word.runes.map((r) => r).join(" + ")} = ${sumAscii(word)}',
      List group =>
      "$group → ${group.map(sumNested).join(" + ")} = ${sumSpecialList(group)}",
      Map dictionary =>
      "$dictionary → ${dictionary.values.map(sumNested).join(" + ")} = ${sumMap(
          dictionary)}",
      (var leftSide, var rightSide) =>
      "($leftSide, $rightSide) → ${sumNested(leftSide)} + ${sumNested(
          rightSide)} = ${sumPair((leftSide, rightSide))}",
      (first: var firstEl, second: var secondEl) =>
      "(first: $firstEl, second: $secondEl) → ${sumNested(
          firstEl)} + ${sumNested(secondEl)} = ${sumPair(
          (first: firstEl, second: secondEl))}",
      _ => "$element → 0"
    };
  }

  void main() {
    final dataset = [
      1,
      [2, 3, 4],
      {'a': 5, 'b': ["ab", 7]},
      [],
      {},
      "lk",
      (first: 8, second: "c"),
      {'c': (first: 10, second: ["xy", 12])},
      "z",
      13.5,
      [14, {'d': 15, 'e': (first: "p", second: 17)}],
    ];

    int grandTotal = 0;
    for (final record in dataset) {
      print(explain(record));
      grandTotal += sumNested(record);
    }
    print("Overall total = $grandTotal");
  }
}
