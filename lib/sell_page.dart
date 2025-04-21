import 'package:flutter/material.dart';
import 'sell_details_page.dart';

class Customer {
  final String name;
  final String phone;
  Customer({required this.name, required this.phone});
}

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  int selectedTab = 0;
  String? selectedName;
  String? selectedPhone;

  List<Customer> customers = [];

  final List<String> sampleNames = [
    'أحمد',
    'محمد',
    'سارة',
    'فاطمة',
    'علي',
    'ليلى',
    'يوسف',
    'نور',
    'مريم',
    'عمر',
  ];

  final List<String> samplePhones = [
    '01012345678',
    '01123456789',
    '01234567890',
    '01598765432',
    '01099887766',
    '01111222333',
  ];

  @override
  void initState() {
    super.initState();
    generateRandomCustomers();
  }

  void generateRandomCustomers() {
    customers = List.generate(5, (index) {
      sampleNames.shuffle();
      samplePhones.shuffle();
      return Customer(name: sampleNames.first, phone: samplePhones.first);
    });
  }

  void _showAddCustomerDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "اسم الزبون",
                    style: TextStyle(color: Color(0xFF4D944F)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'الاسم'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "رقم الهاتف",
                    style: TextStyle(color: Color(0xFF4D944F)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(hintText: 'رقم الهاتف'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('رجوع'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4D944F),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedName = nameController.text;
                            selectedPhone = phoneController.text;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('إضافة زبون'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFDCEFD9),
          elevation: 0,
          leading: const Icon(Icons.arrow_forward, color: Colors.black),
          title: const Text('بيع مادة', style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildTab(0, '1', 'الوزن'),
                  _buildTab(1, '2', 'بيانات البيع'),
                  _buildTab(2, '3', 'إتمام العملية'),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4D944F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: _showAddCustomerDialog,
                    child: const Text(
                      'إضافة زبون',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: customers.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SellDetailsPage(
                                name: customer.name,
                                phone: customer.phone,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            customer.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                    if (selectedName != null && selectedPhone != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SellDetailsPage(
                                name: selectedName!,
                                phone: selectedPhone!,
                              ),
                        ),
                      );
                    }
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

  Widget _buildTab(int index, String number, String label) {
    bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF4D944F) : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(8),
          ),
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
                        isSelected
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
      ),
    );
  }
}
