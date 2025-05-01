import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_meal/data/dummy_data.dart';
import 'package:flutter_meal/models/category.dart';
import 'package:flutter_meal/services/navigation.dart';
import 'package:flutter_meal/widgets/category_grid_item.dart';

class HomeCategoriesTab extends StatefulWidget {
  const HomeCategoriesTab({super.key});

  @override
  State<HomeCategoriesTab> createState() => _HomeCategoriesTabState();
}

class _HomeCategoriesTabState extends State<HomeCategoriesTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final nav = Provider.of<NavigationService>(context, listen: false);
    nav.goMealsOnCategory(categoryId: category.id);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(
        begin: const Offset(0, 0.7),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: dummyCategories.length,
        itemBuilder: (context, index) {
          final category = dummyCategories.values.elementAt(index);

          int rowIndex = index ~/ 2;

          return TweenAnimationBuilder(
            key: ValueKey(category.id),
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 500 + rowIndex * 200),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: CategoryGridItem(
                    category: category,
                    onSelectCategory: () {
                      _selectCategory(context, category);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
