import 'package:melodymarket/models/payment.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  // Mock MTN Mobile Money Integration
  Future<Payment> initiateMTNMobileMoneyPayment({
    required String userId,
    required String trackId,
    required double amount,
    required String phoneNumber,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    final payment = Payment(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      trackId: trackId,
      amount: amount,
      method: 'mtn_mobile_money',
      createdAt: DateTime.now(),
      phoneNumber: phoneNumber,
      status: PaymentStatus.processing,
    );

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));
    
    // 90% success rate for demo
    final success = DateTime.now().millisecond % 10 != 0;
    
    return payment.copyWith(
      status: success ? PaymentStatus.completed : PaymentStatus.failed,
      transactionId: success ? 'mtn_${DateTime.now().millisecondsSinceEpoch}' : null,
    );
  }

  Future<Withdrawal> initiateWithdrawal({
    required String artistId,
    required double amount,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final withdrawal = Withdrawal(
      id: 'wd_${DateTime.now().millisecondsSinceEpoch}',
      artistId: artistId,
      amount: amount,
      method: 'mtn_mobile_money',
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
      status: WithdrawalStatus.processing,
    );

    // Simulate processing
    await Future.delayed(const Duration(seconds: 4));
    
    final success = DateTime.now().millisecond % 20 != 0; // 95% success rate
    
    return withdrawal.copyWith(
      status: success ? WithdrawalStatus.completed : WithdrawalStatus.failed,
      processedAt: DateTime.now(),
      transactionId: success ? 'mtn_wd_${DateTime.now().millisecondsSinceEpoch}' : null,
      failureReason: success ? null : 'Insufficient funds in merchant account',
    );
  }

  Future<List<Payment>> getUserPayments(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - in real app, this would fetch from backend
    return [
      Payment(
        id: 'pay_001',
        userId: userId,
        trackId: 'track_001',
        amount: 5000,
        method: 'mtn_mobile_money',
        status: PaymentStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        transactionId: 'mtn_123456789',
      ),
      Payment(
        id: 'pay_002',
        userId: userId,
        trackId: 'track_002',
        amount: 3000,
        method: 'mtn_mobile_money',
        status: PaymentStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        transactionId: 'mtn_987654321',
      ),
    ];
  }

  Future<List<Withdrawal>> getArtistWithdrawals(String artistId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Withdrawal(
        id: 'wd_001',
        artistId: artistId,
        amount: 50000,
        method: 'mtn_mobile_money',
        phoneNumber: '+256700000000',
        status: WithdrawalStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        processedAt: DateTime.now().subtract(const Duration(days: 6)),
        transactionId: 'mtn_wd_123456789',
      ),
    ];
  }
}

extension PaymentCopy on Payment {
  Payment copyWith({
    String? id,
    String? userId,
    String? trackId,
    double? amount,
    String? currency,
    String? method,
    PaymentStatus? status,
    DateTime? createdAt,
    String? transactionId,
    String? phoneNumber,
  }) => Payment(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    trackId: trackId ?? this.trackId,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    method: method ?? this.method,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    transactionId: transactionId ?? this.transactionId,
    phoneNumber: phoneNumber ?? this.phoneNumber,
  );
}

extension WithdrawalCopy on Withdrawal {
  Withdrawal copyWith({
    String? id,
    String? artistId,
    double? amount,
    String? currency,
    String? method,
    String? phoneNumber,
    WithdrawalStatus? status,
    DateTime? createdAt,
    DateTime? processedAt,
    String? transactionId,
    String? failureReason,
  }) => Withdrawal(
    id: id ?? this.id,
    artistId: artistId ?? this.artistId,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    method: method ?? this.method,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    processedAt: processedAt ?? this.processedAt,
    transactionId: transactionId ?? this.transactionId,
    failureReason: failureReason ?? this.failureReason,
  );
}