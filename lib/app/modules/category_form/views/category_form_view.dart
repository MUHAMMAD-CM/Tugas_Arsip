import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/category_form_controller.dart';

class CategoryFormView extends GetView<CategoryFormController> {
  const CategoryFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CategoryFormView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CategoryFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
