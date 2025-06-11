import 'package:flutter/material.dart';
import 'fridge_detail_screen.dart';

class FridgesScreen extends StatelessWidget {
  const FridgesScreen({super.key});

  final List<Map<String, dynamic>> fridges = const [
    {'name': 'براد رقم 1', 'date': '8-12-2024', 'count': 500},
    {'name': 'براد رقم 2', 'date': '8-12-2024', 'count': 450},
    {'name': 'براد رقم 3', 'date': '8-12-2024', 'count': 520},
    {'name': 'براد رقم 4', 'date': '8-12-2024', 'count': 470},
    {'name': 'براد رقم 5', 'date': '8-12-2024', 'count': 510},
    {'name': 'براد رقم 6', 'date': '8-12-2024', 'count': 530},
    {'name': 'براد رقم 7', 'date': '8-12-2024', 'count': 490},
    {'name': 'براد رقم 8', 'date': '8-12-2024', 'count': 500},
  ];

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 24),
                const Text(
                  'البرادات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 , color:const Color.fromARGB(255, 28, 98, 32)),
                ),
            
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: fridges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final fridge = fridges[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FridgeDetailScreen(
                            fridgeName: fridge['name'],
                            count: fridge['count'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.green.shade100),
                        image: const DecorationImage(
                          image: AssetImage('assets/leave.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.white70,
                            BlendMode.lighten,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
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
            ),
          ),
        ],
      ),
    );
  }
}
