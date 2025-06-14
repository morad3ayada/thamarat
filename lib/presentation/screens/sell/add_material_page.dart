import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/materials/materials_bloc.dart';
import '../../../logic/blocs/materials/materials_event.dart';
import '../../../logic/blocs/materials/materials_state.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../data/models/materials_model.dart';

class AddMaterialPage extends StatefulWidget {
  final String? customerName;
  final String? customerPhone;
  final int? saleProcessId;
  
  const AddMaterialPage({
    super.key,
    this.customerName,
    this.customerPhone,
    this.saleProcessId,
  });

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
  TextEditingController searchController = TextEditingController();
  double traderPieceRate = 30.0;
  double officePieceRate = 40.0;
  double workerPieceRate = 30.0;
  String selectedTruck = '';
  int selectedTruckIndex = -1;
  MaterialsModel? selectedMaterial;
  List<String> truckNames = [];
  Map<String, List<MaterialsModel>> truckMaterials = {};

  @override
  void initState() {
    super.initState();
    context.read<MaterialsBloc>().add(LoadMaterials());
    searchController.addListener(_filterMaterials);
  }

  @override
  void dispose() {
    commissionController.dispose();
    traderCommissionController.dispose();
    officeCommissionController.dispose();
    brokerageController.dispose();
    pieceRateController.dispose();
    weightController.dispose();
    quantityController.dispose();
    priceController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _filterMaterials() {
    final query = searchController.text;
    context.read<MaterialsBloc>().add(SearchMaterials(query));
  }

  void _updateTruckData(List<MaterialsModel> materials) {
    // Group materials by truck name
    truckMaterials.clear();
    truckNames.clear();
    
    for (var material in materials) {
      if (material.truckName != null && material.truckName!.isNotEmpty) {
        if (!truckMaterials.containsKey(material.truckName)) {
          truckMaterials[material.truckName!] = [];
          truckNames.add(material.truckName!);
        }
        truckMaterials[material.truckName!]!.add(material);
      }
    }
    
    // Sort truck names
    truckNames.sort();
    
    // Set default selected truck if none selected
    if (selectedTruck.isEmpty && truckNames.isNotEmpty) {
      selectedTruck = truckNames.first;
      selectedTruckIndex = 0;
    }
  }

  void _submitForm() {
    if (selectedMaterial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار مادة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (weightController.text.isEmpty && quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال الوزن أو الكمية'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال السعر'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Determine material type based on sell type and material type
    String materialType = selectedMaterial!.materialType;
    if (sellType == "بالكوترة") {
      if (materialType == "consignment") {
        materialType = "spoiledConsignment";
      } else if (materialType == "markup") {
        materialType = "spoiledMarkup";
      }
    }

    // Call the bloc to add material
    context.read<MaterialsBloc>().add(AddMaterialToSaleProcess(
      saleProcessId: widget.saleProcessId ?? 1,
      materialId: selectedMaterial!.id,
      materialType: materialType,
      quantity: selectedMaterial!.isQuantity ? double.tryParse(quantityController.text) : null,
      weight: !selectedMaterial!.isQuantity ? double.tryParse(weightController.text) : null,
      price: double.parse(priceController.text),
      order: 1,
      commissionPercentage: sellType == "بالكوترة" ? double.tryParse(commissionController.text) : null,
      traderCommissionPercentage: sellType == "بالكوترة" ? double.tryParse(traderCommissionController.text) : null,
      officeCommissionPercentage: sellType == "بالكوترة" ? double.tryParse(officeCommissionController.text) : null,
      brokerCommissionPercentage: sellType == "بالكوترة" ? double.tryParse(brokerageController.text) : null,
      pieceFees: sellType == "بالكوترة" ? double.tryParse(pieceRateController.text) : null,
      traderPiecePercentage: sellType == "بالكوترة" ? traderPieceRate : null,
      workerPiecePercentage: sellType == "بالكوترة" ? workerPieceRate : null,
      officePiecePercentage: sellType == "بالكوترة" ? officePieceRate : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: BlocConsumer<MaterialsBloc, MaterialsState>(
          listener: (context, state) {
            if (state is MaterialsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is MaterialAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إضافة المادة بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
              // تحديث بيانات البيع بعد إضافة المادة
              context.read<SellBloc>().add(LoadSellProcesses());
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is MaterialsLoaded) {
              _updateTruckData(state.materials);
            }
            
            return Column(
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
                      Text(
                        '${selectedMaterial != null ? 1 : 0} مواد',
                        style: const TextStyle(
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
                          controller: searchController,
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
                        
                        // Truck Chips
                        if (truckNames.isNotEmpty)
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: truckNames.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTruck = truckNames[index];
                                        selectedTruckIndex = index;
                                        selectedMaterial = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: selectedTruckIndex == index 
                                            ? Color.fromARGB(255, 28, 98, 32) 
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: selectedTruckIndex == index 
                                              ? Color.fromARGB(255, 28, 98, 32) 
                                              : const Color(0xFFE0E0E0),
                                        ),
                                      ),
                                      child: Text(
                                        truckNames[index],
                                        style: TextStyle(
                                          color: selectedTruckIndex == index 
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
                        if (selectedTruck.isNotEmpty && truckMaterials.containsKey(selectedTruck))
                          ...truckMaterials[selectedTruck]!.map((material) => 
                            _buildMaterialItemWithSelection(material, selectedTruck)
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
                                onPressed: _submitForm,
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildMaterialItemWithSelection(MaterialsModel material, String truckName) {
    bool isSelected = selectedMaterial?.id == material.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMaterial = isSelected ? null : material;
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
            Expanded(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          material.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 28, 98, 32),
                          ),
                        ),
                        Text(
                          material.displayType,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              truckName,
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
        if (sellType == "بالكوترة" && selectedMaterial?.isQuantity == true)
          _buildBorderlessInputField("العدد", "العدد", quantityController),
        if (selectedMaterial?.isQuantity == true)
          _buildBorderlessInputField("الكمية", "قطعة", quantityController),
        if (selectedMaterial?.isQuantity == false)
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
            keyboardType: TextInputType.number,
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
              keyboardType: TextInputType.number,
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