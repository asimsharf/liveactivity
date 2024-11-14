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
        return ListView.builder(
          itemCount: controller.polls.length,
          itemBuilder: (context, index) {
            final poll = controller.polls[index];
            return PollWidget(poll: poll);
          },
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
