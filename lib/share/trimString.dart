String trimStringLine(String data, int lengthOfTheString) {
  return (data.length >= lengthOfTheString) ? '${data.substring(0, lengthOfTheString)}...' : data;
}
