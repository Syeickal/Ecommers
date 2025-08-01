import 'package:flutter/material.dart';
import '../models/user_address.dart';
import '../services/address_service.dart';

class AddEditAddressScreen extends StatefulWidget {
  final UserAddress? address; // Jika null, berarti mode Tambah. Jika ada, mode Edit.

  const AddEditAddressScreen({Key? key, this.address}) : super(key: key);

  @override
  _AddEditAddressScreenState createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressService = AddressService();
  bool _isLoading = false;

  // Controller untuk setiap input field
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data yang ada jika dalam mode Edit
    _nameController = TextEditingController(text: widget.address?.recipientName ?? '');
    _phoneController = TextEditingController(text: widget.address?.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.address?.fullAddress ?? '');
    _labelController = TextEditingController(text: widget.address?.label ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newAddress = UserAddress(
        id: widget.address?.id ?? '', // ID kosong jika menambah alamat baru
        recipientName: _nameController.text,
        phoneNumber: _phoneController.text,
        fullAddress: _addressController.text,
        label: _labelController.text,
      );

      try {
        if (widget.address == null) {
          // Mode Tambah
          await _addressService.addAddress(newAddress);
        } else {
          // Mode Edit
          await _addressService.updateAddress(newAddress);
        }
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya setelah berhasil
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan alamat: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Tambah Alamat Baru' : 'Ubah Alamat'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: _labelController,
                labelText: 'Label Alamat',
                hintText: 'Contoh: Rumah, Kantor Ayah',
                icon: Icons.label_outline,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Nama Penerima',
                hintText: 'Masukkan nama lengkap penerima',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _phoneController,
                labelText: 'Nomor Telepon',
                hintText: 'Masukkan nomor telepon aktif',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _addressController,
                labelText: 'Alamat Lengkap',
                hintText: 'Masukkan nama jalan, nomor rumah, RT/RW, dll.',
                icon: Icons.location_city_outlined,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _saveAddress,
          icon: _isLoading
              ? const SizedBox.shrink()
              : const Icon(Icons.save_outlined),
          label: _isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(color: Colors.white),
          )
              : const Text('Simpan Alamat'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    int? maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$labelText tidak boleh kosong';
        }
        return null;
      },
    );
  }
}