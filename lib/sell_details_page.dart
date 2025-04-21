import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'confirm_sell_page.dart';
import 'add_material_page.dart'; // ✅ تم الاستدعاء هنا

class SellDetailsPage extends StatelessWidget {
  final String name;
  final String phone;

  const SellDetailsPage({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "name": "اسم المادة",
        "weight": "الوزن",
        "quantity": "العدد",
        "seller": "أحمد علي",
        "price": "5,000,000",
        "dateTime": DateTime(2025, 2, 19, 12, 30),
      },
      {
        "name": "اسم المادة",
        "weight": "الوزن",
        "quantity": "العدد",
        "seller": "أحمد علي",
        "price": "5,000,000",
        "dateTime": DateTime(2025, 2, 19, 12, 30),
      },
    ];

    int totalPrice = items.fold(
      0,
      (sum, item) => sum + int.parse(item["price"].replaceAll(',', '')),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFDCEFD9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('بيع مادة', style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTab(isActive: true, number: '1', label: 'الزبون'),
                  _buildTab(isActive: true, number: '2', label: 'بيانات البيع'),
                  _buildTab(
                    isActive: false,
                    number: '3',
                    label: 'إتمام العملية',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      'اسم الزبون',
                      style: TextStyle(
                        color: Color(0xFF4D944F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'رقم الهاتف',
                      style: TextStyle(
                        color: Color(0xFF4D944F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildInfoBox(name)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoBox(phone)),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'اضغط على (+) لإضافة المواد',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddMaterialPage(),
                    ),
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.add_circle, color: Color(0xFF4D944F)),
                    SizedBox(width: 6),
                    Text(
                      'المواد المضافة',
                      style: TextStyle(
                        color: Color(0xFF4D944F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...items.map((item) => _buildItem(item)).toList(),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'السعر الكلي',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberFormat.decimalPattern().format(totalPrice),
                        style: const TextStyle(
                          color: Color(0xFF4D944F),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text('دينار'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D944F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ConfirmSellPage(
                              name: name,
                              phone: phone,
                              totalPrice: totalPrice,
                              items: items,
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    'التالي',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    String formattedDate = DateFormat(
      'd-M-yyyy\nhh:mm a',
    ).format(item["dateTime"]);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.delete, color: Colors.red[300]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(item["weight"]),
                Text(item["quantity"]),
                Text('البائع: ${item["seller"]}'),
                Text(formattedDate),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCEFD9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item["price"],
                    style: const TextStyle(color: Color(0xFF4D944F)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Text(text),
    );
  }

  Widget _buildTab({
    required bool isActive,
    required String number,
    required String label,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4D944F) : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: TextStyle(
                  color:
                      isActive
                          ? const Color(0xFF4D944F)
                          : const Color(0xFF888888),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
