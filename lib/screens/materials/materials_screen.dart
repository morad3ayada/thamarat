import 'package:flutter/material.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  int expandedIndex = -1;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> filteredMaterials = [];
  final Color primaryColor = const Color(0xFFDAF3D7); // Changed primary color

  final List<Map<String, String>> materials = [
    {'name': 'طماطم', 'type': 'صافي عدد', 'source': 'براد دمشق', 'quantity': '150 كيلو', 'price': '7500 دينار'},
    {'name': 'تفاح', 'type': 'خابط وزن', 'source': 'براد السويداء', 'quantity': '80 كيلو', 'price': '12000 دينار'},
    {'name': 'خيار', 'type': 'صافي وزن', 'source': 'براد درعا', 'quantity': '60 كيلو', 'price': '9000 دينار'},
    {'name': 'موز', 'type': 'خابط عدد', 'source': 'براد اللاذقية', 'quantity': '200 حبة', 'price': '15000 دينار'},
    {'name': 'باذنجان', 'type': 'صافي وزن', 'source': 'براد حمص', 'quantity': '45 كيلو', 'price': '6000 دينار'},
    {'name': 'فريز', 'type': 'خابط وزن', 'source': 'براد حلب', 'quantity': '30 كيلو', 'price': '18000 دينار'},
  ];

  @override
  void initState() {
    super.initState();
    filteredMaterials = List.from(materials);
    _searchController.addListener(_filterMaterials);
  }

  void _filterMaterials() {
    final query = _searchController.text;
    setState(() {
      filteredMaterials = materials
          .where((material) => material['name']!.contains(query))
          .toList();
      expandedIndex = -1;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              decoration: BoxDecoration(
                color: primaryColor, // Changed to solid color instead of with opacity
                borderRadius: const BorderRadius.only(
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
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color:  Color.fromARGB(255, 28, 98, 32), // Changed icon color to black for better visibility
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'المواد',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color:  Color.fromARGB(255, 28, 98, 32), // Changed text color to black
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${materials.length} مواد',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color:  Color.fromARGB(255, 28, 98, 32), // Changed text color to black
                    ),
                  ),
                ],
              ),
            ),

            // Search Box
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'ابحث عن المادة',
                  prefixIcon: Icon(Icons.search, color:  Color.fromARGB(255, 28, 98, 32)), // Changed icon color
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
              ),
            ),

            // Materials List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredMaterials.length,
                itemBuilder: (context, index) {
                  final item = filteredMaterials[index];
                  final isExpanded = expandedIndex == index;
                  final typeColor = item['type']!.contains('صافي') ? Color.fromARGB(255, 28, 98, 32) : Colors.orange;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedIndex = isExpanded ? -1 : index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: isExpanded
                                ? primaryColor.withOpacity(0.5) // Increased opacity
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 3))
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getMaterialIcon(item['name']!),
                                    color: Color.fromARGB(255, 28, 98, 32), // Changed icon color
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 28, 98, 32), // Changed text color
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: typeColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: typeColor.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      item['type']!,
                                      style: TextStyle(
                                        color: typeColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    size: 28,
                                    color: Color.fromARGB(255, 28, 98, 32), // Changed icon color
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFDAF3D7),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Type Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'النوع:',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 28, 98, 32), // Changed text color
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['type']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 28, 98, 32), // Changed text color
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.category_outlined,
                                      color: Color.fromARGB(255, 28, 98, 32), size: 22), // Changed icon color
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Source Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'البراد:',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 28, 98, 32), // Changed text color
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['source']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 28, 98, 32), // Changed text color
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.warehouse_outlined,
                                      color:  Color.fromARGB(255, 28, 98, 32), size: 22), // Changed icon color
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Quantity Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'الكمية:',
                                    style: TextStyle(
                                      color:  Color.fromARGB(255, 28, 98, 32), // Changed text color
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['quantity']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color:  Color.fromARGB(255, 28, 98, 32), // Changed text color
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.scale_outlined,
                                      color:  Color.fromARGB(255, 28, 98, 32), size: 22), // Changed icon color
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Price Card
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:  Color.fromARGB(255, 146, 162, 144).withOpacity(0.20),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                      item['price']!,
                                      style: TextStyle(
                                        color:  Color.fromARGB(255, 28, 98, 32), // Changed text color
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "السعر",
                                      style: TextStyle(
                                        color:  Color.fromARGB(255, 28, 98, 32).withOpacity(0.7), // Changed text color
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMaterialIcon(String materialName) {
    switch (materialName) {
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