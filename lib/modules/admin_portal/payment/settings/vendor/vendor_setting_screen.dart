import 'package:flutter/material.dart';
import 'package:linkschool/modules/common/app_colors.dart';
import 'package:linkschool/modules/common/constants.dart';
import 'package:linkschool/modules/common/text_styles.dart';
import 'package:linkschool/modules/admin_portal/payment/settings/vendor/vendor_transaction_screen.dart';

class VendorSettingsScreen extends StatefulWidget {

  const VendorSettingsScreen({super.key});

  @override
  State<VendorSettingsScreen> createState() => _VendorSettingsScreenState();
}

class _VendorSettingsScreenState extends State<VendorSettingsScreen> {
  late double opacity;

  final List<String> vendorNames = [
    'Okoro Ifeanyi',
    'Joe Nwachi',
    'Charles Uche',
    'Samuel Ikechi',
    'Ugonna Emma',
    'Francis Mike',
    'George Akanny',
    'Helen Ibe',
    'Mike Ifeanyi',
    'Juliet Ikenna',
  ];

  void _showAddVendorModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Vendor',
                      style: AppTextStyles.normal600(
                        fontSize: 20.0,
                        color: AppColors.primaryLight,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: AppColors.primaryLight,
                    ),
                  ],
                ),
              ),
              // const Divider(),
              // Form section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormField('Vendor name', 'Vendor name'),
                      const SizedBox(height: 16),
                      _buildFormField('Email (optional)', 'Email (optional)'),
                      const SizedBox(height: 16),
                      _buildFormField('Phone number', 'Phone number'),
                      const SizedBox(height: 16),
                      _buildFormField('Address', 'Address'),
                      const SizedBox(height: 16),
                      _buildFormField('Reference number', 'Reference number'),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle record payment
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.paymentTxtColor1,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Record payment',
                            style: AppTextStyles.normal600(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.normal500(
            fontSize: 14.0,
            color: AppColors.primaryLight,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    opacity = brightness == Brightness.light ? 0.1 : 0.15;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            'assets/icons/arrow_back.png',
            color: AppColors.paymentTxtColor1,
            width: 34.0,
            height: 34.0,
          ),
        ),
        title: Text(
          'Vendor Settings',
          style: AppTextStyles.normal600(
            fontSize: 24.0,
            color: AppColors.paymentTxtColor1,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: Constants.customBoxDecoration(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Vendor...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vendorNames.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.paymentTxtColor1,
                          child: Text(
                            vendorNames[index][0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(vendorNames[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VendorTransactionScreen(
                                vendorName: vendorNames[index],
                              ),
                            ),
                          );
                        },
                      ),
                      if (index != vendorNames.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(),
                        )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVendorModal(context),
        backgroundColor: AppColors.videoColor4,
        child: const Icon(
          Icons.add,
          color: AppColors.backgroundLight,
          size: 24,
        ),
      ),
    );
  }
}