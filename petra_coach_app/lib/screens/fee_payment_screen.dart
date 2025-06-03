import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../services/fee_service.dart';
import 'package:uuid/uuid.dart';

class FeePaymentScreen extends StatefulWidget {
  final String studentId;

  const FeePaymentScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  _FeePaymentScreenState createState() => _FeePaymentScreenState();
}

class _FeePaymentScreenState extends State<FeePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feeService = FeeService();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPaymentMethod = 'Cash';

  bool _isProcessing = false;

  Future<void> _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      try {
        final payment = Payment(
          id: const Uuid().v4(),
          studentId: widget.studentId,
          amount: double.parse(_amountController.text),
          paymentDate: DateTime.now(),
          paymentMethod: _selectedPaymentMethod,
          status: 'Completed',
          description: _descriptionController.text,
          receiptNumber: DateTime.now().millisecondsSinceEpoch.toString(),
          feeStructureId: '', // Add appropriate fee structure ID
        );

        await _feeService.createPayment(payment);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment processed successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error processing payment: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: ['Cash', 'UPI', 'Card', 'Bank Transfer']
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isProcessing ? null : _submitPayment,
                child: _isProcessing
                    ? const CircularProgressIndicator()
                    : const Text('Process Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 