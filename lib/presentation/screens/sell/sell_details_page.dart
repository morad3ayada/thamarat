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
    context.read<SellBloc>().add(LoadSellProcesses());
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

                      // Add Material Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMaterialPage(
                                  customerName: widget.name,
                                  customerPhone: widget.phone,
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
                      const SizedBox(height: 16),

                      // Create New Invoice Button (for existing customers without pending invoices)
                      if (widget.customerId != null && widget.pendingInvoiceId == null)
                        BlocListener<SellBloc, SellState>(
                          listener: (context, state) {
                            if (state is SaleProcessCreated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم إنشاء فاتورة جديدة بنجاح'),
                                  backgroundColor: const Color.fromARGB(255, 28, 98, 32),
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
                      if (widget.customerId != null && widget.pendingInvoiceId == null)
                        const SizedBox(height: 16),

                      // Items List from API
                      Expanded(
                        child: BlocBuilder<SellBloc, SellState>(
                          builder: (context, state) {
                            if (state is SellLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is SellLoaded) {
                              List<sell_models.SellModel> customerItems;
                              
                              if (widget.pendingInvoiceId != null) {
                                // إذا كان لدينا معرف فاتورة معلقة، احسب فقط هذه الفاتورة
                                customerItems = state.items.where((item) =>
                                  item.id == widget.pendingInvoiceId
                                ).toList();
                              } else {
                                // فلترة المواد حسب اسم أو رقم هاتف الزبون
                                customerItems = state.items.where((item) =>
                                  item.customerName == widget.name &&
                                  item.customerPhone == widget.phone
                                ).toList();
                              }
                              
                              if (customerItems.isEmpty) {
                                return const Center(child: Text('لا توجد فواتير لهذا الزبون'));
                              }

                              // جمع جميع المواد من جميع الفواتير
                              List<dynamic> allMaterials = [];
                              for (var item in customerItems) {
                                allMaterials.addAll(item.getAllMaterials());
                              }

                              if (allMaterials.isEmpty) {
                                return const Center(child: Text('لا توجد مواد لهذا الزبون'));
                              }

                              return ListView.separated(
                                itemCount: allMaterials.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final material = allMaterials[index];
                                  return _buildMaterialItem(material);
                                },
                              );
                            } else if (state is SellError) {
                              return Center(child: Text(state.message));
                            }
                            return const SizedBox();
                          },
                        ),
                      ),

                      // Total Price
                      BlocBuilder<SellBloc, SellState>(
                        builder: (context, state) {
                          double total = 0;
                          if (state is SellLoaded) {
                            List<sell_models.SellModel> customerItems;
                            
                            if (widget.pendingInvoiceId != null) {
                              // إذا كان لدينا معرف فاتورة معلقة، احسب فقط هذه الفاتورة
                              customerItems = state.items.where((item) =>
                                item.id == widget.pendingInvoiceId
                              ).toList();
                            } else {
                              // فلترة المواد حسب اسم أو رقم هاتف الزبون
                              customerItems = state.items.where((item) =>
                                item.customerName == widget.name &&
                                item.customerPhone == widget.phone
                              ).toList();
                            }
                            
                            // حساب المجموع من جميع الفواتير
                            for (var item in customerItems) {
                              total += item.totalPrice;
                            }
                          }
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
                                  'المجموع الكلي',
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
                                      NumberFormat.decimalPattern().format(total),
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
                        },
                      ),
                      const SizedBox(height: 16),

                      // Next Button
                      BlocBuilder<SellBloc, SellState>(
                        builder: (context, state) {
                          if (state is SellLoaded) {
                            List<sell_models.SellModel> customerItems;
                            
                            if (widget.pendingInvoiceId != null) {
                              customerItems = state.items.where((item) =>
                                item.id == widget.pendingInvoiceId
                              ).toList();
                            } else {
                              customerItems = state.items.where((item) =>
                                item.customerName == widget.name &&
                                item.customerPhone == widget.phone
                              ).toList();
                            }
                            
                            if (customerItems.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            // جمع جميع المواد من جميع الفواتير
                            List<dynamic> allMaterials = [];
                            for (var item in customerItems) {
                              allMaterials.addAll(item.getAllMaterials());
                            }

                            if (allMaterials.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            // حساب المجموع
                            double total = 0;
                            for (var item in customerItems) {
                              total += item.totalPrice;
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
                                        materials: allMaterials,
                                        fridgeName: '',
                                        sellType: 'قطاعي',
                                        totalPrice: total,
                                        saleDate: DateTime.now(),
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
            ],
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

    // تحديد نوع المادة واستخراج البيانات
    if (material is sell_models.MaterialModel) {
      materialName = material.name;
      truckName = material.truckName;
      quantity = material.quantity;
      weight = material.weight;
      price = material.price;
      materialType = material.materialType;
      materialId = material.id;
      date = DateTime.now(); // المواد العادية لا تحتوي على تاريخ منفصل
    } else if (material is sell_models.SpoiledMaterialModel) {
      materialName = material.name;
      truckName = material.truckName;
      quantity = material.quantity;
      weight = material.weight;
      price = material.price;
      materialType = material.materialType;
      materialId = material.id;
      date = DateTime.now(); // المواد التالفة لا تحتوي على تاريخ منفصل
    }

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
                      materialType.contains('spoiled') ? 'تالف' : 'عادي',
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
                      _buildDetailRow('الوزن', '${weight.toStringAsFixed(2)} كيلو'),
                    if (quantity != null && quantity > 0)
                      _buildDetailRow('العدد', '${quantity.toStringAsFixed(0)} قطعة'),
                    _buildDetailRow('البراد', truckName),
                    _buildDetailRow('نوع المادة', _getMaterialTypeDisplay(materialType)),
                  ],
                ),
              ),
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
                  NumberFormat.decimalPattern().format(price ?? 0),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 28, 98, 32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int materialId, String materialType, String materialName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'تأكيد الحذف',
            style: TextStyle(
              color: Color.fromARGB(255, 28, 98, 32),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف المادة "$materialName"؟',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<SellBloc>().add(DeleteSellMaterial(
                  materialId: materialId,
                  materialType: materialType,
                ));
              },
              child: const Text(
                'حذف',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getMaterialTypeDisplay(String materialType) {
    switch (materialType) {
      case 'consignment':
        return 'صافي';
      case 'markup':
        return 'ربح';
      case 'spoiledConsignment':
        return 'صافي تالف';
      case 'spoiledMarkup':
        return 'ربح تالف';
      default:
        return materialType;
    }
  }
} 