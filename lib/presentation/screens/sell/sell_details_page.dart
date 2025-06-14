import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../data/models/sell_model.dart';
import 'confirm_sell_page.dart';
import 'add_material_page.dart';

class SellDetailsPage extends StatefulWidget {
  final String name;
  final String phone;

  const SellDetailsPage({super.key, required this.name, required this.phone});

  @override
  State<SellDetailsPage> createState() => _SellDetailsPageState();
}

class _SellDetailsPageState extends State<SellDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SellBloc>().add(LoadSellProcesses());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: Column(
          children: [
            // Header
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFCFE8D7),
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
                      color: Color.fromARGB(255, 28, 98, 32) ,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'تفاصيل البيع',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color:Color.fromARGB(255, 28, 98, 32),  
                    ),
                  ),
                ],
              ),
            ),
            
            // Progress Steps
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStep(0, '1', 'الزبون', true),
                  _buildStepLine(),
                  _buildStep(1, '2', 'بيانات البيع', true),
                  _buildStepLine(),
                  _buildStep(2, '3', 'إتمام العملية', false),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Customer Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 28, 98, 32) ,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person_outline, 
                                  color: Color.fromARGB(255, 28, 98, 32) , size: 20),
                              const SizedBox(width: 8),
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 28, 98, 32) 
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined, 
                                  color: Color.fromARGB(255, 28, 98, 32) , size: 20),
                              const SizedBox(width: 8),
                              Text(widget.phone, style: TextStyle( color: Color.fromARGB(255, 28, 98, 32)) ) ,
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Add Material Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMaterialPage(
                                customerName: widget.name,
                                customerPhone: widget.phone,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 28, 98, 32),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'إضافة مواد',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Items List from API
                    Expanded(
                      child: BlocBuilder<SellBloc, SellState>(
                        builder: (context, state) {
                          if (state is SellLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is SellLoaded) {
                            // فلترة المواد حسب اسم أو رقم هاتف الزبون
                            final customerItems = state.items.where((item) =>
                              item.customerName == widget.name &&
                              item.customerPhone == widget.phone
                            ).toList();
                            if (customerItems.isEmpty) {
                              return const Center(child: Text('لا توجد مواد لهذا الزبون'));
                            }
                            return ListView.separated(
                              itemCount: customerItems.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = customerItems[index];
                                return _buildItemFromSellModel(item);
                              },
                            );
                          } else if (state is SellError) {
                            return Center(child: Text(state.message));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),

                    // Total Price
                    BlocBuilder<SellBloc, SellState>(
                      builder: (context, state) {
                        double total = 0;
                        if (state is SellLoaded) {
                          final customerItems = state.items.where((item) =>
                            item.customerName == widget.name &&
                            item.customerPhone == widget.phone
                          ).toList();
                          total = customerItems.fold(0, (sum, item) => sum + item.price);
                        }
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 28, 98, 32),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'المجموع الكلي',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 28, 98, 32)
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    NumberFormat.decimalPattern().format(total),
                                    style: const TextStyle(
                                      color:Color.fromARGB(255, 28, 98, 32),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Text(
                                    'دينار',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // يمكنك هنا تمرير أول مادة أو جميع المواد للصفحة التالية حسب الحاجة
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmSellPage(
                                customerName: widget.name,
                                customerPhone: widget.phone,
                                materialName: '',
                                fridgeName: '',
                                sellType: 'قطاعي',
                                quantity: 0,
                                price: 0,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color.fromARGB(255, 28, 98, 32),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'التالي',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemFromSellModel(SellModel item) {
    String formattedDate = DateFormat('d-M-yyyy hh:mm a').format(item.date);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color:Color.fromARGB(255, 28, 98, 32),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.materialName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:Color.fromARGB(255, 28, 98, 32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ 
              Column( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('الوزن', item.weight?.toString() ?? ''),
                  _buildDetailRow('العدد', item.quantity.toString()),
                  _buildDetailRow('البائع', item.fridgeName),
                  _buildDetailRow('التاريخ', formattedDate),
                 ] ,
             ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
                child: Text(
                  NumberFormat.decimalPattern().format(item.price),
                  style: const TextStyle(
                    color:Color.fromARGB(255, 28, 98, 32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildStep(int index, String number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ?Color.fromARGB(255, 28, 98, 32): Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ?Color.fromARGB(255, 28, 98, 32) : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: Colors.grey[300],
      ),
    );
  }
} 