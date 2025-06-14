import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/vendor/vendor_bloc.dart';
import '../../../logic/blocs/vendor/vendor_event.dart';
import '../../../logic/blocs/vendor/vendor_state.dart';
import 'vendor_details_page.dart';

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
                        'المتسوقين',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Search Box
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن اسم المتسوق',
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
                    child: state.vendors.isEmpty
                        ? const Center(
                            child: Text(
                              'لا يوجد متسوقين',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.vendors.length,
                            itemBuilder: (context, index) {
                              final isExpanded = expandedIndex == index;
                              final vendor = state.vendors[index];
                              
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14),
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isExpanded
                                            ? const Color(0xFFDEF2E0)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
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
                                              const Icon(Icons.person_outline, 
                                                  color: Color.fromARGB(255, 28, 98, 32), size: 24),
                                              const SizedBox(width: 8),
                                              Text(
                                                vendor.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up_rounded
                                                : Icons.keyboard_arrow_down_rounded,
                                            size: 28,
                                            color: Color.fromARGB(255, 28, 98, 32),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isExpanded)
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF2FDF4),
                                        borderRadius: BorderRadius.circular(16),
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
                                              const Text(
                                                'رقم الهاتف:',
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                vendor.phoneNumber,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'الفواتير النشطة:',
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${vendor.activeInvoicesCount} فاتورة',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'إجمالي المبلغ:',
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${vendor.totalActiveAmount.toStringAsFixed(0)} دينار',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
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
                                              child: const Text(
                                                'عرض التفاصيل',
                                                style: TextStyle(
                                                  fontSize: 16,
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