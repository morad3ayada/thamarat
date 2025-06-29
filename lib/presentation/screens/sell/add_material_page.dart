import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/materials/materials_bloc.dart';
import '../../../logic/blocs/materials/materials_event.dart';
import '../../../logic/blocs/materials/materials_state.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../data/models/materials_model.dart';
import 'package:flutter/services.dart';

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
  TextEditingController totalCommissionController = TextEditingController();
  TextEditingController traderCommissionController = TextEditingController();
  TextEditingController officeCommissionController = TextEditingController();
  TextEditingController brokerageController = TextEditingController();
  TextEditingController pieceRateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController workerPieceRateController = TextEditingController();
  TextEditingController traderPieceRateController = TextEditingController();
  double traderCommissionSlider = 0.0;
  double officeCommissionSlider = 0.0;
  double traderPieceRate = 30.0;
  double officePieceRate = 40.0;
  double workerPieceRate = 30.0;
  String officeCommissionType = 'دينار';
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
    if (value == null || value.isEmpty) return null;
    String converted = _convertArabicToEnglish(value);
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
    
    traderCommissionController.addListener(_validateCommissionSum);
    officeCommissionController.addListener(_validateCommissionSum);
    brokerageController.addListener(_validateCommissionSum);
    totalCommissionController.addListener(_updateCommissionFields);
    totalCommissionController.addListener(_validateWeightMarkupCommissions);
    totalCommissionController.addListener(_updateCommissionSliders);
    pieceRateController.addListener(_validateWeightMarkupWorkerBroker);
    workerPieceRateController.addListener(_validateWeightMarkupWorkerBroker);
  }

  @override
  void dispose() {
    totalCommissionController.dispose();
    traderCommissionController.dispose();
    officeCommissionController.dispose();
    brokerageController.dispose();
    pieceRateController.dispose();
    weightController.dispose();
    quantityController.dispose();
    priceController.dispose();
    searchController.dispose();
    workerPieceRateController.dispose();
    traderPieceRateController.dispose();
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
      return;
    }

    if (weightController.text.isEmpty && quantityController.text.isEmpty) {
      return;
    }

    if (priceController.text.isEmpty) {
      return;
    }

    // تسجيل البيانات المدخلة
    print('=== ADDING MATERIAL DEBUG ===');
    print('Material Name: ${selectedMaterial!.name}');
    print('Material ID: ${selectedMaterial!.id}');
    print('Material Type: ${selectedMaterial!.materialType}');
    print('Is Quantity: ${selectedMaterial!.isQuantity}');
    print('Sell Type: $sellType');
    print('Price: ${priceController.text}');
    print('Quantity: ${quantityController.text}');
    print('Weight: ${weightController.text}');
    print('Office Commission Type: $officeCommissionType');
    print('Office Commission: ${officeCommissionController.text}');
    print('Total Commission: ${totalCommissionController.text}');
    print('Trader Commission: ${traderCommissionController.text}');
    print('Brokerage: ${brokerageController.text}');
    print('Piece Rate: ${pieceRateController.text}');
    print('Worker Piece Rate: ${workerPieceRateController.text}');
    print('Selected Material Unique ID: $selectedMaterialUniqueId');

    // تحقق من شروط خابط عدد (markup + isQuantity == true) ونوع البيع بالكوترة
    if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == true && sellType == 'بالكوترة') {
      int totalCommission = int.tryParse(totalCommissionController.text) ?? 0;
      int traderCommission = int.tryParse(traderCommissionController.text) ?? 0;
      int officeCommission = int.tryParse(officeCommissionController.text) ?? 0;
      int brokerageCommission = int.tryParse(brokerageController.text) ?? 0;
      int sumCommission = traderCommission + officeCommission + brokerageCommission;
      int sumPiece = traderPieceRate.toInt() + officePieceRate.toInt() + workerPieceRate.toInt();
      List<String> errors = [];
      if (sumCommission != totalCommission) {
        errors.add('يجب أن يكون مجموع نسب التاجر والمكتب والدلالية مساويًا لنسبة العمولة');
      }
      if (sumPiece != 100) {
        errors.add('يجب أن يكون مجموع نسب أجور القطعة (تاجر، مكتب، عامل) يساوي 100');
      }
      if (errors.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...errors.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      e,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 28, 98, 32),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 28, 98, 32),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'موافق',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        return;
      }
    }

    // تحقق من شروط خابط وزن (markup + isQuantity == false)
    if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == false) {
      double workerPercentage = workerPieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(workerPieceRateController.text) ?? '') ?? 0 : 0;
      double brokerPercentage = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') ?? 0 : 0;
      double pieceFeesPerKilo = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') ?? 0 : 0;
      
      double sumPercentages = workerPercentage + brokerPercentage;
      
      print('خابط وزن - التحقق من الأجور:');
      print('نسبة العامل: $workerPercentage');
      print('نسبة الدلالية: $brokerPercentage');
      print('المجموع: $sumPercentages');
      print('أجور العمل لكل كيلو: $pieceFeesPerKilo');
      print('التحقق: ${sumPercentages == pieceFeesPerKilo ? 'صحيح' : 'خطأ'}');
      
      List<String> errors = [];
      if (sumPercentages != pieceFeesPerKilo) {
        errors.add('يجب أن يكون مجموع نسبة العامل ونسبة الدلالية مساويًا لأجور العمل لكل كيلو');
        errors.add('نسبة العامل: $workerPercentage');
        errors.add('نسبة الدلالية: $brokerPercentage');
        errors.add('المجموع: $sumPercentages');
        errors.add('أجور العمل لكل كيلو: $pieceFeesPerKilo');
      }
      
      if (errors.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'خطأ في حساب الأجور',
                    style: TextStyle(
                      color: Color.fromARGB(255, 28, 98, 32),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...errors.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      e,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 28, 98, 32),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 28, 98, 32),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'موافق',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        return;
      }
    }

    // تحقق من شروط صافي (consignment) - عدد ووزن
    if (selectedMaterial?.materialType == 'consignment') {
      double workerPercentage = workerPieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(workerPieceRateController.text) ?? '') ?? 0 : 0;
      double brokerPercentage = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') ?? 0 : 0;
      double pieceFees = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') ?? 0 : 0;
      
      double sumPercentages = workerPercentage + brokerPercentage;
      String unitType = selectedMaterial!.isQuantity ? 'قطعة' : 'كيلو';
      
      print('صافي ${selectedMaterial!.isQuantity ? 'عدد' : 'وزن'} - التحقق من الأجور:');
      print('نسبة العامل: $workerPercentage');
      print('نسبة الدلالية: $brokerPercentage');
      print('المجموع: $sumPercentages');
      print('أجور العمل لكل $unitType: $pieceFees');
      print('التحقق: ${sumPercentages == pieceFees ? 'صحيح' : 'خطأ'}');
      
      List<String> errors = [];
      if (sumPercentages != pieceFees) {
        errors.add('يجب أن يكون مجموع نسبة العامل ونسبة الدلالية مساويًا لأجور العمل لكل $unitType');
        errors.add('نسبة العامل: $workerPercentage');
        errors.add('نسبة الدلالية: $brokerPercentage');
        errors.add('المجموع: $sumPercentages');
        errors.add('أجور العمل لكل $unitType: $pieceFees');
      }
      
      if (errors.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'خطأ في حساب الأجور - صافي ${selectedMaterial!.isQuantity ? 'عدد' : 'وزن'}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 28, 98, 32),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...errors.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      e,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 28, 98, 32),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 28, 98, 32),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'موافق',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        return;
      }
    }

    String materialType = selectedMaterial!.materialType;
    double? quantity = quantityController.text.isNotEmpty
        ? double.tryParse(_validateAndConvertNumber(quantityController.text) ?? '')
        : null;
    double? weight = weightController.text.isNotEmpty
        ? double.tryParse(_validateAndConvertNumber(weightController.text) ?? '')
        : null;
    double price = double.parse(_validateAndConvertNumber(priceController.text) ?? '0');

    // متغيرات العمولة وأجور النقل
    double? commissionPercentage;
    double? traderCommissionPercentage;
    double? officeCommissionPercentage;
    double? brokerCommissionPercentage;
    double? pieceFees;
    double? traderPiecePercentage;
    double? workerPiecePercentage;
    double? officePiecePercentage;
    double? brokerPiecePercentage;
    bool? isRate;

    // منطق البيع بالكوترة
    if (sellType == "بالكوترة") {
      if (materialType == "consignment") {
        // صافي وزن أو عدد - إرسال كـ spoiledConsignment
        isRate = officeCommissionType == 'مئوية';
        
        // حساب العمولة المئوية للصافي
        if (officeCommissionType == 'مئوية') {
          // إذا كانت العمولة مئوية، نحسبها من السعر
          commissionPercentage = officeCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '') : null;
          if (commissionPercentage != null && price > 0) {
            // حساب قيمة العمولة من النسبة المئوية
            double commissionValue = (price * commissionPercentage!) / 100;
            print('صافي - عمولة مئوية: $commissionPercentage% = $commissionValue من السعر $price');
          }
        } else {
          // إذا كانت العمولة ثابتة
          commissionPercentage = officeCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '') : null;
        }
        
        pieceFees = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
        workerPiecePercentage = workerPieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(workerPieceRateController.text) ?? '') : null;
        brokerPiecePercentage = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
        
        // إرسال فقط الحقول المطلوبة للصافي كوترة
        context.read<SellBloc>().add(
          AddMaterialToSaleProcess(
            saleProcessId: widget.saleProcessId ?? 1,
            materialId: selectedMaterial!.id,
            materialType: "spoiledConsignment", // تغيير نوع المادة للكوترة
            quantity: quantity,
            weight: weight,
            price: price,
            isRate: isRate,
            commissionPercentage: commissionPercentage,
            pieceFees: pieceFees,
            workerPiecePercentage: workerPiecePercentage,
            brokerPiecePercentage: brokerPiecePercentage,
            materialUniqueId: selectedMaterialUniqueId,
          ),
        );
        return;
      } else if (materialType == "markup" && selectedMaterial!.isQuantity) {
        // خابط عدد - إرسال كـ spoiledMarkup
        commissionPercentage = totalCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(totalCommissionController.text) ?? '') : null;
        traderCommissionPercentage = traderCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(traderCommissionController.text) ?? '') : null;
        officeCommissionPercentage = officeCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '') : null;
        brokerCommissionPercentage = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
        
        // حساب العمولة المئوية للخابط عدد
        if (commissionPercentage != null && price > 0) {
          double commissionValue = (price * commissionPercentage!) / 100;
          print('خابط عدد - عمولة مئوية: $commissionPercentage% = $commissionValue من السعر $price');
        }
        
        pieceFees = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
        traderPiecePercentage = traderPieceRate;
        workerPiecePercentage = workerPieceRate;
        officePiecePercentage = officePieceRate;
        context.read<SellBloc>().add(
          AddMaterialToSaleProcess(
            saleProcessId: widget.saleProcessId ?? 1,
            materialId: selectedMaterial!.id,
            materialType: "spoiledMarkup", // تغيير نوع المادة للكوترة
            quantity: quantity,
            weight: weight,
            price: price,
            commissionPercentage: commissionPercentage,
            traderCommissionPercentage: traderCommissionPercentage,
            officeCommissionPercentage: officeCommissionPercentage,
            brokerCommissionPercentage: brokerCommissionPercentage,
            pieceFees: pieceFees,
            traderPiecePercentage: traderPiecePercentage,
            workerPiecePercentage: workerPiecePercentage,
            officePiecePercentage: officePiecePercentage,
            materialUniqueId: selectedMaterialUniqueId,
          ),
        );
        return;
      } else if (materialType == "markup" && !selectedMaterial!.isQuantity) {
        // خابط وزن - إرسال كـ spoiledMarkup
        commissionPercentage = totalCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(totalCommissionController.text) ?? '') : null;
        traderCommissionPercentage = traderCommissionSlider;
        officeCommissionPercentage = officeCommissionSlider;
        
        // حساب العمولة المئوية للخابط وزن
        if (commissionPercentage != null && price > 0) {
          double commissionValue = (price * commissionPercentage!) / 100;
          print('خابط وزن - عمولة مئوية: $commissionPercentage% = $commissionValue من السعر $price');
        }
        
        pieceFees = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
        workerPiecePercentage = workerPieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(workerPieceRateController.text) ?? '') : null;
        brokerPiecePercentage = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
        context.read<SellBloc>().add(
          AddMaterialToSaleProcess(
            saleProcessId: widget.saleProcessId ?? 1,
            materialId: selectedMaterial!.id,
            materialType: "spoiledMarkup", // تغيير نوع المادة للكوترة
            quantity: quantity,
            weight: weight,
            price: price,
            commissionPercentage: commissionPercentage,
            traderCommissionPercentage: traderCommissionPercentage,
            officeCommissionPercentage: officeCommissionPercentage,
            pieceFees: pieceFees,
            workerPiecePercentage: workerPiecePercentage,
            brokerPiecePercentage: brokerPiecePercentage,
            materialUniqueId: selectedMaterialUniqueId,
          ),
        );
        return;
      }
    }

    // البيع العادي (الكود القديم)
    // ... الكود السابق كما هو ...
    double? commissionPercentageOld;
    double? traderCommissionPercentageOld;
    double? officeCommissionPercentageOld;
    double? brokerCommissionPercentageOld;
    double? pieceFeesOld;
    double? traderPiecePercentageOld;
    double? workerPiecePercentageOld;
    double? officePiecePercentageOld;
    bool? isRateOld;

    if (materialType == "markup" && selectedMaterial!.isQuantity) {
      commissionPercentageOld = double.tryParse(totalCommissionController.text) ?? 0;
      traderCommissionPercentageOld = traderCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(traderCommissionController.text) ?? '') : null;
      officeCommissionPercentageOld = officeCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '') : null;
      brokerCommissionPercentageOld = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
      
      // حساب العمولة المئوية للبيع العادي - خابط عدد
      if (commissionPercentageOld != null && commissionPercentageOld! > 0 && price > 0) {
        double commissionValue = (price * commissionPercentageOld!) / 100;
        print('بيع عادي - خابط عدد - عمولة مئوية: $commissionPercentageOld% = $commissionValue من السعر $price');
      }
      
      pieceFeesOld = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
      traderPiecePercentageOld = traderPieceRate;
      workerPiecePercentageOld = workerPieceRate;
      officePiecePercentageOld = officePieceRate;
    } else if (materialType == "markup" && !selectedMaterial!.isQuantity) {
      commissionPercentageOld = double.tryParse(totalCommissionController.text) ?? 0;
      traderCommissionPercentageOld = traderCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(traderCommissionController.text) ?? '') : null;
      officeCommissionPercentageOld = officeCommissionController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(officeCommissionController.text) ?? '') : null;
      
      // حساب العمولة المئوية للبيع العادي - خابط وزن
      if (commissionPercentageOld != null && commissionPercentageOld! > 0 && price > 0) {
        double commissionValue = (price * commissionPercentageOld!) / 100;
        print('بيع عادي - خابط وزن - عمولة مئوية: $commissionPercentageOld% = $commissionValue من السعر $price');
      }
      
      pieceFeesOld = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
      workerPiecePercentageOld = workerPieceRate;
      brokerCommissionPercentageOld = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
    } else if (materialType == "consignment") {
      isRateOld = false;
      commissionPercentageOld = double.tryParse(totalCommissionController.text) ?? 0;
      
      // حساب العمولة المئوية للبيع العادي - صافي
      if (commissionPercentageOld != null && commissionPercentageOld! > 0 && price > 0) {
        double commissionValue = (price * commissionPercentageOld!) / 100;
        print('بيع عادي - صافي - عمولة مئوية: $commissionPercentageOld% = $commissionValue من السعر $price');
      }
      
      pieceFeesOld = pieceRateController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(pieceRateController.text) ?? '') : null;
      workerPiecePercentageOld = workerPieceRate;
      brokerCommissionPercentageOld = brokerageController.text.isNotEmpty ? double.tryParse(_validateAndConvertNumber(brokerageController.text) ?? '') : null;
    }

    print('Sending normal material - ID: ${selectedMaterial!.id}, Type: $materialType');
    print('=== END ADDING MATERIAL DEBUG ===');

    context.read<SellBloc>().add(
      AddMaterialToSaleProcess(
        saleProcessId: widget.saleProcessId ?? 1,
        materialId: selectedMaterial!.id,
        materialType: materialType,
        quantity: quantity,
        weight: weight,
        price: price,
        commissionPercentage: commissionPercentageOld,
        traderCommissionPercentage: traderCommissionPercentageOld,
        officeCommissionPercentage: officeCommissionPercentageOld,
        brokerCommissionPercentage: brokerCommissionPercentageOld,
        pieceFees: pieceFeesOld,
        traderPiecePercentage: traderPiecePercentageOld,
        workerPiecePercentage: workerPiecePercentageOld,
        officePiecePercentage: officePiecePercentageOld,
        isRate: isRateOld,
        materialUniqueId: selectedMaterialUniqueId,
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
              // No need to show snackbar here
            }
          },
          builder: (context, state) {
            if (state is MaterialsLoaded) {
              _updateTruckData(state.materials);
            }
            
            return BlocListener<SellBloc, SellState>(
              listener: (context, sellState) {
                if (sellState is MaterialAdded) {
                  // تحديث بيانات البيع بعد إضافة المادة
                  if (widget.saleProcessId != null) {
                    context.read<SellBloc>().add(LoadSellDetails(widget.saleProcessId!));
                  } else {
                    context.read<SellBloc>().add(LoadSellProcesses());
                  }
                  Navigator.pop(context);
                } else if (sellState is SellError) {
                  // No need to show snackbar here
                }
              },
              child: Column(
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
                          '${selectedMaterialUniqueId != null ? 1 : 0} مواد',
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
                                    selectedMaterialUniqueId = val;
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
              ),
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
    final double totalCommission = double.tryParse(totalCommissionController.text) ?? 0;

    // التأكد من أن قيم السلايدر لا تتجاوز نسبة العمولة
    if (traderCommissionSlider > totalCommission) {
      traderCommissionSlider = totalCommission;
    }
    if (officeCommissionSlider > totalCommission) {
      officeCommissionSlider = totalCommission;
    }

    // التحقق من مجموع نسب العمولة للخابط عدد
    void _validateMarkupQtyCommissions() {
      if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == true) {
        double totalCommission = double.tryParse(totalCommissionController.text) ?? 0;
        double trader = double.tryParse(traderCommissionController.text) ?? 0;
        double office = double.tryParse(officeCommissionController.text) ?? 0;
        double broker = double.tryParse(brokerageController.text) ?? 0;
        double sum = trader + office + broker;
        if (sum != totalCommission) {
          // No need to show snackbar here
        }
      }
    }

    // التحقق من مجموع نسب أجور القطعة
    void _validateMarkupQtyPieceRates() {
      if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == true) {
        int sum = traderPieceRate.toInt() + officePieceRate.toInt() + workerPieceRate.toInt();
        if (sum != 100) {
          // No need to show snackbar here
        }
      }
    }

    // خابط عدد
    if (type == 'markup' && isQty == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // نسبة العمولة
          _buildCommissionCard(
            title: "نسبة العمولة",
            controller: totalCommissionController,
          ),
          const SizedBox(height: 16),
          // توزيع نسبة العمولة
          const Text(
            "توزيع نسبة العمولة (يجب أن يساوي نسبة العمولة)",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          _buildCommissionCard(
            title: "نسبة التاجر من العمولة",
            controller: traderCommissionController,
            isIntOnly: true,
            onChanged: (_) => _validateMarkupQtyCommissions(),
          ),
          const SizedBox(height: 8),
          _buildCommissionCard(
            title: "نسبة المكتب من العمولة",
            controller: officeCommissionController,
            isIntOnly: true,
            onChanged: (_) => _validateMarkupQtyCommissions(),
          ),
          const SizedBox(height: 8),
          _buildCommissionCard(
            title: "نسبة الدلالية",
            controller: brokerageController,
            isIntOnly: true,
            onChanged: (_) => _validateMarkupQtyCommissions(),
          ),
          const SizedBox(height: 16),
          // أجور القطعة
          _buildCommissionCard(
            title: "أجور القطعة",
            controller: pieceRateController,
          ),
          const SizedBox(height: 16),
          // توزيع نسب أجور القطعة
          const Text(
            "توزيع نسب أجور القطعة (يجب أن يساوي 100%)",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          _buildRateCardWithSlider(
            title: "نسبة التاجر من أجور القطعة",
            value: traderPieceRate.toInt().toDouble(),
            onChanged: (val) {
              setState(() => traderPieceRate = val.toInt().toDouble());
              _validateMarkupQtyPieceRates();
            },
          ),
          const SizedBox(height: 8),
          _buildRateCardWithSlider(
            title: "نسبة المكتب من أجور القطعة",
            value: officePieceRate.toInt().toDouble(),
            onChanged: (val) {
              setState(() => officePieceRate = val.toInt().toDouble());
              _validateMarkupQtyPieceRates();
            },
          ),
          const SizedBox(height: 8),
          _buildRateCardWithSlider(
            title: "نسبة العامل من أجور القطعة",
            value: workerPieceRate.toInt().toDouble(),
            onChanged: (val) {
              setState(() => workerPieceRate = val.toInt().toDouble());
              _validateMarkupQtyPieceRates();
            },
          ),
        ],
      );
    }
    
    // خابط وزن
    if (type == 'markup' && isQty == false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // نسبة العمولة
          _buildCommissionCard(
            title: "نسبة العمولة",
            controller: totalCommissionController,
          ),
          const SizedBox(height: 16),
          
          // توزيع نسبة العمولة (شرائط سحب)
          const Text(
            "توزيع نسبة العمولة",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          
          // نسبة التاجر (سلايدر)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "نسبة التاجر من العمولة (${traderCommissionSlider.toInt()}%)",
                style: const TextStyle(
                  color: Color.fromARGB(255, 28, 98, 32),
                  fontSize: 14,
                ),
              ),
              Slider(
                value: traderCommissionSlider.toInt().toDouble(),
                onChanged: (val) {
                  setState(() {
                    traderCommissionSlider = val.toInt().toDouble();
                    officeCommissionSlider = totalCommission - val.toInt().toDouble();
                  });
                  _validateWeightMarkupCommissions();
                },
                min: 0,
                max: totalCommission,
                divisions: 100,
                activeColor: Color.fromARGB(255, 28, 98, 32),
                inactiveColor: const Color(0xFFCFE8D7),
              ),
            ],
          ),
          
          // نسبة المكتب (سلايدر)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "نسبة المكتب من العمولة (${officeCommissionSlider.toInt()}%)",
                style: const TextStyle(
                  color: Color.fromARGB(255, 28, 98, 32),
                  fontSize: 14,
                ),
              ),
              Slider(
                value: officeCommissionSlider.toInt().toDouble(),
                onChanged: (val) {
                  setState(() {
                    officeCommissionSlider = val.toInt().toDouble();
                    traderCommissionSlider = totalCommission - val.toInt().toDouble();
                  });
                  _validateWeightMarkupCommissions();
                },
                min: 0,
                max: totalCommission,
                divisions: 100,
                activeColor: Color.fromARGB(255, 28, 98, 32),
                inactiveColor: const Color(0xFFCFE8D7),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // أجور العمل لكل كيلو
          _buildCommissionCard(
            title: "أجور العمل لكل كيلو",
            controller: pieceRateController,
          ),
          const SizedBox(height: 16),
          
          // نسبة العامل
          _buildCommissionCard(
            title: "نسبة العامل",
            controller: workerPieceRateController,
          ),
          const SizedBox(height: 8),
          
          // نسبة الدلالية
          _buildCommissionCard(
            title: "نسبة الدلالية",
            controller: brokerageController,
          ),
        ],
      );
    }

    // صافي عدد أو صافي وزن
    if (type == 'consignment' && sellType == "بالكوترة") {
      double pieceRate = double.tryParse(pieceRateController.text) ?? 0;
      double workerRate = double.tryParse(workerPieceRateController.text) ?? 0;
      double brokerRate = double.tryParse(brokerageController.text) ?? 0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radio Buttons لاختيار نوع العمولة
          const Text(
            "نوع عمولة المكتب",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text("بالدينار"),
                  value: 'دينار',
                  groupValue: officeCommissionType,
                  onChanged: (val) {
                    setState(() {
                      officeCommissionType = val!;
                      officeCommissionController.clear();
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Color(0xFF1C6220),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text("بالمئوية"),
                  value: 'مئوية',
                  groupValue: officeCommissionType,
                  onChanged: (val) {
                    setState(() {
                      officeCommissionType = val!;
                      officeCommissionController.clear();
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Color(0xFF1C6220),
                ),
              ),
            ],
          ),
          // الحقل المناسب حسب الاختيار
          if (officeCommissionType == 'دينار')
            _buildCommissionCard(
              title: "عمولة المكتب بالدينار",
              controller: officeCommissionController,
            ),
          if (officeCommissionType == 'مئوية')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "عمولة المكتب بالمئة",
                  style: TextStyle(
                    color: Color.fromARGB(255, 28, 98, 32),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${officePieceRate.toInt()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
                Slider(
                  value: officePieceRate.toInt().toDouble(),
                  onChanged: (val) => setState(() => officePieceRate = val.toInt().toDouble()),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  activeColor: Color.fromARGB(255, 28, 98, 32),
                  inactiveColor: const Color(0xFFCFE8D7),
                ),
              ],
            ),
          const SizedBox(height: 8),
          // حقل أجور نقل القطعة الواحدة
          _buildCommissionCard(
            title: "أجور نقل القطعة الواحدة",
            controller: pieceRateController,
          ),
          const SizedBox(height: 8),
          // نسبة العامل
          _buildCommissionCard(
            title: "نسبة العامل",
            controller: workerPieceRateController,
          ),
          const SizedBox(height: 8),
          // نسبة الدلالية
          _buildCommissionCard(
            title: "نسبة الدلالية",
            controller: brokerageController,
          ),
        ],
      );
    }

    // الحالة الافتراضية (البيع العادي)
    return Column(
      children: [
        _buildCommissionCard(
          title: "نسبة العمولة",
          controller: totalCommissionController,
        ),
        const SizedBox(height: 8),
        _buildCommissionCard(
          title: "أجور القطعة",
          controller: pieceRateController,
        ),
      ],
    );
  }

  Widget _buildCommissionCard({
    required String title,
    required TextEditingController controller,
    Function(String)? onChanged,
    bool isIntOnly = false,
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
              inputFormatters: isIntOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
              onChanged: onChanged,
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
            value: value.toInt().toDouble(),
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

  // دالة لتوليد معرف فريد للمادة
  // يستخدم لتجنب تضارب المواد من نوعين مختلفين (خابط وصافي) قد يكون لها نفس الـ ID
  // c = consignment (صافي), m = markup (خابط)
  // مثال: c10 للمادة رقم 10 من نوع صافي، m10 للمادة رقم 10 من نوع خابط
  String _generateUniqueId(MaterialsModel material) {
    String prefix = material.materialType == 'consignment' ? 'c' : 'm';
    return '$prefix${material.id}';
  }

  // دالة للتحقق من اختيار المادة
  bool _isMaterialSelected(MaterialsModel material) {
    if (selectedMaterialUniqueId == null) return false;
    return selectedMaterialUniqueId == _generateUniqueId(material);
  }

  // التحقق من مجموع نسب العمولة
  void _validateCommissionSum() {
    if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == true) {
      double totalCommission = double.tryParse(totalCommissionController.text) ?? 0;
      double traderCommission = double.tryParse(traderCommissionController.text) ?? 0;
      double officeCommission = double.tryParse(officeCommissionController.text) ?? 0;
      double brokerageCommission = double.tryParse(brokerageController.text) ?? 0;
      
      double sum = traderCommission + officeCommission + brokerageCommission;
      
      if (sum != totalCommission) {
        // No need to show snackbar here
      }
    }
  }

  // تحديث حقول النسب عند تغيير النسبة الإجمالية
  void _updateCommissionFields() {
    if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == true) {
      double totalCommission = double.tryParse(totalCommissionController.text) ?? 0;
      // توزيع النسبة بالتساوي
      double individualShare = totalCommission / 3;
      
      traderCommissionController.text = individualShare.toString();
      officeCommissionController.text = individualShare.toString();
      brokerageController.text = individualShare.toString();
    }
  }

  // التحقق من مجموع نسب العمولة للخابط وزن
  void _validateWeightMarkupCommissions() {
    if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == false) {
      double totalCommission = double.tryParse(totalCommissionController.text) ?? 0;
      double sum = traderCommissionSlider + officeCommissionSlider;
      
      if (sum != totalCommission) {
        // No need to show snackbar here
      }
    }
  }

  // التحقق من مجموع نسب العامل والدلالية للخابط وزن
  void _validateWeightMarkupWorkerBroker() {
    if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == false) {
      double pieceRate = double.tryParse(pieceRateController.text) ?? 0;
      double workerRate = double.tryParse(workerPieceRateController.text) ?? 0;
      double brokerRate = double.tryParse(brokerageController.text) ?? 0;
      double sum = workerRate + brokerRate;
      
      if (sum != pieceRate) {
        // No need to show snackbar here
      }
    }
  }

  // تحديث قيم السلايدر عند تغيير نسبة العمولة
  void _updateCommissionSliders() {
    if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == false) {
      double totalCommission = double.tryParse(totalCommissionController.text) ?? 0;
      setState(() {
        // توزيع النسبة بالتساوي بين التاجر والمكتب
        traderCommissionSlider = totalCommission / 2;
        officeCommissionSlider = totalCommission / 2;
      });
    }
  }

  // التحقق من مجموع نسب أجور القطعة
  void _validatePieceRateSum() {
    if (selectedMaterial?.materialType == 'markup' && selectedMaterial?.isQuantity == true) {
      double pieceRate = double.tryParse(pieceRateController.text) ?? 0;
      double traderRate = double.tryParse(traderPieceRateController.text) ?? 0;
      double workerRate = double.tryParse(workerPieceRateController.text) ?? 0;
      double brokerRate = double.tryParse(brokerageController.text) ?? 0;
      
      double sum = traderRate + workerRate + brokerRate;
      
      if (sum != pieceRate) {
        // No need to show snackbar here
      }
    }
  }
}