import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/materials/materials_bloc.dart';
import '../../../logic/blocs/materials/materials_event.dart';
import '../../../logic/blocs/materials/materials_state.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';

class SellDetailsPage extends StatefulWidget {
  final String name;
  final String phone;

  const SellDetailsPage({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  State<SellDetailsPage> createState() => _SellDetailsPageState();
}

class _SellDetailsPageState extends State<SellDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<Map<String, dynamic>> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    context.read<MaterialsBloc>().add(LoadMaterials());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addItem(Map<String, dynamic> material) {
    setState(() {
      final existingItem = _selectedItems.firstWhere(
        (item) => item['id'] == material['id'],
        orElse: () => {'id': material['id'], 'quantity': 0},
      );

      if (existingItem['quantity'] == 0) {
        _selectedItems.add({
          'id': material['id'],
          'name': material['name'],
          'price': material['price'],
          'quantity': 1,
          'unit': material['unit'],
        });
      } else {
        existingItem['quantity']++;
      }
    });
  }

  void _removeItem(Map<String, dynamic> material) {
    setState(() {
      final existingItem = _selectedItems.firstWhere(
        (item) => item['id'] == material['id'],
        orElse: () => {'quantity': 0},
      );

      if (existingItem['quantity'] > 1) {
        existingItem['quantity']--;
      } else {
        _selectedItems.removeWhere((item) => item['id'] == material['id']);
      }
    });
  }

  double get _totalPrice {
    return _selectedItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  void _completeSale() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إضافة مواد للبيع'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement sale completion using SellBloc
    context.read<SellBloc>().add(
          AddSellItem(
            customerName: widget.name,
            customerPhone: widget.phone,
            items: _selectedItems,
            totalPrice: _totalPrice,
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.phone,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث عن مادة...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Selected Items
          if (_selectedItems.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المواد المختارة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 98, 32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _selectedItems[index];
                        return ListTile(
                          title: Text(
                            item['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          subtitle: Text(
                            '${item['price']} دينار / ${item['unit']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.red,
                                onPressed: () => _removeItem(item),
                              ),
                              Text(
                                '${item['quantity']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: const Color.fromARGB(255, 28, 98, 32),
                                onPressed: () => _addItem(item),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'المجموع',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          Text(
                            '${_totalPrice.toStringAsFixed(2)} دينار',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Materials List
          Expanded(
            child: BlocBuilder<MaterialsBloc, MaterialsState>(
              builder: (context, state) {
                if (state is MaterialsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MaterialsLoaded) {
                  final filteredMaterials = state.materials.where((material) {
                    return material.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMaterials.length,
                    itemBuilder: (context, index) {
                      final material = filteredMaterials[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: const Icon(
                              Icons.inventory_2,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          title: Text(
                            material.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          subtitle: Text(
                            '${material.price} دينار / ${material.unit}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: const Color.fromARGB(255, 28, 98, 32),
                            onPressed: () => _addItem(material.toJson()),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is MaterialsError) {
                  return Center(
                    child: Text(
                      'حدث خطأ: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(child: Text('لا توجد مواد متاحة'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _completeSale,
        backgroundColor: const Color.fromARGB(255, 28, 98, 32),
        icon: const Icon(Icons.check),
        label: const Text('إتمام البيع'),
      ),
    );
  }
}