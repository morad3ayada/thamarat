import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';

class ConfirmSellPage extends StatelessWidget {
  final String customerName;
  final String customerPhone;
  final String materialName;
  final String fridgeName;
  final String sellType;
  final double quantity;
  final double price;
  final double? commission;
  final double? traderCommission;
  final double? officeCommission;
  final double? brokerage;
  final double? pieceRate;
  final double? weight;

  const ConfirmSellPage({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.materialName,
    required this.fridgeName,
    required this.sellType,
    required this.quantity,
    required this.price,
    this.commission,
    this.traderCommission,
    this.officeCommission,
    this.brokerage,
    this.pieceRate,
    this.weight,
  });

  double get _totalPrice {
    return quantity * price;
  }

  void _completeSale(BuildContext context) {
    context.read<SellBloc>().add(
          AddSellMaterial(
            customerName: customerName,
            customerPhone: customerPhone,
            materialName: materialName,
            fridgeName: fridgeName,
            sellType: sellType,
            quantity: quantity,
            price: price,
            commission: commission,
            traderCommission: traderCommission,
            officeCommission: officeCommission,
            brokerage: brokerage,
            pieceRate: pieceRate,
            weight: weight,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFDAF3D7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(top: 45, right: 20, left: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'تأكيد البيع',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Information
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'بيانات العميل',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                customerName,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                customerPhone,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Material Information
                  const Text(
                    'بيانات المادة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 98, 32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow('اسم المادة', materialName),
                          const SizedBox(height: 8),
                          _buildInfoRow('الثلاجة', fridgeName),
                          const SizedBox(height: 8),
                          _buildInfoRow('نوع البيع', sellType),
                          const SizedBox(height: 8),
                          _buildInfoRow('الكمية', quantity.toString()),
                          const SizedBox(height: 8),
                          _buildInfoRow('السعر', '${price} ريال'),
                          if (commission != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow('العمولة', '${commission} ريال'),
                          ],
                          if (traderCommission != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow('عمولة التاجر', '${traderCommission} ريال'),
                          ],
                          if (officeCommission != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow('عمولة المكتب', '${officeCommission} ريال'),
                          ],
                          if (brokerage != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow('الوساطة', '${brokerage} ريال'),
                          ],
                          if (pieceRate != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow('سعر القطعة', '${pieceRate} ريال'),
                          ],
                          if (weight != null) ...[
                            const SizedBox(height: 8),
                            _buildInfoRow('الوزن', '${weight} كجم'),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total Price
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'المجموع الكلي',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_totalPrice} ريال',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocListener<SellBloc, SellState>(
            listener: (context, state) {
              if (state is SellConfirmed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إتمام عملية البيع بنجاح'),
                    backgroundColor: Color.fromARGB(255, 28, 98, 32),
                  ),
                );
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (state is SellError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<SellBloc, SellState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: state is SellLoading
                          ? null
                          : () => _completeSale(context),
                      child: state is SellLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'تأكيد البيع',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
