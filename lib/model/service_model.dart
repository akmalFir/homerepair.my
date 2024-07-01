class ServiceModel {
  final String userId;
  final String serviceName;
  final String description;
  final String time;
  final double price;

  ServiceModel({
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.time,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      userId: json['userId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      price: json['price'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'serviceName': serviceName,
      'description': description,
      'time': time,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'ServiceModel{userId: $userId, serviceName: $serviceName, description: $description, time: $time, price: $price}';
  }
}
