import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/materials/materials_bloc.dart';
import '../../../logic/blocs/materials/materials_event.dart';
import '../../../logic/blocs/materials/materials_state.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
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
    context.read<MaterialsBloc>().add(LoadMaterials());
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
                      'المواد',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 28, 98, 32),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<MaterialsBloc, MaterialsState>(
                  builder: (context, state) {
                    if (state is MaterialsLoaded) {
                      return Text(
                        '${state.materials.length} مواد',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 28, 98, 32),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
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
                              _getMaterialIcon(material.name),
                              color: const Color.fromARGB(255, 28, 98, 32),
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
                            '${material.unit} - ${material.price} دينار',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor(material.type)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getTypeColor(material.type)
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              material.type,
                              style: TextStyle(
                                color: _getTypeColor(material.type),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                return const Center(child: Text('لا توجد مواد'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add material screen
        },
        backgroundColor: const Color.fromARGB(255, 28, 98, 32),
        child: const Icon(Icons.add),
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