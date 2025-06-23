import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../data/models/sell_model.dart' as sell_models;
import '../../../data/models/vendor_model.dart' as vendor_models;
import 'confirm_sell_page.dart';
import 'add_material_page.dart';
import 'package:thamarat/presentation/app_loader.dart';
import 'sell_page.dart';

// صفحة تفاصيل البيع - تعرض بيانات الفاتورة الحالية للعميل من السيرفر
// إذا كان هناك pendingInvoiceId: تعرض تفاصيل الفاتورة المحددة من السيرفر
// إذا لم يكن هناك pendingInvoiceId: تعرض الفاتورة الحالية (المعلقة) للعميل من السيرفر
// جميع البيانات تأتي من السيرفر وتركز على الفاتورة الحالية للعميل
class SellDetailsPage extends StatefulWidget {
  final String name;
  final String phone;
  final int? pendingInvoiceId; // معرف الفاتورة المعلقة
  final int? customerId; // معرف العميل لإنشاء فاتورة جديدة

  const SellDetailsPage({
    super.key, 
    required this.name, 
    required this.phone,
    this.pendingInvoiceId,
    this.customerId,
  });

  @override
  State<SellDetailsPage> createState() => _SellDetailsPageState();
}

class _SellDetailsPageState extends State<SellDetailsPage> {
  @override
  void initState() {
    super.initState();
    // تحميل بيانات الفاتورة الحالية للعميل من السيرفر
    if (widget.pendingInvoiceId != null) {
      // تحميل تفاصيل الفاتورة المحددة
      context.read<SellBloc>().add(LoadSellDetails(widget.pendingInvoiceId!));
    } else {
      // تحميل الفاتورة الحالية للعميل من السيرفر
      context.read<SellBloc>().add(LoadSellProcesses());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<SellBloc, SellState>(
        listener: (context, state) {
          if (state is SellConfirmed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف المادة بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            // تحديث البيانات من السيرفر بعد الحذف
            if (widget.pendingInvoiceId != null) {
              context.read<SellBloc>().add(LoadSellDetails(widget.pendingInvoiceId!));
            } else {
              context.read<SellBloc>().add(LoadSellProcesses());
            }
          } else if (state is SellError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: RefreshIndicator(
            onRefresh: () async {
              // تحديث البيانات من السيرفر
              if (widget.pendingInvoiceId != null) {
                context.read<SellBloc>().add(LoadSellDetails(widget.pendingInvoiceId!));
              } else {
                context.read<SellBloc>().add(LoadSellProcesses());
              }
            },
            color: const Color.fromARGB(255, 28, 98, 32),
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
                    children: [
                      GestureDetector(
                        onTap: () {
                          // العودة إلى صفحة البيع مع تحديث البيانات
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SellPage(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color.fromARGB(255, 28, 98, 32) ,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'تفاصيل البيع',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color:Color.fromARGB(255, 28, 98, 32),  
                        ),
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
                      _buildStep(2, '3', 'إتمام العملية', false),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Customer Info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 28, 98, 32) ,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, 
                                        color: Color.fromARGB(255, 28, 98, 32) , size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 28, 98, 32) 
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.phone_outlined, 
                                        color: Color.fromARGB(255, 28, 98, 32) , size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.phone.isNotEmpty 
                                          ? widget.phone 
                                          : 'رقم الهاتف غير متوفر',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 28, 98, 32),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Add Material Button (only show when there's a pending invoice)
                          if (widget.pendingInvoiceId != null)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddMaterialPage(
                                        saleProcessId: widget.pendingInvoiceId,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 28, 98, 32),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text(
                                  'إضافة مواد',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.pendingInvoiceId != null)
                            const SizedBox(height: 16),

                          // Create New Invoice Button (for customers without pending invoices)
                          if (widget.pendingInvoiceId == null)
                            BlocListener<SellBloc, SellState>(
                              listener: (context, state) {
                                if (state is SaleProcessCreated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم إنشاء فاتورة جديدة بنجاح'),
                                      backgroundColor: Color.fromARGB(255, 28, 98, 32),
                                    ),
                                  );
                                  // Navigate to the same page with the new invoice ID
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SellDetailsPage(
                                        name: widget.name,
                                        phone: widget.phone,
                                        customerId: widget.customerId,
                                        pendingInvoiceId: state.saleProcessId,
                                      ),
                                    ),
                                  );
                                } else if (state is SellError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: BlocBuilder<SellBloc, SellState>(
                                builder: (context, state) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: state is SellLoading
                                          ? null
                                          : () {
                                              context.read<SellBloc>().add(
                                                    CreateNewSaleProcess(
                                                      customerId: widget.customerId!,
                                                      customerName: widget.name,
                                                      customerPhone: widget.phone,
                                                    ),
                                                  );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: state is SellLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(Icons.receipt_long, color: Colors.white),
                                      label: Text(
                                        state is SellLoading ? 'جاري الإنشاء...' : 'إنشاء فاتورة جديدة',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (widget.pendingInvoiceId == null)
                            const SizedBox(height: 16),

                          // Items List from API
                          BlocBuilder<SellBloc, SellState>(
                            builder: (context, state) {
                              if (state is SellLoading) {
                                return const Center(child: AppLoader(message: 'جاري تحميل بيانات الفاتورة الحالية...'));
                              } else if (state is SellDetailsLoaded) {
                                // عرض تفاصيل الفاتورة المحددة من السيرفر
                                sell_models.SellModel invoice = state.sell;
                                List<dynamic> materials = invoice.getAllMaterials();
                                
                                if (materials.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.inventory_2_outlined,
                                          color: Colors.grey,
                                          size: 64,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'لا توجد مواد في الفاتورة الحالية',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'قم بإضافة مواد للفاتورة',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    // قائمة المواد
                                    ...materials.map((material) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _buildMaterialItem(material),
                                    )).toList(),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              } else if (state is SellLoaded) {
                                // البحث عن الفاتورة الحالية للعميل من السيرفر
                                List<sell_models.SellModel> customerInvoices = state.items.where((item) =>
                                  item.customerName == widget.name &&
                                  item.customerPhone == widget.phone
                                ).toList();
                                
                                // البحث عن الفاتورة المعلقة (الحالية)
                                sell_models.SellModel? currentInvoice;
                                for (var invoice in customerInvoices) {
                                  // البحث عن الفاتورة التي لم يتم إرسالها للمكتب (معلقة)
                                  if (!invoice.sentToOffice) {
                                    currentInvoice = invoice;
                                    break;
                                  }
                                }
                                
                                // إذا لم توجد فاتورة معلقة، خذ آخر فاتورة
                                if (currentInvoice == null && customerInvoices.isNotEmpty) {
                                  customerInvoices.sort((a, b) => b.id.compareTo(a.id));
                                  currentInvoice = customerInvoices.first;
                                }
                                
                                if (currentInvoice == null) {
                                  return Container(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.receipt_long_outlined,
                                          color: Colors.grey,
                                          size: 64,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'لا توجد فاتورة حالية لهذا العميل',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'قم بإنشاء فاتورة جديدة',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                
                                // عرض الفاتورة الحالية
                                List<dynamic> materials = currentInvoice!.getAllMaterials();
                                
                                if (materials.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.inventory_2_outlined,
                                          color: Colors.grey,
                                          size: 64,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'لا توجد مواد في الفاتورة الحالية',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'قم بإضافة مواد للفاتورة',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    // قائمة المواد
                                    ...materials.map((material) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _buildMaterialItem(material),
                                    )).toList(),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              } else if (state is SellError) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 64,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'خطأ في تحميل بيانات الفاتورة',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        state.message,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (widget.pendingInvoiceId != null) {
                                            context.read<SellBloc>().add(LoadSellDetails(widget.pendingInvoiceId!));
                                          } else {
                                            context.read<SellBloc>().add(LoadSellProcesses());
                                          }
                                        },
                                        child: const Text('إعادة المحاولة'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const Center(child: Text('جاري تحميل بيانات الفاتورة...'));
                            },
                          ),

                          // Total Price
                          BlocBuilder<SellBloc, SellState>(
                            builder: (context, state) {
                              double total = 0;
                              if (state is SellDetailsLoaded) {
                                // حساب المجموع من الفاتورة المحددة من السيرفر
                                total = state.sell.totalPrice;
                              } else if (state is SellLoaded) {
                                // البحث عن الفاتورة الحالية للعميل من السيرفر
                                List<sell_models.SellModel> customerInvoices = state.items.where((item) =>
                                  item.customerName == widget.name &&
                                  item.customerPhone == widget.phone
                                ).toList();
                                
                                // البحث عن الفاتورة المعلقة (الحالية)
                                sell_models.SellModel? currentInvoice;
                                for (var invoice in customerInvoices) {
                                  if (!invoice.sentToOffice) {
                                    currentInvoice = invoice;
                                    break;
                                  }
                                }
                                
                                // إذا لم توجد فاتورة معلقة، خذ آخر فاتورة
                                if (currentInvoice == null && customerInvoices.isNotEmpty) {
                                  customerInvoices.sort((a, b) => b.id.compareTo(a.id));
                                  currentInvoice = customerInvoices.first;
                                }
                                
                                // حساب المجموع من الفاتورة الحالية
                                if (currentInvoice != null) {
                                  total = currentInvoice.totalPrice;
                                }
                              }
                              
                              // عرض المجموع فقط إذا كان هناك بيانات
                              if (total > 0) {
                                return Container(
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'مجموع الفاتورة الحالية',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 28, 98, 32)
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            NumberFormat.decimalPattern().format(total.toInt()),
                                            style: const TextStyle(
                                              color:Color.fromARGB(255, 28, 98, 32),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const Text(
                                            'دينار',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 16),

                          // Next Button
                          BlocBuilder<SellBloc, SellState>(
                            builder: (context, state) {
                              if (state is SellDetailsLoaded) {
                                // عرض زر التالي للفاتورة المحددة من السيرفر
                                sell_models.SellModel invoice = state.sell;
                                List<dynamic> materials = invoice.getAllMaterials();
                                
                                if (materials.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ConfirmSellPage(
                                            customer: vendor_models.VendorModel(
                                              id: 0,
                                              name: widget.name,
                                              phoneNumber: widget.phone,
                                              deleted: false,
                                              invoices: [],
                                            ),
                                            materials: materials,
                                            fridgeName: '',
                                            sellType: 'قطاعي',
                                            totalPrice: invoice.totalPrice,
                                            saleDate: DateTime.now(),
                                            invoiceNumber: widget.pendingInvoiceId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'التالي',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (state is SellLoaded) {
                                // البحث عن الفاتورة الحالية للعميل من السيرفر
                                List<sell_models.SellModel> customerInvoices = state.items.where((item) =>
                                  item.customerName == widget.name &&
                                  item.customerPhone == widget.phone
                                ).toList();
                                
                                // البحث عن الفاتورة المعلقة (الحالية)
                                sell_models.SellModel? currentInvoice;
                                for (var invoice in customerInvoices) {
                                  if (!invoice.sentToOffice) {
                                    currentInvoice = invoice;
                                    break;
                                  }
                                }
                                
                                // إذا لم توجد فاتورة معلقة، خذ آخر فاتورة
                                if (currentInvoice == null && customerInvoices.isNotEmpty) {
                                  customerInvoices.sort((a, b) => b.id.compareTo(a.id));
                                  currentInvoice = customerInvoices.first;
                                }
                                
                                if (currentInvoice == null) {
                                  return const SizedBox.shrink();
                                }

                                // عرض زر التالي للفاتورة الحالية
                                List<dynamic> materials = currentInvoice.getAllMaterials();
                                
                                if (materials.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ConfirmSellPage(
                                            customer: vendor_models.VendorModel(
                                              id: 0,
                                              name: widget.name,
                                              phoneNumber: widget.phone,
                                              deleted: false,
                                              invoices: [],
                                            ),
                                            materials: materials,
                                            fridgeName: '',
                                            sellType: 'قطاعي',
                                            totalPrice: currentInvoice!.totalPrice,
                                            saleDate: DateTime.now(),
                                            invoiceNumber: currentInvoice!.id,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'التالي',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
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
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(value),
        ],
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
            color: isActive ? Color.fromARGB(255, 28, 98, 32): Colors.grey[300],
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
            color: isActive ? Color.fromARGB(255, 28, 98, 32) : Colors.grey,
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

  Widget _buildMaterialItem(dynamic material) {
    String materialName = '';
    String truckName = '';
    double? quantity;
    double? weight;
    double? price;
    String materialType = '';
    DateTime? date;
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
      date = DateTime.now();
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
      date = DateTime.now();
      isQuantity = material.isQuantity;
      totalPrice = material.totalPrice;
      isRate = material.isRate;
    }

    // تحديد نوع الإضافة
    bool isCounter = materialType.contains('markup');

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  materialName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: materialType.contains('spoiled') 
                          ? const Color(0xFFFFEBEE) 
                          : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isRate ? 'بيع بالكوترة' : 'بيع عادي',
                      style: TextStyle(
                        fontSize: 12,
                        color: materialType.contains('spoiled') 
                            ? Colors.red 
                            : const Color.fromARGB(255, 28, 98, 32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Delete Button
                  GestureDetector(
                    onTap: () {
                      _showDeleteConfirmation(materialId, materialType, materialName);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ 
              Expanded(
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (weight != null && weight > 0)
                      _buildDetailRow('الوزن', '${weight.toInt()} كيلو'),
                    if (quantity != null && quantity > 0)
                      _buildDetailRow('العدد', '${quantity.toInt()} قطعة'),
                    if (price != null && price > 0)
                      _buildDetailRow('سعر الوحدة', '${price.toInt()} دينار'),
                    _buildDetailRow('البراد', truckName),
                    _buildDetailRow('نوع المادة', _getMaterialTypeDisplay(materialType, isQuantity)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(255, 28, 98, 32),
                      ),
                    ),
                    child: Text(
                      NumberFormat.decimalPattern().format(totalPrice.toInt()),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 28, 98, 32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'دينار',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int materialId, String materialType, String materialName) {
    // Generate unique ID based on material type
    String uniqueId = materialType.startsWith('spoiled') 
        ? 's${materialType.startsWith('spoiledConsignment') ? 'c' : 'm'}$materialId'
        : '${materialType.startsWith('consignment') ? 'c' : 'm'}$materialId';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  'تأكيد الحذف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
                const SizedBox(height: 12),
                // Message
                Text(
                  'هل أنت متأكد من حذف المادة "$materialName"؟',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                            color: Color.fromARGB(255, 28, 98, 32),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<SellBloc>().add(DeleteSellMaterial(
                            materialId: materialId,
                            materialType: materialType,
                            uniqueId: uniqueId,
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'حذف',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
        );
      },
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
} 