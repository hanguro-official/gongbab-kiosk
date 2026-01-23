import 'package:flutter/material.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  const PhoneNumberInputScreen({super.key});

  @override
  State<PhoneNumberInputScreen> createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  String pin = '';
  final int pinLength = 4;

  void onNumberPressed(String number) {
    if (pin.length < pinLength) {
      setState(() {
        pin += number;
      });
    }
  }

  void onDeletePressed() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  void onOkPressed() {
    if (pin.length == pinLength) {
      // Handle authentication logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verifying PIN: $pin'),
          backgroundColor: const Color(0xFF3b82f6),
        ),
      );
      // Reset after verification
      setState(() {
        pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title Section
                  const Spacer(),
                  const Text(
                    '휴대폰 번호',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '뒤 ',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: '4자리',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3b82f6),
                          ),
                        ),
                        TextSpan(
                          text: ' 입력',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'INDUSTRIAL CAFETERIA SYSTEM V2.4',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6b7280),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),

                  // PIN Display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(pinLength, (index) {
                        return Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2d3548),
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  bottom: BorderSide(
                                    color: index < pin.length
                                        ? const Color(0xFF3b82f6)
                                        : const Color(0xFF2d3548),
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  index < pin.length ? pin[index] : '—',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: index < pin.length
                                        ? Colors.white
                                        : const Color(0xFF4b5563),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'EMPLOYEE VERIFICATION REQUIRED',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6b7280),
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Keypad
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Number rows
                    Expanded(child: _buildNumberRow(['1', '2', '3'])),
                    const SizedBox(height: 12),
                    Expanded(child: _buildNumberRow(['4', '5', '6'])),
                    const SizedBox(height: 12),
                    Expanded(child: _buildNumberRow(['7', '8', '9'])),
                    const SizedBox(height: 12),

                    // Bottom row with delete, 0, and OK
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildKeypadButton(
                              icon: Icons.backspace,
                              onPressed: onDeletePressed,
                              backgroundColor: const Color(0xFF2d3548),
                              iconColor: const Color(0xFFef4444),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildKeypadButton(
                              text: '0',
                              onPressed: () => onNumberPressed('0'),
                              backgroundColor: const Color(0xFF2d3548),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildKeypadButton(
                              text: 'OK',
                              onPressed: onOkPressed,
                              backgroundColor: const Color(0xFF3b82f6),
                              isEnabled: pin.length == pinLength,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Status Bar
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusItem(
                    Icons.circle,
                    'SERVER ONLINE',
                    const Color(0xFF10b981),
                  ),
                  const Text(
                    'KIOSK ID: FCT-092',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6b7280),
                    ),
                  ),
                  _buildStatusItem(
                    Icons.wifi,
                    'CONNECTED',
                    const Color(0xFF6b7280),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      children: numbers.map((number) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildKeypadButton(
              text: number,
              onPressed: () => onNumberPressed(number),
              backgroundColor: const Color(0xFF2d3548),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeypadButton({
    String? text,
    IconData? icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    Color? iconColor,
    bool isEnabled = true,
  }) {
    return Material(
      color: isEnabled ? backgroundColor : backgroundColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox.expand(
          child: FittedBox(
            child: Center(
              child: icon != null
                  ? Icon(icon, color: iconColor ?? Colors.white)
                  : Text(
                      text!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
          ),
        ),
      ],
    );
  }
}