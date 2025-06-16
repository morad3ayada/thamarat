import 'package:flutter/material.dart';
import '../../../data/models/vendor_model.dart';

class VendorDetailsPage extends StatelessWidget {
  final String vendorName;
  final VendorModel? vendor;

  const VendorDetailsPage({super.key, required this.vendorName, this.vendor});

  @override
  Widget build(BuildContext context) {
    final allInvoices = vendor?.invoices ?? [];

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
                color: Color(0xFFDAF3D7),
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
                              Text(
                                vendor?.phoneNumber ?? '',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.receipt_long,
                                  color: Color.fromARGB(255, 28, 98, 32), size: 22),
                              const SizedBox(width: 4),
                              Text(
                                '${vendor?.totalInvoicesCount ?? 0} فاتورة',
                                style: const TextStyle(
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
                            'الفواتير',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Invoices list
                    Expanded(
                      child: allInvoices.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد فواتير',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: allInvoices.length,
                              itemBuilder: (context, index) {
                                final invoice = allInvoices[index];
                                return buildInvoiceCard(invoice);
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

  Widget buildInvoiceCard(InvoiceModel invoice) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'فاتورة رقم: #${invoice.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: invoice.sentToOffice ? Colors.green.shade100 : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    invoice.sentToOffice ? 'مرسلة للمكتب' : 'قيد المعالجة',
                    style: TextStyle(
                      fontSize: 12,
                      color: invoice.sentToOffice ? Colors.green.shade700 : Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'التاريخ: ${_formatDate(invoice.createdAt)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'إجمالي المبلغ: ${invoice.totalAmount.toStringAsFixed(0)} دينار',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(255, 28, 98, 32),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'عدد المواد: ${invoice.materials.length + invoice.spoiledMaterials.length}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            
            // عرض المواد التفصيلي
            if (invoice.materials.isNotEmpty || invoice.spoiledMaterials.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'تفاصيل المواد:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromARGB(255, 28, 98, 32),
                ),
              ),
              const SizedBox(height: 8),
              
              // البيع العادي
              ..._buildNormalMaterialsSection(invoice),
              
              // البيع بالكوترة
              ..._buildWholesaleMaterialsSection(invoice),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNormalMaterialsSection(InvoiceModel invoice) {
    List<dynamic> normalMaterials = [];
    normalMaterials.addAll(invoice.materials.where((m) => 
      m.materialType == 'consignment' || m.materialType == 'markup'
    ));
    
    if (normalMaterials.isNotEmpty) {
      return [
        const Text(
          'البيع العادي:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        ...normalMaterials.map((material) => _buildMaterialItem(material, false)),
        const SizedBox(height: 8),
      ];
    }
    return <Widget>[];
  }

  List<Widget> _buildWholesaleMaterialsSection(InvoiceModel invoice) {
    List<dynamic> wholesaleMaterials = [];
    wholesaleMaterials.addAll(invoice.materials.where((m) => 
      m.materialType == 'spoiledConsignment' || m.materialType == 'spoiledMarkup'
    ));
    wholesaleMaterials.addAll(invoice.spoiledMaterials);
    
    if (wholesaleMaterials.isNotEmpty) {
      return [
        const Text(
          'البيع بالكوترة:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 4),
        ...wholesaleMaterials.map((material) => _buildMaterialItem(material, true)),
      ];
    }
    return <Widget>[];
  }

  Widget _buildMaterialItem(dynamic material, bool isWholesale) {
    String materialName = '';
    String truckName = '';
    double? quantity;
    double? weight;
    double? price;
    String materialType = '';

    // تحديد نوع المادة واستخراج البيانات
    if (material is MaterialModel) {
      materialName = material.name;
      truckName = material.truckName;
      quantity = material.quantity;
      weight = material.weight;
      price = material.price;
      materialType = material.materialType;
    } else if (material is SpoiledMaterialModel) {
      materialName = material.name;
      truckName = material.truckName;
      quantity = material.quantity;
      weight = material.weight;
      price = material.price;
      materialType = material.materialType;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isWholesale ? Colors.orange.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWholesale ? Colors.orange.shade200 : Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  materialName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isWholesale ? Colors.orange.shade700 : Colors.green.shade700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isWholesale ? Colors.orange.shade100 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${price?.toStringAsFixed(0) ?? 0} دينار',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isWholesale ? Colors.orange.shade700 : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (weight != null && weight > 0) ...[
                Text(
                  'الوزن: ${weight.toStringAsFixed(2)} كيلو',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(width: 12),
              ],
              if (quantity != null && quantity > 0) ...[
                Text(
                  'العدد: ${quantity.toStringAsFixed(0)} قطعة',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                'البراد: $truckName',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'النوع: ${_getMaterialTypeDisplay(materialType)}',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _getMaterialTypeDisplay(String materialType) {
    switch (materialType) {
      case 'consignment':
        return 'صافي وزن';
      case 'markup':
        return 'خابط وزن';
      case 'spoiledConsignment':
        return 'صافي عدد';
      case 'spoiledMarkup':
        return 'خابط عدد';
      default:
        return materialType;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}