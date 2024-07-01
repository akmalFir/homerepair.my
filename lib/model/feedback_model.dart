import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String userId;
  final String feedbackText;
  final DateTime timestamp;

  FeedbackModel({
    required this.userId,
    required this.feedbackText,
    required this.timestamp,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      userId: json['userId'] ?? '',
      feedbackText: json['feedbackText'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'feedbackText': feedbackText,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  @override
  String toString() {
    return 'FeedbackModel{userId: $userId, feedbackText: $feedbackText, timestamp: $timestamp}';
  }
}
