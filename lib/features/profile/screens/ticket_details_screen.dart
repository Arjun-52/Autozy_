import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/ticket_details_provider.dart';
import '../../../data/models/dto/ticket_details_response_model.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailsScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketDetailsProvider>().fetchTicketDetails(widget.ticketId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TicketDetailsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Ticket Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(TicketDetailsProvider provider) {
    switch (provider.status) {
      case TicketDetailsState.initial:
      case TicketDetailsState.loading:
        return _buildShimmerLoading();
      case TicketDetailsState.error:
        return _buildErrorState(provider);
      case TicketDetailsState.success:
        if (provider.ticketDetails == null) {
          return _buildEmptyState(provider);
        }
        return RefreshIndicator(
          color: const Color(0xffC68A00),
          onRefresh: () => provider.fetchTicketDetails(widget.ticketId, isRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTicketInfoCard(provider.ticketDetails!),
                const SizedBox(height: 16),
                _buildAuthorCard(provider.ticketDetails!.author),
                const SizedBox(height: 16),
                _buildRepliesSection(provider.ticketDetails!.replies),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildTicketInfoCard(TicketDetailsModel ticket) {
    final statusColor = _getStatusColor(ticket.status ?? 'OPEN');
    final priorityColor = _getPriorityColor(ticket.priority ?? 'NORMAL');
    final formattedCreatedDate = _formatDate(ticket.createdAt ?? '');
    final formattedUpdatedDate = _formatDate(ticket.updatedAt ?? '');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ID & Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "ID: ${ticket.id ?? 'N/A'}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (ticket.priority ?? 'NORMAL').toUpperCase(),
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      (ticket.status ?? 'OPEN').replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Subject
          Text(
            ticket.subject ?? "Support Ticket",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Details grid
          _buildDetailItem(Icons.category, "Category / Type", ticket.type?.replaceAll('_', ' ').toUpperCase() ?? 'N/A'),
          if (ticket.vehicleNumber != null && ticket.vehicleNumber!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailItem(Icons.directions_car, "Vehicle Number", ticket.vehicleNumber!),
          ],
          if (ticket.subscriptionId != null && ticket.subscriptionId!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailItem(Icons.card_membership, "Subscription ID", ticket.subscriptionId!),
          ],
          if (ticket.serviceDate != null && ticket.serviceDate!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailItem(Icons.calendar_today, "Service Date", _formatDate(ticket.serviceDate!)),
          ],
          if (formattedCreatedDate.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailItem(Icons.create, "Created On", formattedCreatedDate),
          ],
          if (formattedUpdatedDate.isNotEmpty && formattedUpdatedDate != formattedCreatedDate) ...[
            const SizedBox(height: 12),
            _buildDetailItem(Icons.update, "Last Updated", formattedUpdatedDate),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Description
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ticket.description ?? "No description provided.",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),

          // Single/Multiple Attachments
          if (ticket.attachment != null && ticket.attachment!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              "Attachment",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildAttachmentWidget(ticket.attachment!),
          ],
          if (ticket.attachments != null && ticket.attachments!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              "Attachments",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ticket.attachments!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildAttachmentWidget(ticket.attachments![index]),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthorCard(TicketAuthorModel? author) {
    if (author == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ticket Owner",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xffFFFDF0),
                backgroundImage: author.avatar != null && author.avatar!.isNotEmpty
                    ? NetworkImage(author.avatar!)
                    : null,
                child: author.avatar == null || author.avatar!.isEmpty
                    ? const Icon(Icons.person, color: Color(0xffC68A00))
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author.name ?? "User",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      author.email ?? "",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (author.role ?? "CUSTOMER").toUpperCase(),
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepliesSection(List<TicketReplyModel> replies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
          child: Text(
            "REPLIES (${replies.length})",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
        ),
        if (replies.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text(
                "No replies yet",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: replies.length,
            itemBuilder: (context, index) {
              return _buildReplyItem(replies[index]);
            },
          ),
      ],
    );
  }

  Widget _buildReplyItem(TicketReplyModel reply) {
    final formattedDate = _formatDate(reply.createdAt ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: reply.isAgent ? const Color(0xffFFFDF0) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: reply.isAgent ? const Color(0xffF4C430).withOpacity(0.3) : Colors.transparent,
          width: reply.isAgent ? 1 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author name, role and indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      reply.authorName ?? "Support Specialist",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                    ),
                    if (reply.authorRole != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        "(${reply.authorRole})",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: reply.isAgent ? const Color(0xffF4C430) : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  reply.isAgent ? "AGENT" : "YOU",
                  style: TextStyle(
                    color: reply.isAgent ? Colors.black : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Message
          Text(
            reply.message ?? "",
            style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
          ),

          // Attachments
          if (reply.attachment != null && reply.attachment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildAttachmentWidget(reply.attachment!),
          ],
          if (reply.attachments != null && reply.attachments!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reply.attachments!.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildAttachmentWidget(reply.attachments![idx]),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              formattedDate,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentWidget(String url) {
    final isImage = url.contains('.jpg') || url.contains('.jpeg') || url.contains('.png') || url.contains('.webp');

    return GestureDetector(
      onTap: () => _openAttachmentViewer(url),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: isImage
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildFallbackAttachmentIcon(),
                )
              : _buildFallbackAttachmentIcon(),
        ),
      ),
    );
  }

  Widget _buildFallbackAttachmentIcon() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, color: Colors.grey, size: 30),
          SizedBox(height: 4),
          Text(
            "View File",
            style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _openAttachmentViewer(String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (context, err, st) => Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text("Unable to display file preview: $url", textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FloatingActionButton.small(
                backgroundColor: Colors.black54,
                onPressed: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return Colors.blue;
      case 'IN_PROGRESS':
        return Colors.purple;
      case 'RESOLVED':
        return Colors.green;
      case 'CLOSED':
        return Colors.black87;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH':
      case 'URGENT':
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      case 'LOW':
        return Colors.green;
      case 'NORMAL':
      default:
        return Colors.blueGrey;
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return "${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(child: CircularProgressIndicator(color: Color(0xffF4C430))),
        ),
      ],
    );
  }

  Widget _buildEmptyState(TicketDetailsProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 70, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              "No ticket details found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.fetchTicketDetails(widget.ticketId),
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(TicketDetailsProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? "An error occurred while loading ticket details.",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchTicketDetails(widget.ticketId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Retry Connection", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
