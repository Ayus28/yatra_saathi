import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PnrStatusScreen extends StatefulWidget {
  const PnrStatusScreen({super.key});

  @override
  State<PnrStatusScreen> createState() => _PnrStatusScreenState();
}

class _PnrStatusScreenState extends State<PnrStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pnrController = TextEditingController();

  // Check Button Logic & Validation Handler
  void _checkPnrStatus() {
    if (_formKey.currentState!.validate()) {
      String pnrNumber = _pnrController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fetching status for PNR: $pnrNumber'),
          backgroundColor: const Color(0xFF0284C7),
        ),
      );
      // Yahan aap Day 27-29 ke PNR results screen par navigate kar sakte hain
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Day 26 — PNR Status',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter 10-Digit PNR Number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // PNR Input Field with 10-digit restriction
              TextFormField(
                controller: _pnrController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Sirf numbers allow karega
                  LengthLimitingTextInputFormatter(10),   // Maximum 10 digits limit
                ],
                decoration: InputDecoration(
                  hintText: 'e.g. 2849102938',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.confirmation_number_rounded, color: Color(0xFF0284C7)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a PNR number';
                  }
                  if (value.length != 10) {
                    return 'PNR must be exactly 10 digits long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Check Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _checkPnrStatus,
                  child: const Text(
                    'Check PNR Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}