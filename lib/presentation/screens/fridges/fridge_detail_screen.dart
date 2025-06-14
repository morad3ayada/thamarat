import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/fridge/fridge_bloc.dart';
import '../../../logic/blocs/fridge/fridge_event.dart';
import '../../../logic/blocs/fridge/fridge_state.dart';
import '../../../data/models/fridge_model.dart';

class FridgeDetailScreen extends StatefulWidget {
  final int fridgeId;
  final String fridgeName;
  final int count;

  const FridgeDetailScreen({
    super.key,
    required this.fridgeId,
    required this.fridgeName,
    required this.count,
  });

  @override
  State<FridgeDetailScreen> createState() => _FridgeDetailScreenState();
}

class _FridgeDetailScreenState extends State<FridgeDetailScreen> {
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
      // Load fridge details with error handling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          context.read<FridgeBloc>().add(LoadFridgeDetails(widget.fridgeId));
        } catch (e) {
          print('Error loading fridge details in initState: $e');
        }
      });
    } catch (e) {
      print('Error in initState: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when dependencies change
    try {
      final currentState = context.read<FridgeBloc>().state;
      if (currentState is! FridgeLoading) {
        context.read<FridgeBloc>().add(LoadFridgeDetails(widget.fridgeId));
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
    try {
      super.dispose();
    } catch (e) {
      print('Error in super.dispose(): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFFDAF3D7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    try {
                      // Navigate back to home tab to avoid errors
                      Navigator.of(context).pushReplacementNamed('/home');
                    } catch (e) {
                      print('Error navigating back: $e');
                      // Fallback navigation to home tab
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  },
                  color: const Color.fromARGB(255, 28, 98, 32),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fridgeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                      Text(
                        'الكمية: ${widget.count}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
          Expanded(
            child: BlocBuilder<FridgeBloc, FridgeState>(
              builder: (context, state) {
                try {
                  // If initial state, load data
                  if (state is FridgeInitial) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      try {
                        context.read<FridgeBloc>().add(LoadFridgeDetails(widget.fridgeId));
                      } catch (e) {
                        print('Error loading details in BlocBuilder: $e');
                      }
                    });
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is FridgeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FridgeDetailsLoaded) {
                    final fridge = state.fridge;
                    final filteredMaterials = fridge.materials.where((material) {
                      return material.name.toLowerCase().contains(_searchQuery.toLowerCase());
                    }).toList();

                    return Column(
                        children: [
                          // معلومات البراد
                          Card(
                            elevation: 2,
                          margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.kitchen,
                                          color: Color.fromARGB(255, 28, 98, 32),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fridge.name,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(255, 28, 98, 32),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                            'عدد المواد: ${fridge.materials.length}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // قائمة المواد
                        Expanded(
                          child: filteredMaterials.isEmpty
                              ? const Center(
                                  child: Text(
                                    'لا توجد مواد متوفرة',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: filteredMaterials.length,
                                  itemBuilder: (context, index) {
                                    final material = filteredMaterials[index];
                                    return Card(
                                      elevation: 2,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: material.materialType == 'consignment'
                                                    ? Colors.blue.shade100
                                                    : Colors.orange.shade100,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                material.materialType == 'consignment'
                                                    ? Icons.inventory
                                                    : Icons.shopping_cart,
                                                color: material.materialType == 'consignment'
                                                    ? Colors.blue.shade700
                                                    : Colors.orange.shade700,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    material.name,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    material.materialType == 'consignment'
                                                        ? 'مادة بالعمولة'
                                                        : 'مادة بالربح',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: material.isQuantity
                                                    ? Colors.green.shade100
                                                    : Colors.purple.shade100,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                material.isQuantity ? 'كمية' : 'وزن',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: material.isQuantity
                                                      ? Colors.green.shade700
                                                      : Colors.purple.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
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
                              context.read<FridgeBloc>().add(LoadFridgeDetails(widget.fridgeId));
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
                  return const Center(child: Text('لا توجد بيانات'));
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
                              Navigator.of(context).pop();
                            } catch (e) {
                              Navigator.of(context).pushReplacementNamed('/home');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('العودة'),
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
}