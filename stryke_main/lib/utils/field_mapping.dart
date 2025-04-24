String getFieldNameForMetric(String metricName) {
  final fieldMap = {
    'Weight': 'weight',
  };

  // Add more mapping fuctions for other lifts

  return fieldMap[metricName] ?? metricName.toLowerCase();
}
