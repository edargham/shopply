String unwrapList(List<String> list) {
  String result = '';

  for (String str in list) {
    result += '$str\n';
  }

  return result;
}
