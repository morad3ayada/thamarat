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

  void _retryLoad() {
    context.read<MaterialsBloc>().add(LoadMaterials());
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
      case 'بطاطس':
        return Icons.grass;
      case 'جزر':
        return Icons.eco_outlined;
      case 'بصل':
        return Icons.eco_outlined;
      case 'ثوم':
        return Icons.eco_outlined;
      default:
        return Icons.shopping_basket_outlined;
    }
  }

  Color _getMaterialTypeColor(String materialType) {
    switch (materialType) {
      case 'consignment':
        return const Color.fromARGB(255, 28, 98, 32); // أخضر للصافي
      case 'markup':
        return Colors.orange; // برتقالي للربح
      case 'spoiledConsignment':
        return Colors.red; // أحمر للصافي التالف
      case 'spoiledMarkup':
        return Colors.deepOrange; // برتقالي داكن للربح التالف
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatisticsCard(List<MaterialsModel> materials) {
    final consignmentCount = materials.where((m) => m.materialType == 'consignment').length;
    final markupCount = materials.where((m) => m.materialType == 'markup').length;
    final spoiledCount = materials.where((m) => m.materialType.contains('spoiled')).length;
    final uniqueTrucks = materials.map((m) => m.truckName).where((name) => name != null).toSet().length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إحصائيات المواد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 28, 98, 32),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('صافي', consignmentCount, const Color.fromARGB(255, 28, 98, 32)),
              ),
              Expanded(
                child: _buildStatItem('ربح', markupCount, Colors.orange),
              ),
              Expanded(
                child: _buildStatItem('تالف', spoiledCount, Colors.red),
              ),
              Expanded(
                child: _buildStatItem('شاحنات', uniqueTrucks, Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
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
              action: SnackBarAction(
                label: 'إعادة المحاولة',
                textColor: Colors.white,
                onPressed: _retryLoad,
              ),
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
                            'المواد المتوفرة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                        ],
                      ),
                      if (state is MaterialsLoaded)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${state.materials.length} مادة',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 28, 98, 32),
                            ),
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
                      hintText: 'ابحث عن المادة أو المصدر...',
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

                // Statistics Card (only show when materials are loaded and not searching)
                if (state is MaterialsLoaded && _searchController.text.isEmpty)
                  _buildStatisticsCard(state.materials),

                // Materials List
                if (state is MaterialsLoading)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color.fromARGB(255, 28, 98, 32),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'جاري تحميل المواد...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is MaterialsError)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _retryLoad,
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text(
                              'إعادة المحاولة',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is MaterialsLoaded)
                  Expanded(
                    child: state.materials.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'لا توجد مواد متوفرة',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.materials.length,
                            itemBuilder: (context, index) {
                              final material = state.materials[index];
                              final isExpanded = expandedIndex == index;
                              final typeColor = _getMaterialTypeColor(material.materialType);

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
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: typeColor.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    _getMaterialIcon(material.name),
                                                    color: typeColor,
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
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Color.fromARGB(255, 28, 98, 32),
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        material.source,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: typeColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: typeColor.withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Text(
                                                  material.displayType,
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
                                          _buildInfoRow('النوع:', material.displayType, typeColor),
                                          const SizedBox(height: 12),
                                          // Source Row
                                          _buildInfoRow('المصدر:', material.source, typeColor),
                                          const SizedBox(height: 12),
                                          // Measurement Type Row
                                          _buildInfoRow('نوع القياس:', material.isQuantity ? 'كمية' : 'وزن', typeColor),
                                          const SizedBox(height: 12),
                                          // Order Row
                                          _buildInfoRow('الترتيب:', material.order.toString(), typeColor),
                                          const SizedBox(height: 12),
                                          // Material Type Row
                                          _buildInfoRow('نوع المادة:', material.materialType, typeColor),
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
                        'حدث خطأ في تحميل المواد',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
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

  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 28, 98, 32),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}