import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveactivity/PollController.dart';

import 'Poll.dart';

class PollScreen extends GetView<PollController> {
  const PollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PollController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Polls'),
      ),
      body: Obx(() {
        if (controller.polls.isEmpty) {
          // create poll
          return ElevatedButton(
            onPressed: () {
              controller.createVote(
                'What is your favorite programming language?',
                ['Dart', 'Kotlin', 'Swift', 'Java'],
              );
            },
            child: const Text('Create Poll'),
          );

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                controller.startWorkout('Running', '5K');
              },
              child: const Text('Start Workout'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.stopWorkout();
              },
              child: const Text('Stop Workout'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateWorkout(
                  120,
                  5000,
                  300,
                  30.0,
                  0.6,
                );
              },
              child: const Text('Update Workout'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.createVote(
                  'What is your favorite programming language?',
                  ['Dart', 'Kotlin', 'Swift', 'Java'],
                );
              },
              child: const Text('Create Poll'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.polls.length,
                itemBuilder: (context, index) {
                  final poll = controller.polls[index];
                  return PollWidget(poll: poll);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class PollWidget extends GetView<PollController> {
  final Poll poll;
  const PollWidget({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    final PollController pollController = Get.find();

    return Card(
      child: Column(
        children: [
          Text(
            poll.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          ...poll.options.asMap().entries.map((entry) {
            final optionIndex = entry.key;
            final optionText = entry.value;
            return ListTile(
              title: Text(optionText),
              trailing: Text(
                poll.votes[optionIndex].toString(),
              ),
              onTap: () => pollController.updateVote(
                poll.id,
                optionIndex,
              ),
            );
          }),
        ],
      ),
    );
  }
}
