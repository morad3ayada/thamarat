import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/vendor/vendor_bloc.dart';
import '../../../logic/blocs/vendor/vendor_event.dart';
import '../../../logic/blocs/vendor/vendor_state.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../data/models/vendor_model.dart';
import '../../../data/models/sell_model.dart';
import 'add_material_page.dart';
import 'sell_details_page.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  int selectedTab = 0;
  TextEditingController searchController = TextEditingController();
  List<VendorModel> filteredCustomers = [];
  List<VendorModel> customers = [];
  List<VendorModel> allCustomers = []; // جميع الزبائن للبحث
  bool showSearchResults = false; // لعرض/إخفاء نتائج البحث
  
  // Map to store customer phone numbers by name
  Map<String, String> customerPhoneMap = {};

  @override
  void initState() {
    super.initState();
    context.read<VendorBloc>().add(LoadVendors());
    context.read<SellBloc>().add(LoadSellProcesses());
    searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterCustomers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      // فلترة الزبائن الرئيسية (الذين لم يكملوا عملية البيع)
      filteredCustomers = customers.where((customer) {
        final nameMatch = customer.name.toLowerCase().contains(query);
        final phoneMatch = customer.phoneNumber.contains(query);
        return nameMatch || phoneMatch;
      }).toList();

      // فلترة جميع الزبائن للبحث
      if (query.isNotEmpty) {
        // استخدام جميع الزبائن من state.vendors للفلترة
        final allVendors = context.read<VendorBloc>().state is VendorsLoaded 
            ? (context.read<VendorBloc>().state as VendorsLoaded).vendors 
            : <VendorModel>[];
            
        allCustomers = allVendors.where((customer) {
          final nameMatch = customer.name.toLowerCase().contains(query);
          final phoneMatch = customer.phoneNumber.contains(query);
          return nameMatch || phoneMatch;
        }).toList();
        showSearchResults = true;
      } else {
        showSearchResults = false;
        allCustomers = [];
      }
    });
  }

  void _selectCustomerFromSearch(VendorModel selectedCustomer) {
    setState(() {
      searchController.text = selectedCustomer.name;
      showSearchResults = false;
    });
    
    // البحث عن الفاتورة التي لم ترسل للمكتب بعد
    final pendingInvoice = selectedCustomer.invoices
        .where((invoice) => !invoice.sentToOffice)
        .firstOrNull;
    
    if (pendingInvoice != null) {
      // إذا كان لديه فاتورة معلقة، انتقل لصفحة تفاصيل البيع مع بيانات الفاتورة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellDetailsPage(
            name: selectedCustomer.name,
            phone: selectedCustomer.phoneNumber,
            customerId: selectedCustomer.id,
            pendingInvoiceId: pendingInvoice.id,
          ),
        ),
      );
    } else {
      // إذا لم يكن لديه فاتورة معلقة، انتقل لصفحة تفاصيل البيع العادية
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellDetailsPage(
            name: selectedCustomer.name,
            phone: selectedCustomer.phoneNumber,
            customerId: selectedCustomer.id,
          ),
        ),
      );
    }
  }

  void _showAddCustomerDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'إضافة زبون جديد',
            style: TextStyle(
              color: Color.fromARGB(255, 28, 98, 32),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'اسم الزبون',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 28, 98, 32)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 28, 98, 32),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 28, 98, 32)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 28, 98, 32),
                        width: 2,
                      ),
                    ),
                    hintText: '07X1234567',
                  ),
                ),
              ],
            ),
          ),
          actions: [
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
                      'رجوع',
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
                      if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                        context.read<VendorBloc>().add(
                          AddVendor(
                            name: nameController.text,
                            phone: phoneController.text,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 28, 98, 32),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'إضافة',
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
    );
  }

  void _buildCustomerPhoneMap(List<VendorModel> vendors) {
    // Don't clear the map, just update/add entries
    for (var vendor in vendors) {
      if (vendor.phoneNumber.isNotEmpty) {
        customerPhoneMap[vendor.name] = vendor.phoneNumber;
        print('Updating phone map: ${vendor.name} -> ${vendor.phoneNumber}');
      }
    }
    print('Phone map now has ${customerPhoneMap.length} entries');
  }

  String _getCustomerPhone(String customerName) {
    final phone = customerPhoneMap[customerName];
    print('Getting phone for $customerName: $phone');
    return phone ?? 'رقم الهاتف غير متوفر';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<VendorBloc>().add(LoadVendors());
            context.read<SellBloc>().add(LoadSellProcesses());
          },
          color: const Color.fromARGB(255, 28, 98, 32),
          child: BlocBuilder<VendorBloc, VendorState>(
            builder: (context, state) {
              if (state is VendorsLoaded) {
                _buildCustomerPhoneMap(state.vendors);
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
                          'بيع مادة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 28, 98, 32)
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
                        _buildStep(0, '1', 'الزبون'),
                        _buildStepLine(),
                        _buildStep(1, '2', 'بيانات البيع'),
                        _buildStepLine(),
                        _buildStep(2, '3', 'إتمام العملية'),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showAddCustomerDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 28, 98, 32),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.person_add, color: Colors.white),
                              label: const Text(
                                'إضافة زبون جديد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            ' البحث عن زبون سابق',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: searchController,
                            onTap: () {
                              if (searchController.text.isNotEmpty) {
                                setState(() {
                                  showSearchResults = true;
                                });
                              }
                            },
                            onEditingComplete: () {
                              setState(() {
                                showSearchResults = false;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'ابحث بالاسم أو رقم الهاتف',
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
                          if (showSearchResults && allCustomers.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: allCustomers.length,
                                itemBuilder: (context, index) {
                                  final customer = allCustomers[index];
                                  // Debug print to check customer phone numbers
                                  return ListTile(
                                    leading: const Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 28, 98, 32),
                                    ),
                                    title: Text(
                                      customer.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 28, 98, 32),
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        const Icon(
                                          Icons.phone_outlined,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          customer.phoneNumber.isNotEmpty 
                                              ? customer.phoneNumber 
                                              : 'رقم الهاتف غير متوفر',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => _selectCustomerFromSearch(customer),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 16),
                          const Text(
                            ' قائمة الزبائن الذين لم يكملوا عملية البيع',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            )
                          ),
                          Expanded(
                            child: BlocBuilder<SellBloc, SellState>(
                              builder: (context, sellState) {
                                if (sellState is SellLoaded) {
                                  customers = sellState.items.map((item) => VendorModel(
                                    id: item.customerId,
                                    name: item.customerName,
                                    phoneNumber: item.customerPhone,
                                    deleted: false,
                                    invoices: [],
                                  )).toList();
                                  if (filteredCustomers.isEmpty) {
                                    filteredCustomers = customers;
                                  }
                                  
                                  // بناء خريطة أرقام الهواتف
                                  _buildCustomerPhoneMap(customers);
                                }

                                // إذا كان لدينا بيانات البيع، نستخدمها لعرض الفواتير المعلقة
                                List<SellModel> pendingInvoices = [];
                                if (sellState is SellLoaded) {
                                  pendingInvoices = sellState.items.where((item) => !item.sentToOffice).toList();
                                }

                                return pendingInvoices.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'لا توجد فواتير معلقة',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
                                        itemCount: pendingInvoices.length,
                                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                                        itemBuilder: (context, index) {
                                          final invoice = pendingInvoices[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SellDetailsPage(
                                                    name: invoice.customerName,
                                                    phone: _getCustomerPhone(invoice.customerName),
                                                    customerId: invoice.customerId,
                                                    pendingInvoiceId: invoice.id,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(16),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              invoice.customerName,
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16,
                                                                color: Color.fromARGB(255, 28, 98, 32),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.phone_outlined,
                                                                  size: 16,
                                                                  color: Colors.grey,
                                                                ),
                                                                const SizedBox(width: 4),
                                                                Text(
                                                                  _getCustomerPhone(invoice.customerName),
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFE8F5E9),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          '${invoice.materials.length + invoice.spoiledMaterials.length} مادة',
                                                          style: const TextStyle(
                                                            color: Color.fromARGB(255, 28, 98, 32),
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        size: 16,
                                                        color: Colors.grey,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'آخر تحديث: ${_formatTime(invoice.createdAt)}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
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
                              },
                            ),
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
      ),
    );
  }

  Widget _buildStep(int index, String number, String label) {
    bool isActive = selectedTab == index;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? Color.fromARGB(255, 28, 98, 32) : Colors.grey[300],
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

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }
}