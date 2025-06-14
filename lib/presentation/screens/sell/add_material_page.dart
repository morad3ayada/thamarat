import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../logic/blocs/vendor/vendor_bloc.dart';
import '../../../logic/blocs/vendor/vendor_event.dart';
import '../../../logic/blocs/vendor/vendor_state.dart';
import '../../../logic/blocs/materials/materials_bloc.dart';
import '../../../logic/blocs/materials/materials_event.dart';
import '../../../logic/blocs/materials/materials_state.dart';
import '../../../data/models/materials_model.dart';

class AddMaterialPage extends StatefulWidget {
  final String? customerName;
  final String? customerPhone;
  
  const AddMaterialPage({
    super.key,
    this.customerName,
    this.customerPhone,
  });

  @override
  State<AddMaterialPage> createState() => _AddMaterialPageState();
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _materialNameController = TextEditingController();
  final TextEditingController _fridgeNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController();
  final TextEditingController _traderCommissionController = TextEditingController();
  final TextEditingController _officeCommissionController = TextEditingController();
  final TextEditingController _brokerageController = TextEditingController();
  final TextEditingController _pieceRateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _sellType = 'قطاعي';
  int expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<VendorBloc>().add(LoadVendors());
    context.read<MaterialsBloc>().add(LoadMaterials());
    _searchController.addListener(_filterMaterials);
    
    // Pre-fill customer data if provided
    if (widget.customerName != null) {
      _customerNameController.text = widget.customerName!;
    }
    if (widget.customerPhone != null) {
      _customerPhoneController.text = widget.customerPhone!;
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _materialNameController.dispose();
    _fridgeNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _commissionController.dispose();
    _traderCommissionController.dispose();
    _officeCommissionController.dispose();
    _brokerageController.dispose();
    _pieceRateController.dispose();
    _weightController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<SellBloc>().add(
        AddSellMaterial(
          customerName: _customerNameController.text,
          customerPhone: _customerPhoneController.text,
          materialName: _materialNameController.text,
          fridgeName: _fridgeNameController.text,
          sellType: _sellType,
          quantity: double.parse(_quantityController.text),
          price: double.parse(_priceController.text),
          commission: _commissionController.text.isNotEmpty ? double.parse(_commissionController.text) : null,
          traderCommission: _traderCommissionController.text.isNotEmpty ? double.parse(_traderCommissionController.text) : null,
          officeCommission: _officeCommissionController.text.isNotEmpty ? double.parse(_officeCommissionController.text) : null,
          brokerage: _brokerageController.text.isNotEmpty ? double.parse(_brokerageController.text) : null,
          pieceRate: _pieceRateController.text.isNotEmpty ? double.parse(_pieceRateController.text) : null,
          weight: _weightController.text.isNotEmpty ? double.parse(_weightController.text) : null,
        ),
      );
    }
  }

  void _filterVendors(String query) {
    context.read<VendorBloc>().add(SearchVendors(query));
    setState(() {
      expandedIndex = -1;
    });
  }

  void _filterMaterials() {
    final query = _searchController.text;
    context.read<MaterialsBloc>().add(SearchMaterials(query));
    setState(() {
      expandedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellBloc, SellState>(
      listener: (context, state) {
        if (state is SellError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is SellConfirmed) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: Form(
            key: _formKey,
            child: Column(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                            'إضافة عملية بيع',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Information
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'بيانات العميل',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 28, 98, 32),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _customerNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'اسم العميل',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال اسم العميل';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _customerPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'رقم الهاتف',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال رقم الهاتف';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Material Information
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'بيانات المادة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 28, 98, 32),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _fridgeNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'البراد',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال اسم البراد';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _materialNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'المادة',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال اسم المادة';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _sellType,
                                  decoration: const InputDecoration(
                                    labelText: 'نوع البيع',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'قطاعي',
                                      child: Text('قطاعي'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'جملة',
                                      child: Text('جملة'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _sellType = value;
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'الكمية',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال الكمية';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'الرجاء إدخال رقم صحيح';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'السعر',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال السعر';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'الرجاء إدخال رقم صحيح';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Additional Information
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'معلومات إضافية',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 28, 98, 32),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _commissionController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'العمولة',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _traderCommissionController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'عمولة التاجر',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _officeCommissionController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'عمولة المكتب',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _brokerageController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'الوساطة',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _pieceRateController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'سعر القطعة',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'الوزن (كجم)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: state is SellLoading ? null : _submitForm,
                      child: state is SellLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'إضافة',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
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