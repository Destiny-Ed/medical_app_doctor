class ReadingString {
  static String getString = """
  subscription getSensorStream(\$type : SensorType!) {
  getSensorReadings(sensorType: \$type) {
    x y z activity timeStamp
  }
}
  """;
}
