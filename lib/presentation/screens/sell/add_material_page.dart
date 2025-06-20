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
  String? selectedMaterialUniqueId;
  List<String> truckNames = [];
  Map<String, List<MaterialsModel>> truckMaterials = {};

  // دالة لتحويل الأرقام العربية إلى إنجليزية
  String _convertArabicToEnglish(String input) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    String result = input;
    for (int i = 0; i < arabic.length; i++) {
      result = result.replaceAll(arabic[i], english[i]);
    }
    return result;
  }

  // دالة للتحقق من صحة الرقم وتحويله
  String? _validateAndConvertNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    String converted = _convertArabicToEnglish(value.trim());
    if (double.tryParse(converted) != null) {
      return converted;
    }
    return null;
  }

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

  void _handleAddMaterial() {
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

    String materialType = selectedMaterial!.materialType;
    double? quantity = quantityController.text.isNotEmpty
        ? double.tryParse(_validateAndConvertNumber(quantityController.text) ?? '')
        : null;
    double? weight = weightController.text.isNotEmpty
        ? double.tryParse(_validateAndConvertNumber(weightController.text) ?? '')
        : null;
    double price = double.parse(_validateAndConvertNumber(priceController.text) ?? '0');
    double? commissionPercentage;
    double? traderCommissionPercentage;
    double? officeCommissionPercentage;
    double? brokerCommissionPercentage;
    double? pieceFees;
    double? traderPiecePercentage;
    double? workerPiecePercentage;
    double? officePiecePercentage;
    bool? isRate;
    int order = 1;

    if (sellType == "بالكوترة") {
      if (materialType == "markup" && selectedMaterial!.isQuantity) {
        // خابط عدد
        if (commissionController.text.isEmpty || traderCommissionController.text.isEmpty || officeCommissionController.text.isEmpty || brokerageController.text.isEmpty || pieceRateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يرجى تعبئة جميع الحقول المطلوبة للكوترة (خابط عدد)'), backgroundColor: Colors.red),
          );
          return;
        }
        commissionPercentage = double.tryParse(_validateAndConvertNumber(commissionController.text) ?? '');
        traderCommissionPercentage = double.tryParse(_validateAndConvertNumber(traderCommissionController.text) ?? '');
        officeCommissionPercentage = double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '');
        brokerCommissionPercentage = double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '');
        pieceFees = double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '');
        traderPiecePercentage = traderPieceRate;
        workerPiecePercentage = workerPieceRate;
        officePiecePercentage = officePieceRate;
        materialType = "spoiledMarkup";
      } else if (materialType == "markup" && !selectedMaterial!.isQuantity) {
        // خابط وزن
        if (commissionController.text.isEmpty || traderCommissionController.text.isEmpty || officeCommissionController.text.isEmpty || brokerageController.text.isEmpty || pieceRateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يرجى تعبئة جميع الحقول المطلوبة للكوترة (خابط وزن)'), backgroundColor: Colors.red),
          );
          return;
        }
        commissionPercentage = double.tryParse(_validateAndConvertNumber(commissionController.text) ?? '');
        traderCommissionPercentage = double.tryParse(_validateAndConvertNumber(traderCommissionController.text) ?? '');
        officeCommissionPercentage = double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '');
        brokerCommissionPercentage = double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '');
        pieceFees = double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '');
        workerPiecePercentage = workerPieceRate;
        materialType = "spoiledMarkup";
      } else if (materialType == "consignment") {
        // الصافي (عدد أو وزن أو الاثنين)
        if (commissionController.text.isEmpty || pieceRateController.text.isEmpty || brokerageController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يرجى تعبئة جميع الحقول المطلوبة للكوترة (صافي)'), backgroundColor: Colors.red),
          );
          return;
        }
        isRate = false;
        commissionPercentage = double.tryParse(_validateAndConvertNumber(commissionController.text) ?? '');
        pieceFees = double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '');
        workerPiecePercentage = workerPieceRate;
        brokerCommissionPercentage = double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '');
        materialType = "spoiledConsignment";
      }
    } else {
      // البيع العادي
      if (materialType == "markup" && selectedMaterial!.isQuantity) {
        commissionPercentage = commissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(commissionController.text) ?? '') : null;
        traderCommissionPercentage = traderCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(traderCommissionController.text) ?? '') : null;
        officeCommissionPercentage = officeCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '') : null;
        brokerCommissionPercentage = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
        pieceFees = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
        traderPiecePercentage = traderPieceRate;
        workerPiecePercentage = workerPieceRate;
        officePiecePercentage = officePieceRate;
      } else if (materialType == "markup" && !selectedMaterial!.isQuantity) {
        commissionPercentage = commissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(commissionController.text) ?? '') : null;
        traderCommissionPercentage = traderCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(traderCommissionController.text) ?? '') : null;
        officeCommissionPercentage = officeCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '') : null;
        pieceFees = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
        workerPiecePercentage = workerPieceRate;
        brokerCommissionPercentage = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
      } else if (materialType == "consignment") {
        isRate = false;
        commissionPercentage = commissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(commissionController.text) ?? '') : null;
        pieceFees = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
        workerPiecePercentage = workerPieceRate;
        brokerCommissionPercentage = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
      }
    }

    context.read<MaterialsBloc>().add(
      AddMaterialToSaleProcess(
        saleProcessId: widget.saleProcessId ?? 1,
        materialId: selectedMaterial!.id,
        materialType: materialType,
        quantity: quantity,
        weight: weight,
        price: price,
        order: order,
        commissionPercentage: commissionPercentage,
        traderCommissionPercentage: traderCommissionPercentage,
        officeCommissionPercentage: officeCommissionPercentage,
        brokerCommissionPercentage: brokerCommissionPercentage,
        pieceFees: pieceFees,
        traderPiecePercentage: traderPiecePercentage,
        workerPiecePercentage: workerPiecePercentage,
        officePiecePercentage: officePiecePercentage,
      ),
    );
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
                            _buildCustomRadioTile(
                              value: _generateUniqueId(material),
                              groupValue: selectedMaterialUniqueId ?? '',
                              onChanged: (val) {
                                setState(() {
                                  selectedMaterial = material;
                                  selectedMaterialUniqueId = _generateUniqueId(material);
                                });
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    material.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    material.displayType,
                                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            )
                          ),
                        
                        const SizedBox(height: 20),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 16),
                        
                        // نظام البيع
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
                        
                        // خيارات الكوترة
                        if (sellType == "بالكوترة") ...[
                          _buildWholesaleOptions(),
                          const SizedBox(height: 16),
                        ],
                        
                        // الحقول الأساسية
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
                                onPressed: _handleAddMaterial,
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

  Widget _buildCustomRadioTile({
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required Widget title,
  }) {
    final isSelected = value == groupValue;
    
    return InkWell(
      onTap: () => onChanged(value),
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
            title,
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "البيع العادي",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        _buildCustomRadioTile(
          value: "بالكوترة",
          groupValue: sellType,
          onChanged: (val) => setState(() => sellType = val!),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "البيع بالكوترة",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputFieldsSection() {
    final String? type = selectedMaterial?.materialType;
    final bool? isQty = selectedMaterial?.isQuantity;
    return Column(
      children: [
        // خابط عدد: وزن موجود، عدد موجود
        if (type == 'markup' && isQty == true) ...[
          _buildBorderlessInputField("الوزن", "كيلو", weightController),
          _buildBorderlessInputField("العدد", "عدد", quantityController),
        ]
        // خابط وزن: وزن موجود فقط
        else if (type == 'markup' && isQty == false) ...[
          _buildBorderlessInputField("الوزن", "كيلو", weightController),
        ]
        // صافي عدد: عدد موجود فقط
        else if (type == 'consignment' && isQty == true) ...[
          _buildBorderlessInputField("العدد", "عدد", quantityController),
        ]
        // صافي وزن: وزن موجود، عدد موجود
        else if (type == 'consignment' && isQty == false) ...[
          _buildBorderlessInputField("الوزن", "كيلو", weightController),
          _buildBorderlessInputField("العدد", "عدد", quantityController),
        ]
        ,
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
            onChanged: (value) {
              // تحويل الأرقام العربية إلى إنجليزية أثناء الكتابة
              final converted = _validateAndConvertNumber(value);
              if (converted != null && converted != value) {
                controller.text = converted;
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: converted.length),
                );
              }
            },
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
    final String? type = selectedMaterial?.materialType;
    final bool? isQty = selectedMaterial?.isQuantity;
    List<Widget> widgets = [];
    if (sellType == "بالكوترة") {
      if (type == "markup" && isQty == true) {
        // خابط عدد
        widgets.addAll([
          _buildCommissionCard(title: "نسبة العمولة", controller: commissionController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "نسبة التاجر من العمولة", controller: traderCommissionController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "نسبة المكتب من العمولة", controller: officeCommissionController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "نسبة الدلالية", controller: brokerageController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "أجور القطعة", controller: pieceRateController),
          const SizedBox(height: 8),
          _buildRateCardWithSlider(title: "نسبة التاجر من أجور القطعة", value: traderPieceRate, onChanged: (val) => setState(() => traderPieceRate = val)),
          const SizedBox(height: 8),
          _buildRateCardWithSlider(title: "نسبة العامل من أجور القطعة", value: workerPieceRate, onChanged: (val) => setState(() => workerPieceRate = val)),
          const SizedBox(height: 8),
          _buildRateCardWithSlider(title: "نسبة المكتب من أجور القطعة", value: officePieceRate, onChanged: (val) => setState(() => officePieceRate = val)),
        ]);
      } else if (type == "markup" && isQty == false) {
        // خابط وزن
        widgets.addAll([
          _buildCommissionCard(title: "نسبة العمولة", controller: commissionController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "نسبة التاجر من العمولة", controller: traderCommissionController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "نسبة المكتب من العمولة", controller: officeCommissionController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "نسبة الدلالية", controller: brokerageController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "أجور القطعة", controller: pieceRateController),
          const SizedBox(height: 8),
          _buildRateCardWithSlider(title: "نسبة العامل من أجور القطعة", value: workerPieceRate, onChanged: (val) => setState(() => workerPieceRate = val)),
        ]);
      } else if (type == "consignment") {
        // الصافي عدد أو وزن
        widgets.addAll([
          _buildCommissionCard(title: "عمولة المكتب (%)", controller: commissionController),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "أجور النقل", controller: pieceRateController),
          const SizedBox(height: 8),
          _buildRateCardWithSlider(title: "نسبة العامل من أجور النقل", value: workerPieceRate, onChanged: (val) => setState(() => workerPieceRate = val)),
          const SizedBox(height: 8),
          _buildCommissionCard(title: "نسبة الدلالية", controller: brokerageController),
        ]);
      }
    } else {
      // البيع العادي (ابقِ الديزاين كما هو سابقًا)
      if (type == "markup" && isQty == true) {
        widgets.addAll([
          _buildBorderlessInputField("الوزن", "كيلو", weightController),
          _buildBorderlessInputField("العدد", "عدد", quantityController),
        ]);
      } else if (type == "markup" && isQty == false) {
        widgets.addAll([
          _buildBorderlessInputField("الوزن", "كيلو", weightController),
        ]);
      } else if (type == "consignment" && isQty == true) {
        widgets.addAll([
          _buildBorderlessInputField("العدد", "عدد", quantityController),
        ]);
      } else if (type == "consignment" && isQty == false) {
        widgets.addAll([
          _buildBorderlessInputField("الوزن", "كيلو", weightController),
          _buildBorderlessInputField("العدد", "عدد", quantityController),
        ]);
      }
    }
    return Column(children: widgets);
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

  // Helper method to generate unique ID for a material
  String _generateUniqueId(MaterialsModel material) {
    String prefix = material.materialType == 'consignment' ? 'c' : 'm';
    return '$prefix${material.id}';
  }

  // Helper method to check if a material is already selected
  bool _isMaterialSelected(MaterialsModel material) {
    if (selectedMaterialUniqueId == null) return false;
    return selectedMaterialUniqueId == _generateUniqueId(material);
  }
}