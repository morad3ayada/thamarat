import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/vendor/vendor_bloc.dart';
import '../../../logic/blocs/vendor/vendor_event.dart';
import '../../../logic/blocs/vendor/vendor_state.dart';
import '../../../data/models/vendor_model.dart';
import 'package:intl/intl.dart' as intl hide TextDirection;

class VendorDetailsPage extends StatefulWidget {
  final String vendorName;
  final VendorModel vendor;

  const VendorDetailsPage({
    super.key,
    required this.vendorName,
    required this.vendor,
  });

  @override
  State<VendorDetailsPage> createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> {
  bool _isTodayInvoice(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  List<InvoiceModel> _getTodayInvoices(List<InvoiceModel> invoices) {
    return invoices.where((invoice) => _isTodayInvoice(invoice.createdAt)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final headerHeight = isTablet ? 140.0 : 120.0;
    final horizontalPadding = isTablet ? 32.0 : 16.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: Column(
          children: [
            // Header
            Container(
              height: headerHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFDAF3D7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                top: isTablet ? 55 : 45, 
                right: horizontalPadding, 
                left: horizontalPadding,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: const Color.fromARGB(255, 28, 98, 32),
                      size: isTablet ? 28 : 24,
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 8),
                  Text(
                    widget.vendorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 24 : 20,
                      color: const Color.fromARGB(255, 28, 98, 32),
                    ),
                  ),
                ],
              ),
            ),

            // Vendor Info
            Container(
              margin: EdgeInsets.all(isTablet ? 24 : 16),
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'رقم الهاتف:',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        widget.vendor.phoneNumber,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'عدد الفواتير اليوم:',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${_getTodayInvoices(widget.vendor.invoices ?? []).length} فاتورة',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Today's Invoices
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Text(
                    'فواتير اليوم',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 28, 98, 32),
                    ),
                  ),
                ],
              ),
            ),

            // Invoices List
            Expanded(
              child: _getTodayInvoices(widget.vendor.invoices ?? []).isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد فواتير اليوم',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(isTablet ? 24 : 16),
                      itemCount: _getTodayInvoices(widget.vendor.invoices ?? []).length,
                      itemBuilder: (context, index) {
                        final invoice = _getTodayInvoices(widget.vendor.invoices ?? [])[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(isTablet ? 20 : 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'رقم الفاتورة:',
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '#${invoice.id}',
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 28, 98, 32),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: isTablet ? 12 : 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الوقت:',
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    intl.DateFormat('hh:mm a').format(invoice.createdAt),
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 28, 98, 32),
                                    ),
                                  ),
                                ],
                              ),
                              if (invoice.materials.isNotEmpty || invoice.spoiledMaterials.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                Text(
                                  'المواد:',
                                  style: TextStyle(
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 28, 98, 32),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...invoice.materials.map((material) => _buildMaterialItem(material, false)),
                                ...invoice.spoiledMaterials.map((material) => _buildMaterialItem(material, true)),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialItem(dynamic material, bool isSpoiled) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSpoiled ? Colors.orange.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSpoiled ? Colors.orange.shade200 : Colors.green.shade200,
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
                  material.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isSpoiled ? Colors.orange.shade700 : Colors.green.shade700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSpoiled ? Colors.orange.shade100 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${material.price} ريال',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSpoiled ? Colors.orange.shade700 : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (material.weight != null && material.weight > 0) ...[
                Text(
                  'الوزن: ${material.weight.toStringAsFixed(2)} كيلو',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 12),
              ],
              if (material.quantity != null && material.quantity > 0) ...[
                Text(
                  'العدد: ${material.quantity.toStringAsFixed(0)} قطعة',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                'البراد: ${material.truckName}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'النوع: ${_getMaterialTypeDisplay(material.materialType)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
}