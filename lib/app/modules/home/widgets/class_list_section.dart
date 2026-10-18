import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../models/class_data.dart' as model;
import 'class_card.dart';
import '../../../utils/app_size.dart';
import '../../../utils/duration_formatter.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class ClassListSection extends StatelessWidget {
  const ClassListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final classes = controller.allClasses;

      if (!isLoading && classes.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Text(
              'No Classes Found',
              style: TextStyle(color: const Color(0xFF6B5345), fontSize: 16.sp),
            ),
          ),
        );
      }

      final displayList = isLoading
          ? List.generate(
              3,
              (index) => model.ClassModel(
                title: 'Hatha Yoga Flow',
                description: 'Mock Description',
                type: 'CLASS',
                duration: '60 Mins',
                scheduledAt: DateTime.now(),
                maxParticipants: 20,
                isFree: false,
                id: 'mock_$index',
                status: 'ACTIVE',
                courseId: '',
                instructorId: '',
                order: index,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                bookedSeats: 12,
                availableSeats: 8,
                difficulty: 'All Levels',
                gender: 'Both',
                price: 75.0,
                location: 'Main Studio',
                locationMapLink: '',
                phone: '+974 5550 5301',
                instructor: model.Instructor(
                  id: 'mock_inst',
                  name: 'Jane Doe',
                  email: 'jane@example.com',
                ),
              ),
            )
          : classes;

      return Skeletonizer(
        enabled: isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              ListView.builder(
                itemCount: displayList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final classItem = displayList[index];
                  final title = classItem.title;
                  final difficulity = classItem.difficulty;
                  final rawPrice =
                      classItem.coverageType?.toLowerCase() == 'membership'
                      ? (classItem.effectivePrice ?? 0.0)
                      : classItem.price;
                  final price = rawPrice % 1 == 0
                      ? rawPrice.toInt().toString()
                      : rawPrice.toStringAsFixed(1);
                  final instructorName = classItem.instructor.name;
                  final instructorImage = classItem.instructor.avatar;
                  final availableSeats = classItem.availableSeats;
                  final maxParticipants = classItem.maxParticipants;
                  final bookedSeats = maxParticipants - availableSeats;
                  final progress = maxParticipants > 0
                      ? (bookedSeats / maxParticipants)
                      : 0.0;
                  final status = classItem.status;
                  final classId = classItem.id;
                  final gender = classItem.gender;
                  if (!isLoading) {
                    controller.allInstructor.add(instructorName);
                    controller.allClassName.add(title);
                  }
                  return ClassCard(
                    badge: difficulity,
                    image:
                        instructorImage ?? 'https://i.pravatar.cc/150?img=32',
                    title: title,
                    price: 'QAR $price',
                    time: formatClassTimeRange(
                      classItem.scheduledAt,
                      classItem.duration,
                    ),
                    instructor: instructorName,
                    status: status,
                    availableSeats: availableSeats,
                    isMembershipPaid: rawPrice == 0.0,
                    progress: progress,
                    classId: classId,
                    gender: gender,
                    isBooked: controller.bookedClassIds.contains(classId),
                  );
                },
              ),
              if (!isLoading && controller.isLoadingMore.value)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6B5345)),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
