List<double> parseDoubles(String input) {
  // Remove the double quotes and split the string by space
  List<String> parts = input.replaceAll('"', '').split(' ');

  // Parse the parts into double variables
  double firstDouble = double.parse(parts[0]);
  double secondDouble = double.parse(parts[1]);

  List<double> result = [firstDouble, secondDouble];

  return result;
}