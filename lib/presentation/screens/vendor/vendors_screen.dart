import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/vendor/vendor_bloc.dart';
import '../../../logic/blocs/vendor/vendor_event.dart';
import '../../../logic/blocs/vendor/vendor_state.dart';
import '../../../data/models/vendor_model.dart';
import 'vendor_details_page.dart';
import 'package:intl/intl.dart' hide TextDirection;

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  int expandedIndex = -1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<VendorBloc>().add(LoadVendors());
  }

  void _filterVendors(String query) {
    context.read<VendorBloc>().add(SearchVendors(query));
    setState(() {
      expandedIndex = -1; // Reset expansion when filtering
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isTodayInvoice(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  List<VendorModel> _getTodayVendors(List<VendorModel> vendors) {
    return vendors.where((vendor) {
      return vendor.invoices?.any((invoice) => _isTodayInvoice(invoice.createdAt)) ?? false;
    }).toList();
  }

  int _getTodayInvoiceCount(VendorModel vendor) {
    return vendor.invoices?.where((invoice) => _isTodayInvoice(invoice.createdAt)).length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final headerHeight = isTablet ? 140.0 : 120.0;
    final horizontalPadding = isTablet ? 32.0 : 16.0;

    return BlocConsumer<VendorBloc, VendorState>(
      listener: (context, state) {
        if (state is VendorError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
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
                        'متسوقي اليوم',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 24 : 20,
                          color: const Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Search Box
                Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: TextField(
                    controller: _searchController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن اسم المتسوق',
                      hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      prefixIcon: Icon(
                        Icons.search, 
                        color: const Color.fromARGB(255, 28, 98, 32),
                        size: isTablet ? 24 : 20,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isTablet ? 16 : 12, 
                        horizontal: isTablet ? 20 : 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                    onChanged: _filterVendors,
                  ),
                ),

                // Vendors List
                if (state is VendorLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 28, 98, 32),
                      ),
                    ),
                  )
                else if (state is VendorsLoaded)
                  Expanded(
                    child: _getTodayVendors(state.vendors).isEmpty
                        ? const Center(
                            child: Text(
                              'لا يوجد متسوقين اليوم',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            itemCount: _getTodayVendors(state.vendors).length,
                            itemBuilder: (context, index) {
                              final isExpanded = expandedIndex == index;
                              final vendor = _getTodayVendors(state.vendors)[index];
                              final todayInvoiceCount = _getTodayInvoiceCount(vendor);
                              
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expandedIndex = isExpanded ? -1 : index;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeInOut,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: isTablet ? 24 : 16, 
                                          vertical: isTablet ? 18 : 14),
                                      margin: EdgeInsets.symmetric(vertical: isTablet ? 8 : 6),
                                      decoration: BoxDecoration(
                                        color: isExpanded
                                            ? const Color(0xFFDEF2E0)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 5,
                                            offset: Offset(0, 3))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline, 
                                                color: const Color.fromARGB(255, 28, 98, 32), 
                                                size: isTablet ? 28 : 24,
                                              ),
                                              SizedBox(width: isTablet ? 12 : 8),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    vendor.name,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: isTablet ? 18 : 16,
                                                      color: const Color.fromARGB(255, 28, 98, 32),
                                                    ),
                                                  ),
                                                  Text(
                                                    'عدد الفواتير اليوم: $todayInvoiceCount',
                                                    style: TextStyle(
                                                      fontSize: isTablet ? 14 : 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up_rounded
                                                : Icons.keyboard_arrow_down_rounded,
                                            size: isTablet ? 32 : 28,
                                            color: const Color.fromARGB(255, 28, 98, 32),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isExpanded)
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
                                      padding: EdgeInsets.all(isTablet ? 24 : 16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF2FDF4),
                                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // Vendor Details
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'رقم الهاتف:',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: isTablet ? 16 : 14,
                                                ),
                                              ),
                                              SizedBox(width: isTablet ? 12 : 8),
                                              Text(
                                                vendor.phoneNumber,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: isTablet ? 17 : 15,
                                                  color: const Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: isTablet ? 16 : 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'عدد الفواتير:',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: isTablet ? 16 : 14,
                                                ),
                                              ),
                                              SizedBox(width: isTablet ? 12 : 8),
                                              Text(
                                                '${vendor.totalInvoicesCount} فاتورة',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: isTablet ? 17 : 15,
                                                  color: const Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: isTablet ? 20 : 16),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: isTablet ? 16 : 12,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => VendorDetailsPage(
                                                      vendorName: vendor.name,
                                                      vendor: vendor,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'عرض التفاصيل',
                                                style: TextStyle(
                                                  fontSize: isTablet ? 18 : 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'حدث خطأ في تحميل البيانات',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
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
}