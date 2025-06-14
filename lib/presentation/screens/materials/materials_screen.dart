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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalMargin = isTablet ? 32.0 : 16.0;
    final padding = isTablet ? 24.0 : 16.0;
    final titleFontSize = isTablet ? 20.0 : 16.0;
    final statFontSize = isTablet ? 22.0 : 18.0;
    final labelFontSize = isTablet ? 14.0 : 12.0;

    final consignmentCount = materials.where((m) => m.materialType == 'consignment').length;
    final markupCount = materials.where((m) => m.materialType == 'markup').length;
    final spoiledCount = materials.where((m) => m.materialType.contains('spoiled')).length;
    final uniqueTrucks = materials.map((m) => m.truckName).where((name) => name != null).toSet().length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: isTablet ? 12 : 8),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
          Text(
            'إحصائيات المواد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
              color: const Color.fromARGB(255, 28, 98, 32),
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('صافي', consignmentCount, const Color.fromARGB(255, 28, 98, 32), isTablet, statFontSize, labelFontSize),
              ),
              Expanded(
                child: _buildStatItem('ربح', markupCount, Colors.orange, isTablet, statFontSize, labelFontSize),
              ),
              Expanded(
                child: _buildStatItem('تالف', spoiledCount, Colors.red, isTablet, statFontSize, labelFontSize),
              ),
              Expanded(
                child: _buildStatItem('شاحنات', uniqueTrucks, Colors.blue, isTablet, statFontSize, labelFontSize),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color, bool isTablet, double statFontSize, double labelFontSize) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isTablet ? 12 : 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: statFontSize,
              color: color,
            ),
          ),
        ),
        SizedBox(height: isTablet ? 6 : 4),
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final headerHeight = isTablet ? 140.0 : 120.0;
    final horizontalPadding = isTablet ? 32.0 : 16.0;

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
                  height: headerHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: isTablet ? 55 : 45, 
                    right: horizontalPadding, 
                    left: horizontalPadding,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: const Color.fromARGB(255, 28, 98, 32),
                          size: isTablet ? 28 : 24,
                        ),
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      Text(
                        'المواد',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 24 : 20,
                          color: const Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Box
                Padding(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: TextField(
                    controller: _searchController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن المادة أو المصدر...',
                      hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      prefixIcon: Icon(
                        Icons.search, 
                        color: const Color.fromARGB(255, 28, 98, 32),
                        size: isTablet ? 24 : 20,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isTablet ? 16 : 12, 
                        horizontal: isTablet ? 20 : 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: isTablet ? 24 : 16, 
                                          vertical: isTablet ? 18 : 14),
                                      margin: EdgeInsets.symmetric(vertical: isTablet ? 8 : 6),
                                      decoration: BoxDecoration(
                                        color: isExpanded
                                            ? Color.fromRGBO(218, 243, 215, 0.5)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
                                                  padding: EdgeInsets.all(isTablet ? 12 : 8),
                                                  decoration: BoxDecoration(
                                                    color: typeColor.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                                                  ),
                                                  child: Icon(
                                                    _getMaterialIcon(material.name),
                                                    color: typeColor,
                                                    size: isTablet ? 24 : 20,
                                                  ),
                                                ),
                                                SizedBox(width: isTablet ? 16 : 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        material.name,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: isTablet ? 18 : 16,
                                                          color: const Color.fromARGB(255, 28, 98, 32),
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(height: isTablet ? 6 : 4),
                                                      Text(
                                                        material.source,
                                                        style: TextStyle(
                                                          fontSize: isTablet ? 14 : 12,
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: isTablet ? 12 : 8, 
                                                    vertical: isTablet ? 6 : 4),
                                                decoration: BoxDecoration(
                                                  color: typeColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                                                  border: Border.all(
                                                    color: typeColor.withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Text(
                                                  material.displayType,
                                                  style: TextStyle(
                                                    color: typeColor,
                                                    fontSize: isTablet ? 14 : 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: isTablet ? 12 : 8),
                                              Icon(
                                                isExpanded
                                                    ? Icons.keyboard_arrow_up_rounded
                                                    : Icons.keyboard_arrow_down_rounded,
                                                size: isTablet ? 32 : 28,
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
                                      margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
                                      padding: EdgeInsets.all(isTablet ? 24 : 16),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(218, 243, 215, 0.3),
                                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
                                          _buildInfoRow('النوع:', material.displayType, typeColor, isTablet),
                                          SizedBox(height: isTablet ? 16 : 12),
                                          // Source Row
                                          _buildInfoRow('المصدر:', material.source, typeColor, isTablet),
                                          SizedBox(height: isTablet ? 16 : 12),
                                          // Measurement Type Row
                                          _buildInfoRow('نوع القياس:', material.isQuantity ? 'كمية' : 'وزن', typeColor, isTablet),
                                          SizedBox(height: isTablet ? 16 : 12),
                                          // Order Row
                                          _buildInfoRow('الترتيب:', material.order.toString(), typeColor, isTablet),
                                          SizedBox(height: isTablet ? 16 : 12),
                                          // Material Type Row
                                          _buildInfoRow('نوع المادة:', material.materialType, typeColor, isTablet),
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

  Widget _buildInfoRow(String label, String value, Color color, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color.fromARGB(255, 28, 98, 32),
            fontSize: isTablet ? 16 : 14,
          ),
        ),
        SizedBox(width: isTablet ? 12 : 8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 12 : 8, 
            vertical: isTablet ? 6 : 4,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isTablet ? 8 : 6),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 16 : 14,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}