import 'package:auto_route/auto_route.dart'; // For route management.
import 'package:flutter/material.dart';
import 'package:byday/src/chat/providers/chat_list_provider.dart'; // Provider for fetching chat list.
import 'package:byday/src/core/extensions/context_extension.dart'; // Context extensions for helpers.
import 'package:byday/src/core/routes/app_router.dart'; // App routing.
import 'package:byday/src/core/widgets/widgets.dart'; // Common reusable widgets.
import 'package:hooks_riverpod/hooks_riverpod.dart'; // State management using Riverpod.

/// ChatListView displays the list of chat rooms.
/// Communication is restricted to interactions with customer service.
/// Chat functionality strictly avoids client ↔ artisan communication.
@RoutePage(name: 'ChatRouter')
class ChatListView extends StatefulHookConsumerWidget {
  const ChatListView({Key? key, required this.isArtisan}) : super(key: key);

  /// Indicates whether the view is for an artisan user.
  final bool isArtisan;

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends ConsumerState<ChatListView> {
  /// Retrieves the `isArtisan` flag from the widget.
  bool get isArtisan => widget.isArtisan;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: ref.watch(chatListNotifierProvider(isArtisan)).maybeWhen(
        orElse: Container.new, // Default container if state is unhandled.
        loading: () => context.loader, // Show loader while fetching data.
        success: (chatRooms) => ListView.builder(
          itemCount: chatRooms.length, // Number of chat rooms.
          itemBuilder: (context, index) {
            final room = chatRooms[index];
            return ChatListTile(
              imageUrl: '', // Placeholder for chat room image.
              name: room.product?.name ?? '', // Displays product name (if available).
              subtitle: isArtisan
                  ? room.client?.name ?? '' // Displays client name for artisans.
                  : room.artisan?.name ?? '', // Displays artisan name for clients.
              onPressed: () => context.router.push(ChatDetailRoute(
                product: room.product!,
                roomId: room.id,
                isArtisan: isArtisan,
                artisan: room.artisan,
                client: room.client,
              )), // Navigates to ChatDetailView for customer service communication.
            );
          },
        ),
      ),
    );
  }
}
