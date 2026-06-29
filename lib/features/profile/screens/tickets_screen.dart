import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/ticket_provider.dart';
import '../../../data/models/dto/tickets_response_model.dart';
import '../../../core/utils/responsive.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().fetchTickets();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<TicketProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TicketProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Support Tickets",
          style: TextStyle(
            color: Colors.black,
            fontSize: context.sp(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(TicketProvider provider) {
    switch (provider.status) {
      case TicketStatusState.initial:
      case TicketStatusState.loading:
        return _buildShimmerLoading();
      case TicketStatusState.empty:
        return _buildEmptyState(provider);
      case TicketStatusState.error:
        return _buildErrorState(provider);
      case TicketStatusState.success:
        return RefreshIndicator(
          color: const Color(0xffC68A00),
          onRefresh: () => provider.fetchTickets(isRefresh: true),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(context.w(16)),
            itemCount: provider.tickets.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.tickets.length) {
                return provider.isPageLoading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: context.h(24)),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffF4C430),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }
              return _buildTicketCard(provider.tickets[index]);
            },
          ),
        );
    }
  }

  Widget _buildTicketCard(TicketModel ticket) {
    final statusColor = _getStatusColor(ticket.status ?? 'OPEN');
    final priorityColor = _getPriorityColor(ticket.priority ?? 'NORMAL');
    final formattedCreatedDate = _formatDate(ticket.createdAt ?? '');
    final formattedUpdatedDate = _formatDate(ticket.updatedAt ?? '');

    return GestureDetector(
      onTap: () {
        context.push('/ticket-details/${ticket.id}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(12)),
        padding: EdgeInsets.all(context.w(11)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID, Status & Priority
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "ID: ${ticket.id ?? 'N/A'}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: context.sp(11.5),
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    // Priority Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(3)),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (ticket.priority ?? 'NORMAL').toUpperCase(),
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: context.sp(9.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(6)),
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: context.w(8), vertical: context.h(4)),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor, width: 0.5),
                      ),
                      child: Text(
                        (ticket.status ?? 'OPEN').replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: context.sp(9.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: context.h(8)),

            // Subject / Title
            Text(
              ticket.subject ?? "Support Ticket",
              style: TextStyle(
                fontSize: context.sp(14),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: context.h(4)),

            // Category/Type
            if (ticket.type != null)
              Text(
                "Category: ${ticket.type!.replaceAll('_', ' ').toUpperCase()}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: context.sp(11.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            SizedBox(height: context.h(8)),

            // Description Preview
            if (ticket.description != null && ticket.description!.isNotEmpty) ...[
              Text(
                ticket.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: context.h(8)),
            ],

            const Divider(),
            SizedBox(height: context.h(8)),

            // Dates Info Row
            if (formattedCreatedDate.isNotEmpty) ...[
              _buildInfoRow(Icons.calendar_today, "Created Date", formattedCreatedDate),
              SizedBox(height: context.h(6)),
            ],
            if (formattedUpdatedDate.isNotEmpty && formattedUpdatedDate != formattedCreatedDate)
              _buildInfoRow(Icons.update, "Last Updated", formattedUpdatedDate),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        SizedBox(width: context.w(8)),
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey.shade600, fontSize: context.sp(11.5), fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.black87, fontSize: context.sp(11.5), fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return Colors.blue;
      case 'IN_PROGRESS':
      case 'IN_REVIEW':
        return Colors.purple;
      case 'RESOLVED':
        return Colors.green;
      case 'CLOSED':
        return Colors.black87;
      case 'REJECTED':
      case 'FAILED':
        return Colors.red;
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
    return ListView.builder(
      padding: EdgeInsets.all(context.w(16)),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: context.h(12)),
          height: context.h(160),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9E9E9)),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.w(11)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: context.w(100), height: context.h(14), color: Colors.grey.shade100),
                    Container(width: context.w(80), height: context.h(20), color: Colors.grey.shade100),
                  ],
                ),
                SizedBox(height: context.h(16)),
                Container(width: context.w(180), height: context.h(22), color: Colors.grey.shade100),
                SizedBox(height: context.h(16)),
                const Divider(),
                SizedBox(height: context.h(12)),
                Container(width: context.w(140), height: context.h(14), color: Colors.grey.shade100),
                SizedBox(height: context.h(8)),
                Container(width: context.w(200), height: context.h(14), color: Colors.grey.shade100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(TicketProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: context.w(64), color: Colors.grey.shade400),
            SizedBox(height: context.h(16)),
            Text(
              "No support tickets found.",
              style: TextStyle(
                fontSize: context.sp(14),
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton.icon(
              onPressed: () => provider.fetchTickets(),
              icon: Icon(Icons.refresh, size: context.w(18)),
              label: Text("Refresh", style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(TicketProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: context.w(64), color: Colors.redAccent),
            SizedBox(height: context.h(16)),
            Text(
              provider.errorMessage ?? "An error occurred while loading tickets.",
              style: TextStyle(
                fontSize: context.sp(13.5),
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            ElevatedButton(
              onPressed: () => provider.fetchTickets(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Retry Connection", style: TextStyle(color: Colors.white, fontSize: context.sp(13), fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
