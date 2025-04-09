import 'package:auto_route/auto_route.dart';
import 'dart:io';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart'; // Chat UI library for image bubbles.
import 'package:chat_bubbles/bubbles/bubble_special_two.dart'; // Chat UI library for text bubbles.
import 'package:chat_bubbles/message_bars/message_bar.dart'; // UI for message input.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:byday/src/auth/models/custom_user_model.dart'; // Updated for By Day branding.
import 'package:byday/src/chat/models/message_model.dart'; // Chat message model.
import 'package:byday/src/chat/providers/get_message_provider.dart'; // Provider for fetching messages.
import 'package:byday/src/chat/providers/send_message_provider.dart'; // Provider for sending messages.
import 'package:byday/src/core/assets/assets.gen.dart'; // App assets.
import 'package:byday/src/core/constant/app_constant.dart'; // Constants for Firestore collections.
import 'package:byday/src/core/extensions/context_extension.dart'; // Context extensions.
import 'package:byday/src/core/extensions/extensions.dart'; // Utility extensions for padding, margin, etc.
import 'package:byday/src/core/providers/firbease_provider.dart'; // Firebase dependency injection.
import 'package:byday/src/core/theme/app_colors.dart'; // App color palette.
import 'package:byday/src/core/theme/app_styles.dart'; // App typography styles.
import 'package:byday/src/core/widgets/widgets.dart'; // Common reusable widgets.
import 'package:hooks_riverpod/hooks_riverpod.dart'; // State management with Riverpod.
import 'package:image_picker/image_picker.dart'; // Image picker utility for file selection.

/// ChatDetailView serves as the UI for customer service conversations.
/// Communication is strictly limited to:
/// - Client ↔ Customer Service.
/// - Artisan ↔ Customer Service.
@RoutePage()
class ChatDetailView extends StatefulHookConsumerWidget {
  const ChatDetailView({
    Key? key,
    required this.roomId,
    required this.isArtisan,
    this.product,
    this.artisan,
    this.client,
  }) : super(key: key);

  final String roomId; // Room ID for the chat session.
  final CustomUserModel? client; // Information about the client (if applicable).
  final CustomUserModel? artisan; // Information about the artisan (if applicable).
  final bool isArtisan; // Boolean flag to identify artisan context.
  final ProductModel? product; // Product details associated with the conversation (optional).

  @override
  _ChatDetailViewState createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends ConsumerState<ChatDetailView> {
  late TextEditingController messageController; // Controller for the message input field.

  final ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null); // Tracks selected images.

  String get roomId => widget.roomId; // Retrieves the room ID.
  bool get isArtisan => widget.isArtisan; // Checks if the context is artisan-based.
  String? get userId => ref.read(firebaseAuthProvider).currentUser?.uid; // Retrieves the current user ID.

  @override
  void initState() {
    messageController = TextEditingController(); // Initializes the message input controller.
    super.initState();
  }

  @override
  void dispose() {
    ref.invalidate(getMessagesNotifierProvider); // Invalidates the message provider on disposal.
    messageController.dispose(); // Disposes of the message controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      appBar: AppBar(
        title: Row(
          children: [
            GradientCircle(
              radius: 40.r,
              showGradient: true,
              child: CacheImageViewer(
                error: (context, url, error) =>
                    Assets.images.userAvatar.image(fit: BoxFit.cover), // Placeholder image.
              ),
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product?.name ?? '',
                  style: AppStyles.text18PxBold,
                ), // Displays product name (if available).
                Text(
                  '${isArtisan ? widget.client?.name ?? '' : widget.artisan?.name ?? ''}',
                  style: AppStyles.text12PxMedium.midGrey,
                ), // Displays client/artisan name.
              ],
            ).expanded(),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Consumer(
                builder: (context, ref, _) {
                  return ref
                      .watch(getMessagesNotifierProvider(roomId))
                      .maybeWhen(
                        orElse: () => Container().expanded(),
                        loading: () => context.loader.expanded(),
                        success: (messages) {
                          if (messages.isEmpty) {
                            return SizedBox(
                              child: NoDataFound(
                                title:
                                    'Start Conversation with ${isArtisan ? widget.client?.name : widget.artisan?.name}',
                                onRefresh: () {
                                  ref.refresh(getMessagesNotifierProvider(roomId)); // Refresh messages.
                                },
                              ),
                            ).expanded();
                          }
                          return ListView.builder(
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              if (message.type == MessageType.image) {
                                return BubbleNormalImage(
                                  isSender: userId == message.senderId,
                                  id: message.id,
                                  image: CacheImageViewer(
                                    imageUrl: message.imageUrl!,
                                  ),
                                );
                              }
                              return BubbleSpecialTwo(
                                text: message.message ?? '',
                                isSender: userId == message.senderId,
                                tail: true,
                                color: userId == message.senderId
                                    ? AppColors.primaryColor
                                    : const Color(0xFFE8E8EE),
                                textStyle: userId == message.senderId
                                    ? AppStyles.text14PxRegular.white
                                    : const TextStyle(),
                              ).px(10).py(10);
                            },
                          ).expanded();
                        },
                      );
                },
              ),
              MessageBar(
                onSend: (messageText) {
                  final now = DateTime.now().millisecondsSinceEpoch;
                  ref.read(sendMessageNotifierProvider.notifier).sendMessage(
                        message: MessageModel(
                          id: '',
                          userId: widget.client?.uid ?? '',
                          artisanId: widget.artisan?.uid ?? '',
                          type: selectedImage.value != null
                              ? MessageType.image
                              : MessageType.text,
                          roomId: roomId,
                          message: messageText,
                          senderId: userId!,
                          updatedAt: now,
                        ),
                      );
                },
                sendButtonColor: AppColors.primaryColor,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                        size: 24,
                      ),
                      onTap: () async {
                        final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (pickedImage?.path != null) {
                          final now = DateTime.now().millisecondsSinceEpoch;
                          ref.read(sendMessageNotifierProvider.notifier).sendMessage(
                                message: MessageModel(
                                  id: '',
                                  updatedAt: now,
                                  userId: widget.client?.uid ?? '',
                                  artisanId: widget.artisan?.uid ?? '',
                                  type: MessageType.image,
                                  roomId: roomId,
                                  imageUrl: pickedImage!.path,
                                  senderId: userId!,
                                ),
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Consumer(builder: (context, ref, _) {
            return ref.watch(sendMessageNotifierProvider).maybeWhen(
              orElse: () => Container(),
              loading: () => Positioned(
                child: Container(
                  height: context.height,
                  width: context.width,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.5),
                  ),
                  child: context.loader,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
