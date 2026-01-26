import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fake_worker.dart';

class SelectNameDialog extends StatelessWidget {
  final List<Worker> workers;
  final Function(Worker) onWorkerSelected;

  const SelectNameDialog({
    super.key,
    required this.workers,
    required this.onWorkerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700),
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
                  Text(
                    'WORKER CHECK-IN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.6),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '이름을 선택하세요',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '동명이인이 발견되었습니다. 본인의 사번을\n확인 후 선택해 주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Worker List
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  final worker = workers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _WorkerCard(
                      worker: worker,
                      onTap: () {
                        onWorkerSelected(worker);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),

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
                  child: const Text(
                    '다시 검색하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

class _WorkerCard extends StatelessWidget {
  final Worker worker;
  final VoidCallback onTap;

  const _WorkerCard({
    required this.worker,
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
                      worker.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '사번: ${worker.employeeId} (${worker.department})',
                      style: TextStyle(
                        fontSize: 14,
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