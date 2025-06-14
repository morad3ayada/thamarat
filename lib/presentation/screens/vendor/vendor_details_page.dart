import 'package:flutter/material.dart';
import '../../../data/models/vendor_model.dart';

class VendorDetailsPage extends StatelessWidget {
  final String vendorName;
  final VendorModel? vendor;

  const VendorDetailsPage({super.key, required this.vendorName, this.vendor});

  @override
  Widget build(BuildContext context) {
    final activeInvoices = vendor?.activeInvoices ?? [];

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
                                '${vendor?.activeInvoicesCount ?? 0}',
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
                            'الفواتير النشطة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          Text(
                            '${activeInvoices.length} فاتورة',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Invoices list
                    Expanded(
                      child: activeInvoices.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد فواتير نشطة',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: activeInvoices.length,
                              itemBuilder: (context, index) {
                                final invoice = activeInvoices[index];
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
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}