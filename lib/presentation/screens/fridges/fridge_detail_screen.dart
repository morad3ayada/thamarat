import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/fridge/fridge_bloc.dart';
import '../../../logic/blocs/fridge/fridge_event.dart';
import '../../../logic/blocs/fridge/fridge_state.dart';

class FridgeDetailScreen extends StatefulWidget {
  final String fridgeId;
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
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    context.read<FridgeBloc>().add(LoadFridgeDetails(widget.fridgeId));
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
                  onPressed: () => Navigator.pop(context),
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
                        'عدد المواد: ${widget.count}',
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
                if (state is FridgeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FridgeDetailsLoaded) {
                  final materials = state.fridge['materials'] as List;
                  final filteredMaterials = materials.where((material) {
                    return material['name']
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            child: Icon(
                              _getMaterialIcon(material['name']),
                              color: const Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          title: Text(
                            material['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                          subtitle: Text(
                            '${material['quantity']} - ${material['price']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(material['type'])
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getTypeColor(material['type'])
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              material['type'],
                              style: TextStyle(
                                color: _getTypeColor(material['type']),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is FridgeError) {
                  return Center(
                    child: Text(
                      'حدث خطأ: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(child: Text('لا توجد مواد'));
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMaterialIcon(String materialName) {
    switch (materialName.toLowerCase()) {
      case 'طماطم':
        return Icons.grass;
      case 'تفاح':
        return Icons.apple;
      case 'خيار':
        return Icons.eco;
      case 'موز':
        return Icons.forest;
      case 'فريز':
        return Icons.icecream;
      case 'باذنجان':
        return Icons.eco;
      default:
        return Icons.shopping_basket;
    }
  }

  Color _getTypeColor(String type) {
    if (type.contains('صافي')) {
      return const Color.fromARGB(255, 28, 98, 32);
    } else if (type.contains('خابط')) {
      return Colors.orange;
    }
    return Colors.grey;
  }
}