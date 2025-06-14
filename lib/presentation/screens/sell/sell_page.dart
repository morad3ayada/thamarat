import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/vendor/vendor_bloc.dart';
import '../../../logic/blocs/vendor/vendor_event.dart';
import '../../../logic/blocs/vendor/vendor_state.dart';
import '../../../data/models/vendor_model.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<VendorBloc>().add(LoadVendors());
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
    
    // الانتقال لصفحة تفاصيل البيع
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellDetailsPage(
          name: selectedCustomer.name,
          phone: selectedCustomer.phoneNumber,
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VendorBloc, VendorState>(
      listener: (context, state) {
        if (state is VendorError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is VendorConfirmed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إضافة الزبون بنجاح'),
              backgroundColor: Color.fromARGB(255, 28, 98, 32),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is VendorsLoaded) {
          // فلترة الزبائن الذين لديهم فواتير لم ترسل للمكتب بعد
          customers = state.vendors.where((vendor) {
            return vendor.activeInvoices.any((invoice) => !invoice.sentToOffice);
          }).toList();
          
          if (filteredCustomers.isEmpty) {
            filteredCustomers = customers;
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
                            prefixIcon: const Icon(Icons.search, color:Color.fromARGB(255, 28, 98, 32)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        
                        // قائمة نتائج البحث
                        if (showSearchResults && allCustomers.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
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
                                  subtitle: Text(customer.phoneNumber),
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
                          child: state is VendorLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 28, 98, 32),
                                  ),
                                )
                              : filteredCustomers.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'لا توجد زبائن',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: filteredCustomers.length,
                                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        final customer = filteredCustomers[index];
                                        return GestureDetector(
                                          onTap: () {
                                            _selectCustomerFromSearch(customer);
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
                                            )],
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      customer.name,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Color.fromARGB(255, 28, 98, 32),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      customer.phoneNumber,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
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
      },
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
}