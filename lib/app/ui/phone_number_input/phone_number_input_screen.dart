import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gongbab/app/router/app_routes.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_ui_state.dart';
import 'package:gongbab/app/ui/phone_number_input/phone_number_input_event.dart';
import 'package:gongbab/domain/entities/lookup/employee_match.dart';

import 'package:gongbab/app/ui/common_widgets/custom_alert_dialog.dart';
import '../select_name/select_name_dialog.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  const PhoneNumberInputScreen({super.key});

  @override
  State<PhoneNumberInputScreen> createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  String pin = '';
  final int pinLength = 4;
  late final PhoneNumberInputViewModel _viewModel;

  String _serverStatusText = 'SERVER OFFLINE';
  Color _serverStatusColor = const Color(0xFFef4444); // Red
  String _wifiStatusText = 'DISCONNECTED';
  Color _wifiStatusColor = const Color(0xFFef4444); // Red
  String _kioskId = '';

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<PhoneNumberInputViewModel>();
    _viewModel.addListener(_onViewModelChanged);
    // Trigger the initial event
    _viewModel.onEvent(ScreenInitialized());
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    final state = _viewModel.uiState;
    // Hide any existing snackbars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (state is Loading) {
      // Optionally show a loading indicator
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('처리 중...')),
      // );
    } else if (state is KioskStatusLoaded) {
      setState(() {
        if (state.kioskStatus.status == 'OK') {
          _serverStatusText = 'SERVER ONLINE';
          _serverStatusColor = const Color(0xFF10b981); // Green
        } else {
          _serverStatusText = 'SERVER OFFLINE';
          _serverStatusColor = const Color(0xFFef4444); // Red
        }

        if (state.isWifiConnected) {
          _wifiStatusText = 'CONNECTED';
          _wifiStatusColor = const Color(0xFF10b981); // Green
        } else {
          _wifiStatusText = 'DISCONNECTED';
          _wifiStatusColor = const Color(0xFFef4444); // Red
        }
        _kioskId = state.kioskCode;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('키오스크 상태: ${state.kioskStatus.status}')),
      // );
    } else if (state is EmployeeCandidatesLoaded) {
      _showEmployeeSelectionDialog(context, state.employees);
    } else if (state is CheckInSuccess) {
      // Navigate to success screen
      context.push(AppRoutes.success);
      _resetPin();
    } else if (state is AlreadyLogged) {
      _showCustomDialog(title: '중복 체크', message: state.message);
    } else if (state is Error) {
      _showCustomDialog(title: '오류', message: state.message);
    }
  }

  void _showCustomDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: title,
        content: message,
        rightButtonText: '확인',
        onRightButtonPressed: () {
          // Dialog is popped automatically by the button
        },
      ),
    ).then((_) => _resetPin());
  }

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
      _viewModel.onEvent(PhoneNumberEntered(pin));
    }
  }
  
  void _resetPin() {
    setState(() {
      pin = '';
    });
  }

  void _showEmployeeSelectionDialog(BuildContext context, List<EmployeeMatch> employees) {
    showDialog(
      context: context,
      barrierDismissible: true, // Or false if selection is mandatory
      builder: (context) => SelectNameDialog(
        employees: employees,
        onEmployeeSelected: (employee) {
          _viewModel.onEvent(EmployeeSelected(employee));
        },
      ),
    ).then((_) => _resetPin()); // Reset pin when dialog is dismissed
  }


  @override
  Widget build(BuildContext context) {
    // The build method remains largely the same, so it's omitted for brevity.
    // The key changes are in the logic (initState, dispose, event handlers), not the UI layout.
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
                  Text(
                    '휴대폰 번호',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  // SizedBox(height: 4.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '뒤 ',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF136bec),
                          ),
                        ),
                        TextSpan(
                          text: '4자리',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF136bec),
                          ),
                        ),
                        TextSpan(
                          text: ' 입력',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
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
                                    fontSize: 40.sp,
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
                    SizedBox(height: 12.h),
                    Expanded(child: _buildNumberRow(['4', '5', '6'])),
                    SizedBox(height: 12.h),
                    Expanded(child: _buildNumberRow(['7', '8', '9'])),
                    SizedBox(height: 12.h),

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
                              backgroundColor: const Color(0xFF135bec),
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
                    _serverStatusText,
                    _serverStatusColor,
                  ),
                  Text(
                    'KIOSK ID: $_kioskId',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF6b7280),
                    ),
                  ),
                  _buildStatusItem(
                    Icons.wifi,
                    _wifiStatusText,
                    _wifiStatusColor,
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
    List<Widget> children = [];
    for (int i = 0; i < numbers.length; i++) {
      children.add(
        Expanded(
          child: _buildKeypadButton(
            text: numbers[i],
            onPressed: () => onNumberPressed(numbers[i]),
            backgroundColor: const Color(0xFF2d3548),
          ),
        ),
      );
      if (i < numbers.length - 1) {
        children.add(const SizedBox(width: 12));
      }
    }
    return Row(children: children);
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
        child: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: icon != null
                ? Icon(icon,
                    color: iconColor ?? Colors.white,
                    size: constraints.maxHeight * 0.4)
                : Text(
                    text!,
                    style: TextStyle(
                      fontSize: constraints.maxHeight * 0.4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          );
        }),
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
            fontSize: 11.sp,
            color: color,
          ),
        ),
      ],
    );
  }
}
