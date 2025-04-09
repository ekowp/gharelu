import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:byday/src/core/extensions/extensions.dart'; // Updated path for By Day branding.
import 'package:byday/src/core/theme/theme.dart'; // Updated path for By Day branding.

/// A widget that displays an image inside a dotted border and provides a delete option.
/// This can be useful for showing uploaded images with an easy way to remove them.
class DottedImageViewer extends StatelessWidget {
  /// The file path of the image to display.
  final String image;

  /// Callback function triggered when the delete icon is tapped.
  final VoidCallback? onDelete;

  const DottedImageViewer({Key? key, required this.image, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // The main dotted border wrapping the image.
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          dashPattern: [8, 6],
          strokeWidth: 2,
          color: AppColors.primaryColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(image),
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.lightGrey,
                height: 120,
                width: 120,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: AppColors.darkGrey,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Delete button positioned at the top-left of the widget.
        Positioned(
          left: -10,
          top: -15,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(60),
            child: InkWell(
              splashColor: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60),
              onTap: onDelete,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.errorColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.delete,
                  color: AppColors.whiteColor,
                ).pad(8),
              ),
            ),
          ),
        ),
      ],
    ).pOnly(left: 10);
  }
}
