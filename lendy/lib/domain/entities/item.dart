import 'item_status.dart';

class Item {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String borrowerName;
  final String? borrowerContact;
  final DateTime lentAt;
  final DateTime? dueAt;
  final DateTime? reminderAt;
  final ItemStatus status;
  final DateTime? returnedAt;
  final List<String>? photoUrls;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.borrowerName,
    this.borrowerContact,
    required this.lentAt,
    this.dueAt,
    this.reminderAt,
    required this.status,
    this.returnedAt,
    this.photoUrls,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert from JSON (Supabase response)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      borrowerName: json['borrower_name'] as String,
      borrowerContact: json['borrower_contact'] as String?,
      lentAt: DateTime.parse(json['lent_at'] as String),
      dueAt: json['due_at'] != null 
          ? DateTime.parse(json['due_at'] as String) 
          : null,
      reminderAt: json['reminder_at'] != null 
          ? DateTime.parse(json['reminder_at'] as String) 
          : null,
      status: ItemStatus.fromString(json['status'] as String),
      returnedAt: json['returned_at'] != null 
          ? DateTime.parse(json['returned_at'] as String) 
          : null,
      photoUrls: json['photo_urls'] != null 
          ? List<String>.from(json['photo_urls'] as List) 
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert to JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'borrower_name': borrowerName,
      'borrower_contact': borrowerContact,
      'lent_at': lentAt.toIso8601String(),
      'due_at': dueAt?.toIso8601String(),
      'reminder_at': reminderAt?.toIso8601String(),
      'status': status.value,
      'returned_at': returnedAt?.toIso8601String(),
      'photo_urls': photoUrls,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields (useful for updates)
  Item copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? borrowerName,
    String? borrowerContact,
    DateTime? lentAt,
    DateTime? dueAt,
    DateTime? reminderAt,
    ItemStatus? status,
    DateTime? returnedAt,
    List<String>? photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      borrowerName: borrowerName ?? this.borrowerName,
      borrowerContact: borrowerContact ?? this.borrowerContact,
      lentAt: lentAt ?? this.lentAt,
      dueAt: dueAt ?? this.dueAt,
      reminderAt: reminderAt ?? this.reminderAt,
      status: status ?? this.status,
      returnedAt: returnedAt ?? this.returnedAt,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

