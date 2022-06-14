import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/projects_controller.dart';
import 'package:zeerac_flutter/modules/users/models/projects_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/projects/projects_widgets.dart';
import '../../../../common/loading_widget.dart';

class ProjectsPage extends GetView<ProjectsController> {
  const ProjectsPage({Key? key}) : super(key: key);
  static const id = '/ProjectsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<ProjectsController>(
        initState: (state) {
          print("int");
          controller.loadProjects();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                if (controller.isLoading.value == false &&
                    controller.projectsList.isEmpty)
                  Center(
                      child: Text("No Project Found",
                          style: AppTextStyles.textStyleBoldBodyMedium)),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: NotificationListener(
                    onNotification: controller.onScrollNotification,
                    child: ListView.builder(
                      itemCount: controller.projectsList.length,
                      itemBuilder: (context, index) {
                        return projectWidget(controller.projectsList[index]);
                      },
                    ),
                  ),
                ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
