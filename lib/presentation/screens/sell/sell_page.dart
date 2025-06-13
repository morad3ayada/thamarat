import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/sell/sell_bloc.dart';
import '../../../logic/blocs/sell/sell_event.dart';
import '../../../logic/blocs/sell/sell_state.dart';
import '../../../data/models/sell_model.dart';
import 'add_material_page.dart';
import 'sell_details_page.dart';

class Customer {
  final String name;
  final String phone;
  Customer({required this.name, required this.phone});
}

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
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
    context.read<SellBloc>().add(LoadSellProcesses());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetails(SellModel sell) {
    context.read<SellBloc>().add(LoadSellDetails(sell.id));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<SellBloc>(),
          child: const SellDetailsPage(),
        ),
      ),
    );
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
        }
      },
      builder: (context, state) {
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
                          'البيع',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 28, 98, 32),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<SellBloc>(),
                              child: const AddMaterialPage(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color.fromARGB(255, 28, 98, 32),
                        size: 28,
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
                    hintText: 'بحث في عمليات البيع...',
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
                child: state is SellLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 28, 98, 32),
                        ),
                      )
                    : state is SellLoaded
                        ? _buildSellList(state.items)
                        : state is SellError
                            ? Center(
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
                                        context.read<SellBloc>().add(LoadSellProcesses());
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
                              )
                            : const Center(
                                child: Text(
                                  'لا توجد عمليات بيع',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSellList(List<SellModel> sells) {
    final filteredSells = _searchQuery.isEmpty
        ? sells
        : sells.where((sell) {
            final customerName = sell.customerName.toLowerCase();
            final customerPhone = sell.customerPhone.toLowerCase();
            final materialName = sell.materialName.toLowerCase();
            final query = _searchQuery.toLowerCase();
            return customerName.contains(query) ||
                customerPhone.contains(query) ||
                materialName.contains(query);
          }).toList();

    if (filteredSells.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد نتائج للبحث',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<SellBloc>().add(LoadSellProcesses());
      },
      color: const Color.fromARGB(255, 28, 98, 32),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredSells.length,
        itemBuilder: (context, index) {
          final sell = filteredSells[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                sell.customerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 28, 98, 32),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'رقم الهاتف: ${sell.customerPhone}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'المادة: ${sell.materialName}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'المبلغ: ${sell.totalPrice} ريال',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 28, 98, 32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'التاريخ: ${sell.date.toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (sell.status == 'pending')
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Text(
                        'في انتظار التأكيد',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 28, 98, 32),
                size: 16,
              ),
              onTap: () => _navigateToDetails(sell),
            ),
          );
        },
      ),
    );
  }
}