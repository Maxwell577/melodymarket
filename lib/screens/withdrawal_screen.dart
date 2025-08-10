import 'package:flutter/material.dart';
import 'package:melodymarket/services/payment_service.dart';
import 'package:melodymarket/models/payment.dart';

class WithdrawalScreen extends StatefulWidget {
  final double availableBalance;

  const WithdrawalScreen({Key? key, required this.availableBalance}) : super(key: key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  bool isProcessing = false;
  List<Withdrawal> withdrawalHistory = [];

  @override
  void initState() {
    super.initState();
    _loadWithdrawalHistory();
  }

  void _loadWithdrawalHistory() async {
    try {
      final history = await PaymentService().getArtistWithdrawals('current_artist_id');
      setState(() {
        withdrawalHistory = history;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw Funds'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Balance Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'UGX ${widget.availableBalance.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Withdrawal Form
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Withdrawal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount to Withdraw (UGX)',
                        hintText: 'Enter amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.monetization_on),
                        suffixText: 'UGX',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Please enter a valid amount';
                        }
                        if (amount <= 0) {
                          return 'Amount must be greater than 0';
                        }
                        if (amount > widget.availableBalance) {
                          return 'Insufficient balance';
                        }
                        if (amount < 10000) { // Minimum withdrawal amount
                          return 'Minimum withdrawal is UGX 10,000';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'MTN Mobile Money Number',
                        hintText: '+256XXXXXXXXX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!value.startsWith('+256') || value.length != 13) {
                          return 'Please enter a valid Ugandan phone number';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Important Notes
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'Important Notes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• Minimum withdrawal: UGX 10,000\n'
                            '• Processing time: 1-3 business days\n'
                            '• Transaction fee: 2% of withdrawal amount\n'
                            '• Funds will be sent to your MTN Mobile Money',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isProcessing ? null : _processWithdrawal,
                        child: isProcessing
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Processing...'),
                                ],
                              )
                            : Text(
                                'Request Withdrawal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Withdrawal History
            Text(
              'Withdrawal History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            
            if (withdrawalHistory.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No withdrawal history',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...withdrawalHistory.map((withdrawal) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getStatusColor(withdrawal.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        _getStatusIcon(withdrawal.status),
                        color: _getStatusColor(withdrawal.status),
                      ),
                    ),
                    title: Text(
                      'UGX ${withdrawal.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To: ${withdrawal.phoneNumber}'),
                        Text(
                          _formatDate(withdrawal.createdAt),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(withdrawal.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(withdrawal.status),
                        style: TextStyle(
                          color: _getStatusColor(withdrawal.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  void _processWithdrawal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      
      final withdrawal = await PaymentService().initiateWithdrawal(
        artistId: 'current_artist_id',
        amount: amount,
        phoneNumber: _phoneController.text,
      );

      if (withdrawal.status == WithdrawalStatus.completed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Withdrawal request submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _amountController.clear();
        _phoneController.clear();
        
        // Refresh history
        _loadWithdrawalHistory();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Withdrawal failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Color _getStatusColor(WithdrawalStatus status) {
    switch (status) {
      case WithdrawalStatus.completed:
        return Colors.green;
      case WithdrawalStatus.pending:
      case WithdrawalStatus.processing:
        return Colors.orange;
      case WithdrawalStatus.failed:
      case WithdrawalStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(WithdrawalStatus status) {
    switch (status) {
      case WithdrawalStatus.completed:
        return Icons.check_circle;
      case WithdrawalStatus.pending:
        return Icons.schedule;
      case WithdrawalStatus.processing:
        return Icons.hourglass_empty;
      case WithdrawalStatus.failed:
        return Icons.error;
      case WithdrawalStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(WithdrawalStatus status) {
    switch (status) {
      case WithdrawalStatus.completed:
        return 'Completed';
      case WithdrawalStatus.pending:
        return 'Pending';
      case WithdrawalStatus.processing:
        return 'Processing';
      case WithdrawalStatus.failed:
        return 'Failed';
      case WithdrawalStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}