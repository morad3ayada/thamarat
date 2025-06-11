import 'package:flutter/material.dart';

class VendorDetailsPage extends StatelessWidget {
  final String vendorName;

  const VendorDetailsPage({super.key, required this.vendorName});

  List<Map<String, String>> getVendorData(String vendor) {
    return [
      {
        'item': 'تفاح احمر',
        'weight': '40 كيلو',
        'price': '18000 دينار',
        'storage': 'براد الشمال',
        'type': 'صافي عدد',
      },
      {
        'item': 'خيار بلدي',
        'weight': '25 كيلو',
        'price': '9000 دينار',
        'storage': 'براد الشرق',
        'type': 'خابط عدد',
      },
      {
        'item': 'برتقال عصير',
        'weight': '30 كيلو',
        'price': '12000 دينار',
        'storage': 'براد الجنوب',
        'type': 'صافي وزن',
      },
      {
        'item': 'موز مستورد (حبة)',
        'weight': '120 حبة',
        'price': '16000 دينار',
        'storage': 'براد الاستيراد',
        'type': 'صافي عدد',
      },
      {
        'item': 'طماطم بلدية',
        'weight': '35 كيلو',
        'price': '7000 دينار',
        'storage': 'براد المدينة',
        'type': 'خابط وزن',
      },
      {
        'item': 'ليمون اصفر (حبة)',
        'weight': '80 حبة',
        'price': '9500 دينار',
        'storage': 'براد الفواكه',
        'type': 'خابط عدد',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final vendorData = getVendorData(vendorName);

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
                      color: Color.fromARGB(255, 28, 98, 32),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    vendorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 28, 98, 32),
                    ),
                  ),
                ],
              ),
            ),

            // Vendor Info & List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Vendor info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 28, 98, 32),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "اخر زيارة: 30/04/2025",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.warehouse_outlined,
                                  color: Color.fromARGB(255, 28, 98, 32), size: 22),
                              const SizedBox(width: 4),
                              const Text(
                                '5',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 28, 98, 32),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Items list header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'المواد المضافة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          Text(
                            '${vendorData.length} صنف',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Items list
                    Expanded(
                      child: ListView.builder(
                        itemCount: vendorData.length,
                        itemBuilder: (context, index) {
                          final data = vendorData[index];
                          return buildItemCard(data);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemCard(Map<String, String> data) {
    // Determine color based on type
    Color typeColor = Colors.grey;
    if (data['type']!.contains('صافي')) {
      typeColor = Color.fromARGB(255, 28, 98, 32);
    } else if (data['type']!.contains('خابط')) {
      typeColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['item']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 28, 98, 32),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: typeColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  data['type']!,
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warehouse_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    data['storage']!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.scale_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    data['weight']!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  data['price']!,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 28, 98, 32),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "السعر",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}