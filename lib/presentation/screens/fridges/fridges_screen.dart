import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/fridge/fridge_bloc.dart';
import '../../../logic/blocs/fridge/fridge_event.dart';
import '../../../logic/blocs/fridge/fridge_state.dart';
import '../../../data/models/fridge_model.dart';
import 'fridge_detail_screen.dart';

class FridgesScreen extends StatefulWidget {
  const FridgesScreen({super.key});

  @override
  State<FridgesScreen> createState() => _FridgesScreenState();
}

class _FridgesScreenState extends State<FridgesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    context.read<FridgeBloc>().add(LoadFridgeItems());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
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
                const SizedBox(width: 8),
                const Text(
                  'الثلاجات',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'بحث في الثلاجات...',
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 28, 98, 32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 28, 98, 32)),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FridgeBloc, FridgeState>(
              builder: (context, state) {
                if (state is FridgeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FridgeLoaded) {
                  final filteredFridges = state.items.where((fridge) {
                    return fridge.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (filteredFridges.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد ثلاجات متوفرة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFridges.length,
                    itemBuilder: (context, index) {
                      final fridge = filteredFridges[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FridgeDetailScreen(
                                  fridgeId: fridge.id,
                                  fridgeName: fridge.name,
                                  count: fridge.quantity,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.green.shade100,
                                          child: const Icon(
                                            Icons.kitchen,
                                            color: Color.fromARGB(255, 28, 98, 32),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fridge.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(255, 28, 98, 32),
                                              ),
                                            ),
                                            Text(
                                              'تم الإضافة في ${_formatDate(fridge.addedAt)}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: fridge.quantity > 0
                                            ? Colors.green.shade100
                                            : Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        fridge.quantity > 0 ? 'متوفر' : 'غير متوفر',
                                        style: TextStyle(
                                          color: fridge.quantity > 0
                                              ? Colors.green.shade800
                                              : Colors.red.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoColumn(
                                      'الكمية',
                                      '${fridge.quantity} ${fridge.unit}',
                                      Icons.inventory_2,
                                    ),
                                    _buildInfoColumn(
                                      'تاريخ الإضافة',
                                      _formatDate(fridge.addedAt),
                                      Icons.calendar_today,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is FridgeError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<FridgeBloc>().add(LoadFridgeItems());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('لا توجد ثلاجات متوفرة'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add fridge functionality
        },
        backgroundColor: const Color.fromARGB(255, 28, 98, 32),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 28, 98, 32),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}
