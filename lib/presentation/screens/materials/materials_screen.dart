import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/materials/materials_bloc.dart';
import '../../../logic/blocs/materials/materials_event.dart';
import '../../../logic/blocs/materials/materials_state.dart';
import '../../../data/models/materials_model.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  int expandedIndex = -1;
  final TextEditingController _searchController = TextEditingController();
  final Color primaryColor = const Color(0xFFDAF3D7);

  @override
  void initState() {
    super.initState();
    context.read<MaterialsBloc>().add(LoadMaterials());
    _searchController.addListener(_filterMaterials);
  }

  void _filterMaterials() {
    final query = _searchController.text;
    context.read<MaterialsBloc>().add(SearchMaterials(query));
    setState(() {
      expandedIndex = -1;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getMaterialIcon(String name) {
    switch (name.toLowerCase()) {
      case 'طماطم':
        return Icons.egg_outlined;
      case 'تفاح':
        return Icons.apple;
      case 'خيار':
        return Icons.grass;
      case 'موز':
        return Icons.food_bank_outlined;
      case 'باذنجان':
        return Icons.eco_outlined;
      case 'فريز':
        return Icons.local_florist_outlined;
      default:
        return Icons.shopping_basket_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MaterialsBloc, MaterialsState>(
      listener: (context, state) {
        if (state is MaterialsError) {
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
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
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
                      if (state is MaterialsLoaded)
                        Text(
                          '${state.materials.length} مواد',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
                      hintText: 'ابحث عن المادة',
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
                  ),
                ),

                // Materials List
                if (state is MaterialsLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 28, 98, 32),
                      ),
                    ),
                  )
                else if (state is MaterialsLoaded)
                  Expanded(
                    child: state.materials.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد مواد',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.materials.length,
                            itemBuilder: (context, index) {
                              final material = state.materials[index];
                              final isExpanded = expandedIndex == index;
                              final typeColor = material.type.contains('صافي')
                                  ? const Color.fromARGB(255, 28, 98, 32)
                                  : Colors.orange;

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
                                            ? Color.fromRGBO(218, 243, 215, 0.5)
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
                                              Icon(
                                                _getMaterialIcon(material.name),
                                                color: const Color.fromARGB(255, 28, 98, 32),
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                material.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                    typeColor.red,
                                                    typeColor.green,
                                                    typeColor.blue,
                                                    0.1,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                      typeColor.red,
                                                      typeColor.green,
                                                      typeColor.blue,
                                                      0.3,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  material.type,
                                                  style: TextStyle(
                                                    color: typeColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                isExpanded
                                                    ? Icons.keyboard_arrow_up_rounded
                                                    : Icons.keyboard_arrow_down_rounded,
                                                size: 28,
                                                color: const Color.fromARGB(255, 28, 98, 32),
                                              ),
                                            ],
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
                                        color: Color.fromRGBO(218, 243, 215, 0.3),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xFFDAF3D7),
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // Type Row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'النوع:',
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                material.type,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          // Source Row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'المصدر:',
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                material.source,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          // Quantity Row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'الكمية:',
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                material.quantity,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          // Price Row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'السعر:',
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                material.price,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(255, 28, 98, 32),
                                                ),
                                              ),
                                            ],
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