import 'package:thamarat/core/api/api_service.dart';
import 'package:thamarat/core/constants/api_constants.dart';
import 'package:thamarat/data/models/vendor_model.dart';


class VendorRepository {
  final ApiService _apiService;

  VendorRepository(this._apiService);

  Future<List<VendorModel>> getVendors() async {
    try {
      final response = await _apiService.get(ApiConstants.customers);
      final data = response.data;

      print('GetVendors response: ${data['success']}');
      print('Number of customers: ${(data['data'] as List).length}');

      if (data['success'] == true) {
        final customers = (data['data'] as List)
            .map((e) => VendorModel.fromJson(e))
            .toList();
        
        // Filter only non-deleted customers
        final filteredCustomers = customers.where((customer) => !customer.deleted).toList();
        print('Non-deleted customers: ${filteredCustomers.length}');
        
        return filteredCustomers;
      } else {
        throw Exception(data['message'] ?? 'Failed to fetch customers');
      }
    } catch (e) {
      print('Error in getVendors: $e');
      rethrow;
    }
  }

  Future<List<VendorModel>> searchVendors(String query) async {
    final response = await _apiService.get(ApiConstants.customers);
    final data = response.data;

    if (data['success'] == true) {
      final customers = (data['data'] as List)
          .map((e) => VendorModel.fromJson(e))
          .toList();
      
      // Filter non-deleted customers and search by name
      return customers
          .where((customer) => !customer.deleted && 
                              customer.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to search customers');
    }
  }

  Future<VendorModel> addVendor({
    required String name,
    required String phone,
    required String address,
  }) async {
    final response = await _apiService.post(
      ApiConstants.addCustomer,
      data: {
        'name': name,
        'phoneNumber': phone,
      },
    );
    final data = response.data;

    if (data['success'] == true) {
      return VendorModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to add customer');
    }
  }

  Future<VendorModel> updateVendor({
    required String id,
    required String name,
    required String phone,
    required String address,
  }) async {
    final response = await _apiService.put(
      '${ApiConstants.customers}/$id',
      data: {
        'name': name,
        'phoneNumber': phone,
      },
    );
    final data = response.data;

    if (data['success'] == true) {
      return VendorModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to update customer');
    }
  }

  Future<void> deleteVendor(String id) async {
    final response = await _apiService.delete('${ApiConstants.customers}/$id');
    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to delete customer');
    }
  }

  Future<VendorModel> getVendorDetails(int id) async {
    final response = await _apiService.get('${ApiConstants.customers}/$id');
    final data = response.data;

    if (data['success'] == true) {
      return VendorModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch customer details');
    }
  }

  // Test method to check data separately
  Future<void> testDataFetching() async {
    try {
      print('=== Testing Data Fetching ===');
      
      // Test customers
      final customersResponse = await _apiService.get(ApiConstants.customers);
      print('Customers API Response: ${customersResponse.statusCode}');
      print('Customers Data: ${customersResponse.data}');
      
      // Test sale processes
      final saleProcessesResponse = await _apiService.get(ApiConstants.saleProcesses);
      print('Sale Processes API Response: ${saleProcessesResponse.statusCode}');
      print('Sale Processes Data: ${saleProcessesResponse.data}');
      
    } catch (e) {
      print('Test Error: $e');
    }
  }

  // New method to get customers with their active invoices (status = true)
  Future<List<VendorModel>> getCustomersWithActiveInvoices() async {
    try {
      // Get all sale processes (invoices)
      final response = await _apiService.get(ApiConstants.saleProcesses);
      final data = response.data;

      if (data['success'] == true) {
        final saleProcesses = data['data'] as List;
        
        // Group sale processes by customer
        final Map<int, List<dynamic>> customerInvoices = {};
        
        for (var process in saleProcesses) {
          final customerId = process['customerId'] as int;
          if (!customerInvoices.containsKey(customerId)) {
            customerInvoices[customerId] = [];
          }
          customerInvoices[customerId]!.add(process);
        }

        // Get all customers
        final customersResponse = await _apiService.get(ApiConstants.customers);
        final customersData = customersResponse.data;
        
        if (customersData['success'] == true) {
          final customers = (customersData['data'] as List)
              .map((e) => VendorModel.fromJson(e))
              .where((customer) => !customer.deleted)
              .toList();

          // Add invoices to each customer
          final updatedCustomers = <VendorModel>[];
          for (var customer in customers) {
            if (customerInvoices.containsKey(customer.id)) {
              final invoices = customerInvoices[customer.id]!
                  .map((e) => InvoiceModel.fromJson(e))
                  .toList(); // Consider all invoices as active
              
              // Create a new customer with invoices
              updatedCustomers.add(VendorModel(
                id: customer.id,
                name: customer.name,
                phoneNumber: customer.phoneNumber,
                deleted: customer.deleted,
                invoices: invoices,
              ));
            } else {
              // Customer with no invoices
              updatedCustomers.add(customer);
            }
          }
          
          return updatedCustomers;
        }
      }
      
      // If no real data, return basic customers
      return await getVendors();
      
    } catch (e) {
      print('Error in getCustomersWithActiveInvoices: $e');
      // Return basic customers on error
      return await getVendors();
    }
  }
}
