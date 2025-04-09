import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays options for contacting customer service.
/// Clients can tap these buttons to launch WhatsApp, Email, or the Phone dialer,
/// ensuring secure and direct communication with customer service.
class ContactWidget extends StatelessWidget {
  // Customer service contact information (update with actual values).
  final String whatsappNumber = "233123456789"; // International format (without the "+").
  final String supportEmail = "support@byday.com"; // Email distribution list for customer service.
  final String supportPhone = "+2330123456789"; // Customer service phone number.

  const ContactWidget({Key? key}) : super(key: key);

  /// Launches WhatsApp with a pre-defined message. Ensures compatibility with international formats.
  Future<void> _launchWhatsApp(BuildContext context) async {
    final message = Uri.encodeComponent("Hello, I need help with my account.");
    final whatsappUrl = "https://wa.me/$whatsappNumber?text=$message";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnackbar(context, "Could not launch WhatsApp");
    }
  }

  /// Launches the default email client with a preset subject and body for user convenience.
  Future<void> _launchEmail(BuildContext context) async {
    final subject = Uri.encodeComponent("Support Request");
    final body = Uri.encodeComponent("Please describe your issue.");
    final emailUrl = "mailto:$supportEmail?subject=$subject&body=$body";

    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      _showErrorSnackbar(context, "Could not launch Email");
    }
  }

  /// Launches the phone dialer with the customer service phone number.
  Future<void> _launchPhone(BuildContext context) async {
    final telUrl = "tel:$supportPhone";

    if (await canLaunchUrl(Uri.parse(telUrl))) {
      await launchUrl(Uri.parse(telUrl));
    } else {
      _showErrorSnackbar(context, "Could not launch Phone dialer");
    }
  }

  /// Displays an error message in a SnackBar when an action cannot be performed.
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Contact Customer Service",
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 20),
        // Button to launch WhatsApp.
        ElevatedButton.icon(
          icon: const Icon(Icons.whatsapp),
          label: const Text("Chat on WhatsApp"),
          onPressed: () => _launchWhatsApp(context),
          style: ElevatedButton.styleFrom(primary: Colors.green[700]),
        ),
        const SizedBox(height: 20),
        // Button to launch Email.
        ElevatedButton.icon(
          icon: const Icon(Icons.email),
          label: const Text("Send Email"),
          onPressed: () => _launchEmail(context),
        ),
        const SizedBox(height: 20),
        // Button to launch Phone dialer.
        ElevatedButton.icon(
          icon: const Icon(Icons.phone),
          label: const Text("Call Customer Service"),
          onPressed: () => _launchPhone(context),
        ),
      ],
    );
  }
}
