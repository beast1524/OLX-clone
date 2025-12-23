import 'package:flutter/material.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  // Changed to a stateful widget so we can modify the list
  final List<Map<String, dynamic>> listings = [
    {
      'title': 'Ergonomic Office Chair',
      'type': 'Sell',
      'price': 2500,
      'isDonation': false,
      'status': 'Active',
      'description': 'Comfortable office chair with lumbar support',
    },
    {
      'title': 'Mechanical Keyboard',
      'type': 'Donation',
      'price': 0,
      'isDonation': true,
      'status': 'Active',
      'description': 'RGB mechanical keyboard, lightly used',
    },
    {
      'title': 'Projector (Meeting Room)',
      'type': 'Rent',
      'price': 500,
      'isDonation': false,
      'status': 'Inactive',
      'description': 'HD projector for meetings and presentations',
    },
  ];

  // Track which listing is expanded
  int? expandedIndex;

  void _deleteListing(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Listing'),
          content: Text(
            'Are you sure you want to delete "${listings[index]['title']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  listings.removeAt(index);
                  expandedIndex = null; // Reset expanded state
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listing deleted')),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editListing(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditListingDialog(
          listing: listings[index],
          onSave: (updatedListing) {
            setState(() {
              listings[index] = updatedListing;
            });
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Listing updated successfully')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text('My Listings'),
      ),
      body: listings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No listings yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final item = listings[index];
                final String title = item['title'] as String;
                final String type = item['type'] as String;
                final bool isDonation = item['isDonation'] as bool;
                final int price = item['price'] as int;
                final String status = item['status'] as String;
                final String description =
                    item['description'] as String? ?? 'No description available';
                final bool isActive = status.toLowerCase() == 'active';
                final bool isExpanded = expandedIndex == index;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                        onTap: () {
                          setState(() {
                            // Toggle expansion
                            if (expandedIndex == index) {
                              expandedIndex = null;
                            } else {
                              expandedIndex = index;
                            }
                          });
                        },
                      ),
                      // Expandable details section
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(height: 8),

                              // Type
                              Text(
                                'Type: $type',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Price
                              Text(
                                isDonation ? 'Price: Free' : 'Price: ₹$price',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Status
                              Text(
                                'Status: $status',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Description
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Description',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          description,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _editListing(index),
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text('Edit'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _deleteListing(index),
                                      icon: const Icon(Icons.delete, size: 18),
                                      label: const Text('Delete'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// Edit Listing Dialog
class EditListingDialog extends StatefulWidget {
  final Map<String, dynamic> listing;
  final Function(Map<String, dynamic>) onSave;

  const EditListingDialog({
    super.key,
    required this.listing,
    required this.onSave,
  });

  @override
  State<EditListingDialog> createState() => _EditListingDialogState();
}

class _EditListingDialogState extends State<EditListingDialog> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late String _selectedType;
  late String _selectedStatus;
  late bool _isDonation;

  final List<String> _types = ['Sell', 'Rent', 'Donation', 'Lend', 'Share'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.listing['title']);
    _priceController =
        TextEditingController(text: widget.listing['price'].toString());
    _descriptionController =
        TextEditingController(text: widget.listing['description']);
    _selectedType = widget.listing['type'];
    _selectedStatus = widget.listing['status'];
    _isDonation = widget.listing['isDonation'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleTypeChange(String? newType) {
    if (newType != null) {
      setState(() {
        _selectedType = newType;
        // Set isDonation for free types
        _isDonation = newType == 'Donation' || newType == 'Lend' || newType == 'Share';
        if (_isDonation) {
          _priceController.text = '0';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Listing',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title Field
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),

              // Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: _handleTypeChange,
              ),
              const SizedBox(height: 16),

              // Price Field
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: _isDonation ? 'Price (Free)' : 'Price',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                enabled: !_isDonation,
              ),
              const SizedBox(height: 16),

              // Status Display (Non-editable)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedStatus,
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedStatus.toLowerCase() == 'active'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final updatedListing = {
                      'title': _titleController.text,
                      'type': _selectedType,
                      'price': int.tryParse(_priceController.text) ?? 0,
                      'isDonation': _isDonation,
                      'status': _selectedStatus, // Keep original status
                      'description': _descriptionController.text,
                    };
                    widget.onSave(updatedListing);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}