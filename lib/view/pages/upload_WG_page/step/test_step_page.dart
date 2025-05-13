import 'package:flutter/material.dart';
import 'package:fmsproject/view/pages/upload_WG_page/upload_wg_page_view_model.dart';
import 'package:provider/provider.dart';

class PropertyTypeStep extends StatelessWidget {
  final List<Map<String, dynamic>> _propertyTypes = [
    {'icon': Icons.house, 'name': '아파트'},
    {'icon': Icons.villa, 'name': '주택'},
    {'icon': Icons.apartment, 'name': '펜션'},
    {'icon': Icons.hotel, 'name': '호텔'},
    {'icon': Icons.cabin, 'name': '게스트하우스'},
    {'icon': Icons.other_houses, 'name': '한옥'},
  ];

  final List<String> _propertyCategories = [
    '전체 공간',
    '개인실',
    '다인실',
  ];

  PropertyTypeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UploadWGPageViewModel>();
    final state = viewModel.state;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '어떤 유형의 숙소인가요?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            '숙소 유형',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: _propertyTypes.length,
            itemBuilder: (context, index) {
              final type = _propertyTypes[index];
              final isSelected = state.wgData.title == type['name'];

              return InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.red : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type['icon'],
                        size: 32,
                        color: isSelected ? Colors.red : Colors.black,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        type['name'],
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.red : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            '숙소 카테고리',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _propertyCategories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = _propertyCategories[index];
              final isSelected = state.wgData.address == category;

              return InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.red : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Colors.red),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
