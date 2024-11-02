import 'package:cloud_firestore/cloud_firestore.dart';

class RequestTemp {
  final String sendId;
  final String receiverId;
  final String projectid;
  final String message;
  final Timestamp timestamp;
  List<String> skills;
  final String projectTitle;
  Map<String, dynamic> userdata;

  RequestTemp({
    required this.sendId,
    required this.receiverId,
    required this.projectid,
    required this.message,
    required this.timestamp,
    required this.userdata,
    required this.projectTitle,
    this.skills = const [],
  });
  Map<String, dynamic> tomap() {
    return {
      'senderId': sendId,
      'receiverId': receiverId,
      'projectId': projectid,
      'message': message,
      'timestamp': timestamp,
      'Skill': skills,
      'UserData':userdata,
      'Title':projectTitle,
    };
  }
}


class ApplicationTemp {
  final String sendId;
  final String receiverId;
  final String jobid;
  final String message;
  final Timestamp timestamp;
  final String projectTitle;
  Map<String, dynamic> userdata;

  ApplicationTemp({
    required this.sendId,
    required this.receiverId,
    required this.jobid,
    required this.message,
    required this.timestamp,
    required this.userdata,
    required this.projectTitle,
   
  });
  Map<String, dynamic> tomap() {
    return {
      'senderId': sendId,
      'receiverId': receiverId,
      'jobId': jobid,
      'message': message,
      'timestamp': timestamp,
      'UserData':userdata,
      'Title':projectTitle,
    };
  }
}