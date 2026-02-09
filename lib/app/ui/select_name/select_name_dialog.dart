import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gongbab/domain/entities/lookup/employee_match.dart';

class SelectNameDialog extends StatelessWidget {
  final List<EmployeeMatch> employees;
  final Function(EmployeeMatch) onEmployeeSelected;

  const SelectNameDialog({
    super.key,
    required this.employees,
    required this.onEmployeeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(32.w),
      child: Container(
        constraints: BoxConstraints(maxHeight: 700.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1f2e),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Text(
                  //   'WORKER CHECK-IN',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.white.withOpacity(0.6),
                  //     letterSpacing: 2,
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  Text(
                    '이름을 선택하세요',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Text(
                  //   '동명이인이 발견되었습니다. 본인의 사번을\n확인 후 선택해 주세요.',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.white.withOpacity(0.6),
                  //     height: 1.5,
                  //   ),
                  // ),
                ],
              ),
            ),

            // Worker List
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _EmployeeCard(
                      employee: employee,
                      onTap: () {
                        onEmployeeSelected(employee);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            // Search Again Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF2d3548),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '다시 검색하기',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final EmployeeMatch employee;
  final VoidCallback onTap;

  const _EmployeeCard({
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2563eb),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '사번: ${employee.employeeId} (${employee.companyName})',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.6),
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}