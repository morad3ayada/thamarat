import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../data/models/sell_model.dart' as sell_models;
import '../../../data/models/vendor_model.dart' as vendor_models;
import '../../screens/home_page.dart';
import '../../../logic/blocs/profile/profile_bloc.dart';
import '../../../logic/blocs/profile/profile_state.dart';
import 'sell_details_page.dart';

class ConfirmSellPage extends StatelessWidget {
  final vendor_models.VendorModel customer;
  final vendor_models.VendorModel? vendor;
  final List<dynamic> materials;
  final String fridgeName;
  final String sellType;
  final double totalPrice;
  final DateTime saleDate;
  final int? invoiceNumber;

  const ConfirmSellPage({
    super.key,
    required this.customer,
    this.vendor,
    required this.materials,
    required this.fridgeName,
    required this.sellType,
    required this.totalPrice,
    required this.saleDate,
    this.invoiceNumber,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print to check if phone number is being passed
    print('Customer Name: ${customer.name}');
    print('Customer Phone: ${customer.phoneNumber}');
    
    // استخدام رقم الفاتورة كما يأتي من السيرفر
    final String displayInvoiceNumber = invoiceNumber?.toString() ?? '---';
    
    // تحديد نوع البيع حسب نوع المواد
    String getAutoSellTypeText() {
      if (materials.isNotEmpty && materials.every((m) => m is sell_models.SpoiledMaterialModel)) {
        return 'بيع بالكوترة';
      } else if (materials.isNotEmpty && materials.every((m) => m is sell_models.MaterialModel)) {
        return 'بيع عادي';
      } else if (materials.isEmpty) {
        return '-';
      } else {
        return 'متنوع';
      }
    }
    
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
                  const Text(
                    'تأكيد عملية البيع',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 28, 98, 32)),
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
                  _buildStep(2, '3', 'إتمام العملية', true),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'راجع بيانات عملية البيع قبل إتمام العملية',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 16),

                      // Order Summary Card
                      Container(
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
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Color(0xFFE8F5E9),
                              child: Icon(
                                Icons.shopping_cart_checkout,
                                size: 40,
                                color: Color.fromARGB(255, 28, 98, 32),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Order Info
                            BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                String sellerName = '---';
                                if (state is ProfileLoaded) {
                                  sellerName = state.user.name;
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoColumn(
                                      'رقم الفاتورة',
                                      '#$displayInvoiceNumber',
                                    ),
                                    _buildInfoColumn('التاريخ', '${saleDate.day}-${saleDate.month}-${saleDate.year}'),
                                    _buildInfoColumn('اسم البائع', sellerName),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Customer/Seller Info
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE9ECEF)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person_outline,
                                        color: Color.fromARGB(255, 28, 98, 32),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'اسم الزبون: ${customer.name.isNotEmpty ? customer.name : 'غير محدد'}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(255, 28, 98, 32),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone_outlined,
                                        color: Color.fromARGB(255, 28, 98, 32),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'رقم الهاتف: ${customer.phoneNumber.isNotEmpty ? customer.phoneNumber : 'غير محدد'}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color.fromARGB(255, 28, 98, 32),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (customer.phoneNumber.isEmpty)
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF3CD),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.orange),
                                      ),
                                      child: const Text(
                                        'تحذير: رقم الهاتف غير متوفر',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Vendor Info (if available)
                            if (vendor != null) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F8FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFBBDEFB)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.store_outlined,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'اسم البائع: ${vendor!.name.isNotEmpty ? vendor!.name : 'غير محدد'}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone_outlined,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'رقم الهاتف: ${vendor!.phoneNumber.isNotEmpty ? vendor!.phoneNumber : 'غير محدد'}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (vendor!.phoneNumber.isEmpty)
                                      Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF3CD),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.orange),
                                        ),
                                        child: const Text(
                                          'تحذير: رقم هاتف البائع غير متوفر',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Sale Details
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // نوع البيع مع لون مميز
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: getAutoSellTypeText() == 'بيع بالكوترة'
                                        ? Colors.orange[50]
                                        : getAutoSellTypeText() == 'بيع عادي'
                                            ? Colors.green[50]
                                            : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    getAutoSellTypeText(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: getAutoSellTypeText() == 'بيع بالكوترة'
                                          ? Colors.orange[800]
                                          : getAutoSellTypeText() == 'بيع عادي'
                                              ? Color.fromARGB(255, 28, 98, 32)
                                              : Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildInfoColumn('عدد المواد', '${materials.length}'),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Total Price
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F8E9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'سعر الفاتورة',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 28, 98, 32),
                                    ),
                                  ),
                                  Text(
                                    '${totalPrice.toInt()} دينار',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 28, 98, 32),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 8),

                            // Items List Title
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'محتويات عملية البيع',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 28, 98, 32),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Items List
                            ...materials.map((material) => _buildMaterialItem(material)).toList(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // العودة إلى صفحة تفاصيل البيع مع تحديث البيانات
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SellDetailsPage(
                                      name: customer.name,
                                      phone: customer.phoneNumber,
                                      customerId: customer.id,
                                      pendingInvoiceId: invoiceNumber,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 28, 98, 32),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'رجوع',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 28, 98, 32),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showSaveConfirmationDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'حفظ العملية',
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
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
            color: isActive ? const Color.fromARGB(255, 28, 98, 32) : Colors.grey[300],
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
            color: isActive ? const Color.fromARGB(255, 28, 98, 32) : Colors.grey,
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

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMaterialItem(dynamic material) {
    String materialName = '';
    String truckName = '';
    double? quantity;
    double? weight;
    double? price;
    String materialType = '';
    int materialId = 0;
    bool isQuantity = false;
    double totalPrice = 0;
    bool isRate = false;

    // تحديد نوع المادة واستخراج البيانات
    if (material is sell_models.MaterialModel) {
      materialName = material.name;
      truckName = material.truckName;
      quantity = material.quantity;
      weight = material.weight;
      price = material.price;
      materialType = material.materialType;
      materialId = material.id;
      isQuantity = material.isQuantity;
      totalPrice = material.totalPrice;
      isRate = false; // Normal materials are not rate-based
    } else if (material is sell_models.SpoiledMaterialModel) {
      materialName = material.name;
      truckName = material.truckName;
      quantity = material.quantity;
      weight = material.weight;
      price = material.price;
      materialType = material.materialType;
      materialId = material.id;
      isQuantity = material.isQuantity;
      totalPrice = material.totalPrice;
      isRate = material.isRate;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with material name and type
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.eco,
                  color: Color.fromARGB(255, 28, 98, 32),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  materialName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Material details in a structured layout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE9ECEF),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // First row: Weight/Quantity and Price
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard(
                        icon: weight != null && weight > 0 
                            ? Icons.scale 
                            : Icons.numbers,
                        label: weight != null && weight > 0 
                            ? 'الوزن' 
                            : 'العدد',
                        value: weight != null && weight > 0 
                            ? '${weight.toInt()} كيلو'
                            : quantity != null && quantity > 0 
                                ? '${quantity.toInt()} قطعة'
                                : 'غير محدد',
                        color: const Color(0xFFE3F2FD),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailCard(
                        icon: Icons.attach_money,
                        label: 'سعر الوحدة',
                        value: price != null && price > 0 
                            ? '${price.toInt()} دينار'
                            : 'غير محدد',
                        color: const Color(0xFFF3E5F5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Second row: Truck and Material Type
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard(
                        icon: Icons.local_shipping,
                        label: 'البراد',
                        value: truckName.isNotEmpty ? truckName : 'غير محدد',
                        color: const Color(0xFFE8F5E9),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailCard(
                        icon: Icons.category,
                        label: 'نوع المادة',
                        value: _getMaterialTypeDisplay(materialType, isQuantity),
                        color: const Color(0xFFFFF3E0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Third row: Sale Type and Total Price
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard(
                        icon: material is sell_models.SpoiledMaterialModel 
                            ? Icons.warning_amber_rounded 
                            : Icons.shopping_cart,
                        label: 'نوع البيع',
                        value: material is sell_models.SpoiledMaterialModel 
                            ? 'بيع بالكوترة' 
                            : 'بيع عادي',
                        color: material is sell_models.SpoiledMaterialModel 
                            ? const Color(0xFFFFF3E0)
                            : const Color(0xFFE8F5E9),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailCard(
                        icon: Icons.payments,
                        label: 'السعر الإجمالي',
                        value: '${totalPrice.toInt()} دينار',
                        color: const Color(0xFFE1F5FE),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: const Color.fromARGB(255, 28, 98, 32),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 28, 98, 32),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // دالة لعرض نوع المادة باللغة العربية
  // consignment = صافي (بيع عادي)
  // markup = خابط (بيع بالعمولة)
  // isQuantity = true = عدد، false = وزن
  String _getMaterialTypeDisplay(String materialType, bool isQuantity) {
    String baseType = '';
    String measurementType = isQuantity ? 'عدد' : 'وزن';
    
    // تحديد النوع الأساسي
    if (materialType.contains('consignment')) {
      baseType = 'صافي';
    } else if (materialType.contains('markup')) {
      baseType = 'خابط';
    } else {
      // للأنواع الأخرى
      switch (materialType) {
        case 'consignment':
          baseType = 'صافي';
          break;
        case 'markup':
          baseType = 'خابط';
          break;
        default:
          baseType = materialType;
      }
    }
    
    // إضافة كلمة "فاسد" إذا كان النوع يحتوي على spoiled
    if (materialType.contains('spoiled')) {
      return '$baseType فاسد $measurementType';
    }
    
    // إرجاع النوع مع طريقة القياس
    return '$baseType $measurementType';
  }

  void _showSaveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: const Color.fromARGB(255, 28, 98, 32),
          insetPadding: const EdgeInsets.all(40),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.save_outlined,
                  color: Color.fromARGB(255, 28, 98, 32),
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'هل تريد حفظ العملية مؤقتًا؟',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color.fromARGB(255, 28, 98, 32)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'إلغاء',
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
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'حفظ',
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
      ),
    );
  }
}
