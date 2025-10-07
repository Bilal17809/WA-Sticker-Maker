class FreepikModel {
  final Map<String, dynamic> raw;
  final List<String> generated;
  final String? taskId;
  final String? status;

  FreepikModel({
    required this.raw,
    required this.generated,
    this.taskId,
    this.status,
  });

  factory FreepikModel.fromJson(Map<String, dynamic> json) {
    final raw = Map<String, dynamic>.from(json);
    List<String> generated = [];
    String? taskId;
    String? status;

    List<String> extractImages(dynamic data) {
      final List<String> result = [];
      if (data is Map<String, dynamic>) {
        if (data['base64'] is String) result.add(data['base64']);
        if (data['url'] is String) result.add(data['url']);
        if (data['images'] is List) {
          for (var item in data['images']) {
            if (item is String) result.add(item);
            if (item is Map && item['url'] is String) result.add(item['url']);
            if (item is Map && item['base64'] is String) {
              result.add(item['base64']);
            }
          }
        }
        if (data['generated'] is List) {
          for (var item in data['generated']) {
            if (item is String) result.add(item);
            if (item is Map && item['url'] is String) result.add(item['url']);
            if (item is Map && item['base64'] is String) {
              result.add(item['base64']);
            }
          }
        }
      } else if (data is List) {
        for (var item in data) {
          if (item is String) result.add(item);
          if (item is Map && item['url'] is String) result.add(item['url']);
          if (item is Map && item['base64'] is String) {
            result.add(item['base64']);
          }
        }
      }
      return result;
    }

    if (raw['data'] != null) {
      generated = extractImages(raw['data']);
      if (raw['data'] is Map<String, dynamic>) {
        final data = raw['data'] as Map<String, dynamic>;
        taskId = data['task_id']?.toString();
        status = data['status']?.toString();
      }
    } else {
      generated = extractImages(raw);
      taskId = raw['task_id']?.toString();
      status = raw['status']?.toString();
    }

    return FreepikModel(
      raw: raw,
      generated: generated,
      taskId: taskId,
      status: status,
    );
  }
}
