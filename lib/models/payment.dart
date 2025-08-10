class Payment {
  final String id;
  final String userId;
  final String trackId;
  final double amount;
  final String currency;
  final String method; // 'mtn_mobile_money', 'card', etc.
  final PaymentStatus status;
  final DateTime createdAt;
  final String? transactionId;
  final String? phoneNumber;

  Payment({
    required this.id,
    required this.userId,
    required this.trackId,
    required this.amount,
    this.currency = 'UGX',
    required this.method,
    this.status = PaymentStatus.pending,
    required this.createdAt,
    this.transactionId,
    this.phoneNumber,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'],
    userId: json['userId'],
    trackId: json['trackId'],
    amount: (json['amount']).toDouble(),
    currency: json['currency'] ?? 'UGX',
    method: json['method'],
    status: PaymentStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => PaymentStatus.pending,
    ),
    createdAt: DateTime.parse(json['createdAt']),
    transactionId: json['transactionId'],
    phoneNumber: json['phoneNumber'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'trackId': trackId,
    'amount': amount,
    'currency': currency,
    'method': method,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'transactionId': transactionId,
    'phoneNumber': phoneNumber,
  };
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded
}

class Withdrawal {
  final String id;
  final String artistId;
  final double amount;
  final String currency;
  final String method;
  final String phoneNumber;
  final WithdrawalStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? transactionId;
  final String? failureReason;

  Withdrawal({
    required this.id,
    required this.artistId,
    required this.amount,
    this.currency = 'UGX',
    required this.method,
    required this.phoneNumber,
    this.status = WithdrawalStatus.pending,
    required this.createdAt,
    this.processedAt,
    this.transactionId,
    this.failureReason,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) => Withdrawal(
    id: json['id'],
    artistId: json['artistId'],
    amount: (json['amount']).toDouble(),
    currency: json['currency'] ?? 'UGX',
    method: json['method'],
    phoneNumber: json['phoneNumber'],
    status: WithdrawalStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => WithdrawalStatus.pending,
    ),
    createdAt: DateTime.parse(json['createdAt']),
    processedAt: json['processedAt'] != null 
        ? DateTime.parse(json['processedAt']) 
        : null,
    transactionId: json['transactionId'],
    failureReason: json['failureReason'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'artistId': artistId,
    'amount': amount,
    'currency': currency,
    'method': method,
    'phoneNumber': phoneNumber,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'processedAt': processedAt?.toIso8601String(),
    'transactionId': transactionId,
    'failureReason': failureReason,
  };
}

enum WithdrawalStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled
}