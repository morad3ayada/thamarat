import 'package:flutter/material.dart';

class AddMaterialPage extends StatefulWidget {
  const AddMaterialPage({super.key});

  @override
  State<AddMaterialPage> createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  String sellType = 'عادي';

  @override
  Widget build(BuildContext context) {
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
          title: const Text(
            'إضافة مادة',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن اسم المادة',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMaterialItem("تفاح", "مزارع الفرات"),
              _buildMaterialItem("طماطم", "مزارع الوطن"),
              _buildMaterialItem("موز", "مزارع الجزيرة"),
              _buildMaterialItem("خيار", "مزارع الخير"),
              _buildMaterialItem("برتقال", "مزارع الشمس"),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              const Text("نظام البيع", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              _buildSellTypeSelector(),
              const SizedBox(height: 16),
              _buildTextField("الوزن", "كيلو"),
              const SizedBox(height: 12),
              if (sellType == "بالكرتونة") _buildTextField("العدد", "العدد"),
              const SizedBox(height: 12),
              _buildTextField("السعر", "دينار"),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4D944F)),
                      ),
                      child: const Text(
                        "رجوع",
                        style: TextStyle(color: Color(0xFF4D944F)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // logic to save
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D944F),
                      ),
                      child: const Text("إضافة المادة"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialItem(String materialName, String sellerName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(materialName)),
          Expanded(child: Text(sellerName)),
          const Icon(Icons.check_circle_outline, color: Color(0xFF4D944F)),
        ],
      ),
    );
  }

  Widget _buildSellTypeSelector() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDCEFD9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: RadioListTile<String>(
            value: "عادي",
            groupValue: sellType,
            onChanged: (val) {
              setState(() {
                sellType = val!;
              });
            },
            title: const Text("البيع العادي"),
            activeColor: const Color(0xFF4D944F),
          ),
        ),
        RadioListTile<String>(
          value: "بالكرتونة",
          groupValue: sellType,
          onChanged: (val) {
            setState(() {
              sellType = val!;
            });
          },
          title: const Text("البيع بالكرتونة"),
          activeColor: const Color(0xFF4D944F),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
