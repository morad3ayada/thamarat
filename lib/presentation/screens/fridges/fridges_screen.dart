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
    try {
      _searchController.addListener(() {
        setState(() {
          _searchQuery = _searchController.text;
        });
      });
      // Load fridge items immediately
      context.read<FridgeBloc>().add(LoadFridgeItems());
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when dependencies change (e.g., when returning to screen)
    try {
      // Only reload if not already loading
      final currentState = context.read<FridgeBloc>().state;
      if (currentState is! FridgeLoading) {
        context.read<FridgeBloc>().add(LoadFridgeItems());
      }
    } catch (e) {
      print('Error in didChangeDependencies: $e');
    }
  }

  @override
  void dispose() {
    try {
      _searchController.dispose();
    } catch (e) {
      print('Error disposing search controller: $e');
    }
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
                const Spacer(),
                const Text(
                  'البرادات',
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
                hintText: 'بحث في البرادات...',
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
                try {
                  // If initial state, load data
                  if (state is FridgeInitial) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<FridgeBloc>().add(LoadFridgeItems());
                    });
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is FridgeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FridgeLoaded) {
                    final filteredFridges = state.items.where((fridge) {
                      return fridge.name.toLowerCase().contains(_searchQuery.toLowerCase());
                    }).toList();

                    if (filteredFridges.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد برادات متوفرة',
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
                              try {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FridgeDetailScreen(
                                      fridgeId: fridge.id,
                                      fridgeName: fridge.name,
                                      count: fridge.quantity,
                                    ),
                                  ),
                                ).catchError((error) {
                                  print('Navigation error: $error');
                                  // Show error message to user
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('حدث خطأ في فتح تفاصيل البراد'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                });
                              } catch (e) {
                                print('Error navigating to fridge details: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('حدث خطأ في فتح تفاصيل البراد'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                                'عدد المواد: ${fridge.materials.length}',
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
                                          color: fridge.isOpen
                                              ? Colors.green.shade100
                                              : Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          fridge.isOpen ? 'مفتوح' : 'مغلق',
                                          style: TextStyle(
                                            color: fridge.isOpen
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
                                        'المواد',
                                        '${fridge.materials.length} مادة',
                                        Icons.inventory_2,
                                      ),
                                      _buildInfoColumn(
                                        'الحالة',
                                        fridge.isOpen ? 'مفتوح' : 'مغلق',
                                        Icons.circle,
                                        color: fridge.isOpen ? Colors.green : Colors.red,
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
                  return const Center(child: Text('لا توجد برادات متوفرة'));
                } catch (e) {
                  print('Error in BlocBuilder: $e');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'حدث خطأ في تحميل البيانات',
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              context.read<FridgeBloc>().add(LoadFridgeItems());
                            } catch (e) {
                              print('Error reloading: $e');
                            }
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
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              icon,
              size: 16,
              color: color ?? Colors.grey.shade600,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? const Color.fromARGB(255, 28, 98, 32),
          ),
        ),
      ],
    );
  }
}
