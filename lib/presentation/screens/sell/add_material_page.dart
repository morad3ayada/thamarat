import 'package:flutter/material.dart';

class AddMaterialPage extends StatefulWidget {
  const AddMaterialPage({super.key});

  @override
  State<AddMaterialPage> createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  String sellType = 'عادي';
  TextEditingController commissionController = TextEditingController();
  TextEditingController traderCommissionController = TextEditingController();
  TextEditingController officeCommissionController = TextEditingController();
  TextEditingController brokerageController = TextEditingController();
  TextEditingController pieceRateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  double traderPieceRate = 30.0;
  double officePieceRate = 40.0;
  double workerPieceRate = 30.0;
  String selectedFridge = 'المنطقة الشمالية';
  int selectedFridgeIndex = 0;
  String? selectedMaterial;

  final List<String> fridges = [
    'المنطقة الشمالية',
    'المنطقة الشرقية',
    'المنطقة الغربية',
    'المنطقة الجنوبية',
    'المنطقة المركزية'
  ];

  final Map<String, List<String>> fridgeItems = {
    'المنطقة الشمالية': ['تفاح', 'كرز', 'خوخ'],
    'المنطقة الشرقية': ['تمر', 'مانجو', 'موز'],
    'المنطقة الغربية': ['عنب', 'فراولة', 'ليمون'],
    'المنطقة الجنوبية': ['رمان', 'تين', 'بطيخ'],
    'المنطقة المركزية': ['برتقال', 'يوسفي', 'جوافة'],
  };

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
                        'إضافة مادة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '0 مواد',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 28, 98, 32),
                    ),
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
                    // Search Box
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث عن اسم البراد',
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 28, 98, 32)),
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
                    const SizedBox(height: 16),
                    
                    // Fridge Chips
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fridges.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFridge = fridges[index];
                                  selectedFridgeIndex = index;
                                  selectedMaterial = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedFridgeIndex == index 
                                      ? Color.fromARGB(255, 28, 98, 32) 
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: selectedFridgeIndex == index 
                                        ? Color.fromARGB(255, 28, 98, 32) 
                                        : const Color(0xFFE0E0E0),
                                  ),
                                ),
                                child: Text(
                                  fridges[index],
                                  style: TextStyle(
                                    color: selectedFridgeIndex == index 
                                        ? Colors.white 
                                        : Color.fromARGB(255, 28, 98, 32),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Materials List
                    ...fridgeItems[selectedFridge]!.map((fruit) => 
                      _buildMaterialItemWithSelection(fruit, selectedFridge)
                    ),
                    
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 16),
                    
                    // Sell Type Section
                    const Text(
                      "نظام البيع",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSellTypeSelector(),
                    const SizedBox(height: 16),
                    
                    // Wholesale Options (if selected)
                    if (sellType == "بالكوترة") ...[
                      _buildWholesaleOptions(),
                      const SizedBox(height: 16),
                    ],
                    
                    // Input Fields
                    _buildInputFieldsSection(),
                    const SizedBox(height: 24),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color.fromARGB(255, 28, 98, 32)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "رجوع",
                              style: TextStyle(
                                color: Color.fromARGB(255, 28, 98, 32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 28, 98, 32),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "إضافة المادة",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
    );
  }

  Widget _buildMaterialItemWithSelection(String fruitName, String fridgeName) {
    bool isSelected = selectedMaterial == fruitName;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMaterial = isSelected ? null : fruitName;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDEF2E0) : Colors.white,
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
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Color.fromARGB(255, 28, 98, 32) : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: Color.fromARGB(255, 28, 98, 32),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  fruitName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
              ],
            ),
            Text(
              fridgeName,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellTypeSelector() {
    return Column(
      children: [
        _buildCustomRadioTile(
          value: "عادي",
          groupValue: sellType,
          onChanged: (val) => setState(() => sellType = val!),
          title: "البيع العادي",
        ),
        _buildCustomRadioTile(
          value: "بالكوترة",
          groupValue: sellType,
          onChanged: (val) => setState(() => sellType = val!),
          title: "البيع بالكوترة",
        ),
      ],
    );
  }

  Widget _buildCustomRadioTile({
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required String title,
  }) {
    final isSelected = value == groupValue;
    
    return InkWell(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color.fromARGB(255, 28, 98, 32) : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Color.fromARGB(255, 28, 98, 32),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Color.fromARGB(255, 28, 98, 32) : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFieldsSection() {
    return Column(
      children: [
        if (sellType == "بالكوترة")
          _buildBorderlessInputField("العدد", "العدد", quantityController),
        _buildBorderlessInputField("الوزن", "كيلو", weightController),
        const SizedBox(height: 16),
        _buildBorderlessInputField("السعر", "دينار", priceController),
      ],
    );
  }

  Widget _buildBorderlessInputField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 3))
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
  Widget _buildWholesaleOptions() {
    return Column(
      children: [
        _buildCommissionCard(
          title: "نسبة التاجر من العمولة",
          controller: traderCommissionController,
        ),
        const SizedBox(height: 8),
        _buildCommissionCard(
          title: "نسبة المكتب من العمولة",
          controller: officeCommissionController,
        ),
        const SizedBox(height: 8),
        _buildCommissionCard(
          title: "نسبة الدلالية",
          controller: brokerageController,
        ),
        const SizedBox(height: 8),
        _buildCommissionCard(
          title: "أجور القطعة",
          controller: pieceRateController,
        ),
        const SizedBox(height: 8),
        _buildRateCardWithSlider(
          title: "نسبة التاجر من أجور القطعة",
          value: traderPieceRate,
          onChanged: (val) => setState(() => traderPieceRate = val),
        ),
        const SizedBox(height: 8),
        _buildRateCardWithSlider(
          title: "نسبة العامل من أجور القطعة",
          value: workerPieceRate,
          onChanged: (val) => setState(() => workerPieceRate = val),
        ),
        const SizedBox(height: 8),
        _buildRateCardWithSlider(
          title: "نسبة المكتب من أجور القطعة",
          value: officePieceRate,
          onChanged: (val) => setState(() => officePieceRate = val),
        ),
      ],
    );
  }

  Widget _buildCommissionCard({
    required String title,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 28, 98, 32),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCardWithSlider({
    required String title,
    required double value,
    required Function(double) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 28, 98, 32),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${value.toInt()}%",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 28, 98, 32),
            ),
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 100,
            divisions: 100,
            activeColor: Color.fromARGB(255, 28, 98, 32),
            inactiveColor: const Color(0xFFCFE8D7),
          ),
        ],
      ),
    );
  }
}