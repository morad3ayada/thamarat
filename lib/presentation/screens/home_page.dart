import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/profile/profile_bloc.dart';
import '../../../logic/blocs/profile/profile_state.dart';
import '../../../logic/blocs/chat/chat_bloc.dart';
import '../../../logic/blocs/chat/chat_event.dart';
import '../../../logic/blocs/chat/chat_state.dart';
import '../../../logic/blocs/office/office_bloc.dart';
import '../../../logic/blocs/office/office_state.dart';
import 'sell/sell_page.dart' as sell;
import 'chat/chat_screen.dart';
import 'profile/profile_screen.dart';
import 'materials/materials_screen.dart';
import 'fridges/fridges_screen.dart';
import 'vendor/vendors_screen.dart';
import 'package:thamarat/presentation/app_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    FridgesScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToTab(int index) {
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32 : 8, 
          vertical: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildIcon(0, Icons.home, 'الرئيسية', isTablet),
            buildIcon(1, Icons.local_shipping, 'البرادات', isTablet),
            buildIcon(2, Icons.chat, 'الدردشة', isTablet),
            buildIcon(3, Icons.person, 'الملف الشخصي', isTablet),
          ],
        ),
      ),
    );
  }

  Widget buildIcon(int index, IconData icon, String label, bool isTablet) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1FDF0) : Colors.transparent,
          border: isSelected
              ? const Border(
                  top: BorderSide(color: Color(0xFFDAF3D7), width: 2),
                  bottom: BorderSide(color: Color(0xFFDAF3D7), width: 2),
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 10, 
          vertical: isTablet ? 12 : 6,
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isSelected ? const Color.fromARGB(255, 28, 98, 32) : Colors.grey,
              size: isTablet ? 28 : 24,
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: isTablet ? 12 : 6),
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 28, 98, 32),
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderSection(isTablet: isTablet),
          SizedBox(height: isTablet ? 32 : 20),
          SellButton(isTablet: isTablet),
          SizedBox(height: isTablet ? 32 : 20),
          MainOptions(isTablet: isTablet),
          SizedBox(height: isTablet ? 32 : 20),
          TodayVendorsSection(isTablet: isTablet),
          SizedBox(height: isTablet ? 40 : 30),
        ],
      ),
    );
  }
}

class MainOptions extends StatelessWidget {
  final bool isTablet;

  const MainOptions({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isTablet ? 48.0 : 24.0;
    final cardWidth = isTablet ? 200.0 : 150.0;
    final cardHeight = isTablet ? 240.0 : 180.0;
    final imageHeight = isTablet ? 170.0 : 130.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MaterialsScreen()),
              );
            },
            child: OptionCard(
              title: 'المواد',
              imagePath: 'assets/vegetables.png',
              imageHeight: imageHeight,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              isTablet: isTablet,
            ),
          ),
          GestureDetector(
            onTap: () {
              context
                  .findAncestorStateOfType<_HomeScreenState>()
                  ?.navigateToTab(1);
            },
            child: OptionCard(
              title: 'البرادات',
              imagePath: 'assets/truck.png',
              imageHeight: imageHeight,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              isTablet: isTablet,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double imageHeight;
  final double cardWidth;
  final double cardHeight;
  final bool isTablet;

  const OptionCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.imageHeight,
    required this.cardWidth,
    required this.cardHeight,
    required this.isTablet,
  });

  @override 
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF1FDF0),
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: imageHeight,
            fit: BoxFit.contain,
          ),
          SizedBox(height: isTablet ? 16 : 10),
          Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 28, 98, 32),
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatefulWidget {
  final bool isTablet;

  const HeaderSection({super.key, required this.isTablet});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  final TextEditingController _messageController = TextEditingController();

  void _sendQuickMessage() {
    if (_messageController.text.trim().isEmpty) return;

    context.read<ChatBloc>().add(
          SendMessage(_messageController.text.trim()),
        );
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.isTablet ? 32.0 : 16.0;
    final logoHeight = widget.isTablet ? 280.0 : 220.0;
    final avatarRadius = widget.isTablet ? 32.0 : 26.0;
    final greetingFontSize = widget.isTablet ? 28.0 : 24.0;

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessageSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إرسال الرسالة بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else if (state is MessageSendingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(milliseconds: 500),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          horizontalPadding, 
          widget.isTablet ? 60 : 50, 
          horizontalPadding, 
          widget.isTablet ? 32 : 24,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFDAF3D7),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          image: DecorationImage(
            image: const AssetImage('assets/leaves_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withValues(alpha: 0.1),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            Center(child: Image.asset('assets/logo.png', height: logoHeight)),
            BlocBuilder<OfficeBloc, OfficeState>(
              builder: (context, officeState) {
                String officeName = '';
                if (officeState is OfficeLoaded) {
                  officeName = officeState.officeInfo['name'] ?? '';
                }
                
                // Show office name if available, otherwise show a placeholder or nothing
                return officeName.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(bottom: widget.isTablet ? 8 : 4),
                        child: Text(
                          officeName,
                          style: TextStyle(
                            fontSize: widget.isTablet ? 22 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 28, 98, 32),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                String userName = 'مرحباً';
                
                if (state is ProfileLoaded) {
                  userName = 'مرحباً ${state.user.name}';
                } else if (state is ProfileLoading) {
                  userName = 'مرحباً...';
                } else if (state is ProfileError) {
                  userName = 'مرحباً';
                }
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: greetingFontSize, 
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 28, 98, 32),
                      ),
                    ),
                    SizedBox(width: widget.isTablet ? 16 : 12),
                    Container(
                      width: avatarRadius * 2,
                      height: avatarRadius * 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.store,
                        size: avatarRadius,
                        color: const Color.fromARGB(255, 28, 98, 32),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: widget.isTablet ? 20 : 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(widget.isTablet ? 16 : 12),
              ),
              padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 16 : 8),
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, chatState) {
                  return TextField(
                    controller: _messageController,
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendQuickMessage(),
                    enabled: chatState is! ChatLoading,
                    decoration: InputDecoration(
                      hintText: 'إرسال رسالة سريعة للمحاسب',
                      hintStyle: TextStyle(fontSize: widget.isTablet ? 16 : 13),
                      border: InputBorder.none,
                      prefixIcon: chatState is ChatLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: AppLoader(size: 20),
                            )
                          : GestureDetector(
                              onTap: _sendQuickMessage,
                              child: const Icon(
                                Icons.send, 
                                color: Color.fromARGB(255, 28, 98, 32),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellButton extends StatelessWidget {
  final bool isTablet;

  const SellButton({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = isTablet ? 48.0 : 24.0;
    final verticalPadding = isTablet ? 18.0 : 14.0;
    final fontSize = isTablet ? 22.0 : 18.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const sell.SellPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 28, 98, 32),
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
          ),
        ),
        child: Text(
          'القيام بعملية بيع',
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TodayVendorsSection extends StatelessWidget {
  final bool isTablet;

  const TodayVendorsSection({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = isTablet ? 48.0 : 24.0;
    final padding = isTablet ? 24.0 : 16.0;
    final imageHeight = isTablet ? 200.0 : 150.0;
    final fontSize = isTablet ? 22.0 : 18.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VendorsScreen(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: const Color(0xFFF1FDF0),
          borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset('assets/vendor.png', height: imageHeight),
            SizedBox(height: isTablet ? 24 : 20),
            Text(
              '  المتسوقين اليوم ',
              style: TextStyle(
                fontSize: fontSize, 
                fontWeight: FontWeight.bold, 
                color: const Color.fromARGB(255, 28, 98, 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
