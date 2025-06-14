import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/materials/materials_bloc.dart';
import '../../../logic/blocs/materials/materials_event.dart';
import '../../../logic/blocs/materials/materials_state.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../data/models/sell_model.dart';
import 'confirm_sell_page.dart';

class SellDetailsPage extends StatefulWidget {
  const SellDetailsPage({super.key});

  @override
  State<SellDetailsPage> createState() => _SellDetailsPageState();
}

class _SellDetailsPageState extends State<SellDetailsPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _materialNameController = TextEditingController();
  final TextEditingController _fridgeNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController();
  final TextEditingController _traderCommissionController = TextEditingController();
  final TextEditingController _officeCommissionController = TextEditingController();
  final TextEditingController _brokerageController = TextEditingController();
  final TextEditingController _pieceRateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _sellType = 'قطاعي';

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _materialNameController.dispose();
    _fridgeNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _commissionController.dispose();
    _traderCommissionController.dispose();
    _officeCommissionController.dispose();
    _brokerageController.dispose();
    _pieceRateController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _proceedToConfirmation() {
    if (_customerNameController.text.isEmpty || _customerPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال بيانات العميل')),
      );
      return;
    }

    if (_materialNameController.text.isEmpty || _fridgeNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال بيانات المادة')),
      );
      return;
    }

    if (_quantityController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الكمية والسعر')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmSellPage(
          customerName: _customerNameController.text,
          customerPhone: _customerPhoneController.text,
          materialName: _materialNameController.text,
          fridgeName: _fridgeNameController.text,
          sellType: _sellType,
          quantity: double.parse(_quantityController.text),
          price: double.parse(_priceController.text),
          commission: _commissionController.text.isNotEmpty ? double.parse(_commissionController.text) : null,
          traderCommission: _traderCommissionController.text.isNotEmpty ? double.parse(_traderCommissionController.text) : null,
          officeCommission: _officeCommissionController.text.isNotEmpty ? double.parse(_officeCommissionController.text) : null,
          brokerage: _brokerageController.text.isNotEmpty ? double.parse(_brokerageController.text) : null,
          pieceRate: _pieceRateController.text.isNotEmpty ? double.parse(_pieceRateController.text) : null,
          weight: _weightController.text.isNotEmpty ? double.parse(_weightController.text) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellBloc, SellState>(
      listener: (context, state) {
        if (state is SellError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SellLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 28, 98, 32),
              ),
            ),
          );
        }

        if (state is SellDetailsLoaded) {
          final sell = state.sell;
          return Scaffold(
            backgroundColor: const Color(0xFFF9F9F9),
            body: Column(
              children: [
                // Header
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                            'تفاصيل البيع',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                        ],
                      ),
                      if (sell.status == 'pending')
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('تأكيد البيع'),
                                content: const Text('هل أنت متأكد من تأكيد عملية البيع؟'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('إلغاء'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<SellBloc>().add(ConfirmSell(sell.id));
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                    ),
                                    child: const Text('تأكيد'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('تأكيد البيع'),
                        ),
                    ],
                  ),
                ),

                // Content
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
                                _buildInfoRow('اسم العميل', sell.customerName),
                                const SizedBox(height: 8),
                                _buildInfoRow('رقم الهاتف', sell.customerPhone),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Material Information
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
                                  'بيانات المادة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 28, 98, 32),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow('اسم المادة', sell.materialName),
                                const SizedBox(height: 8),
                                _buildInfoRow('البراد', sell.fridgeName),
                                const SizedBox(height: 8),
                                _buildInfoRow('نوع البيع', sell.sellType),
                                const SizedBox(height: 8),
                                _buildInfoRow('الكمية', sell.quantity.toString()),
                                const SizedBox(height: 8),
                                _buildInfoRow('السعر', '${sell.price} ريال'),
                                if (sell.commission != null) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow('العمولة', '${sell.commission} ريال'),
                                ],
                                if (sell.traderCommission != null) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow('عمولة التاجر', '${sell.traderCommission} ريال'),
                                ],
                                if (sell.officeCommission != null) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow('عمولة المكتب', '${sell.officeCommission} ريال'),
                                ],
                                if (sell.brokerage != null) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow('الوساطة', '${sell.brokerage} ريال'),
                                ],
                                if (sell.pieceRate != null) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow('سعر القطعة', '${sell.pieceRate} ريال'),
                                ],
                                if (sell.weight != null) ...[
                                  const SizedBox(height: 8),
                                  _buildInfoRow('الوزن', '${sell.weight} كجم'),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Total and Status
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
                                  'المجموع والحالة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 28, 98, 32),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow('المجموع الكلي', '${sell.totalPrice} ريال'),
                                const SizedBox(height: 8),
                                _buildInfoRow('التاريخ', sell.date.toString().split(' ')[0]),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'الحالة: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: sell.status == 'pending'
                                            ? Colors.orange.withOpacity(0.1)
                                            : Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: sell.status == 'pending'
                                              ? Colors.orange
                                              : Colors.green,
                                        ),
                                      ),
                                      child: Text(
                                        sell.status == 'pending' ? 'في انتظار التأكيد' : 'تم التأكيد',
                                        style: TextStyle(
                                          color: sell.status == 'pending'
                                              ? Colors.orange
                                              : Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text('حدث خطأ في تحميل البيانات'),
          ),
        );
      },
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

  IconData _getMaterialIcon(String materialName) {
    switch (materialName.toLowerCase()) {
      case 'طماطم':
        return Icons.grass;
      case 'تفاح':
        return Icons.apple;
      case 'خيار':
        return Icons.eco;
      case 'موز':
        return Icons.forest;
      case 'فريز':
        return Icons.icecream;
      case 'باذنجان':
        return Icons.eco;
      default:
        return Icons.shopping_basket;
    }
  }
}