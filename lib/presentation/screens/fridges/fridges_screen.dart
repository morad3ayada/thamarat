import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/fridge/fridge_bloc.dart';
import '../../../logic/blocs/fridge/fridge_event.dart';
import '../../../logic/blocs/fridge/fridge_state.dart';
import 'fridge_detail_screen.dart';

class FridgesScreen extends StatelessWidget {
  const FridgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FridgeBloc(context.read())..add(LoadFridges()),
      child: BlocBuilder<FridgeBloc, FridgeState>(
        builder: (context, state) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 24),
                      const Text(
                        'البرادات',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildFridgesList(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFridgesList(BuildContext context, FridgeState state) {
    if (state is FridgeLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is FridgesLoaded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          itemCount: state.fridges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) {
            final fridge = state.fridges[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FridgeDetailScreen(
                      fridgeId: fridge['id'],
                      fridgeName: fridge['name'],
                      count: fridge['count'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.green.shade100,
                        child: Text(
                          fridge['count'].toString(),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 28, 98, 32),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fridge['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 28, 98, 32),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        fridge['date'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else if (state is FridgeError) {
      return Center(
        child: Text(
          'حدث خطأ: ${state.message}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return const Center(child: Text('لا توجد برادات'));
  }
}
