import 'package:get/get.dart';
import 'package:ruang_rasa_mobile/app/data/models/product_model.dart';

class DetailProdukController extends GetxController {
  // Menangkap data product dari Get.arguments
  late ProductModel product;

  // State untuk Quantity
  var quantity = 1.obs;

  // State untuk menyimpan pilihan varian (Input Type: Radio)
  // Format Map: { variant_type_id : variant_option_id }
  var selectedRadios = <int, int>{}.obs;

  // State untuk menyimpan pilihan varian (Input Type: Checkbox)
  // Format Map: { variant_option_id : is_selected (bool) }
  var selectedCheckboxes = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();

    // PERBAIKAN DI SINI:
    // Cek apakah data yang dikirim masih berupa JSON (Map) atau sudah ProductModel
    if (Get.arguments is Map<String, dynamic>) {
      product = ProductModel.fromJson(Get.arguments);
    } else {
      product = Get.arguments as ProductModel;
    }

    final args = Get.arguments;

    if (args is Map) {
      product = args['product'];
    } else {
      product = args as ProductModel;
    }

    // Set default pilihan pertama untuk varian bertipe 'radio'
    if (product.variantTypes != null) {
      for (var type in product.variantTypes!) {
        if (type.inputType == 'radio' &&
            type.variantOptions != null &&
            type.variantOptions!.isNotEmpty) {
          selectedRadios[type.id!] = type.variantOptions!.first.id!;
        }
      }
    }
  }

  // Fungsi mengubah quantity
  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  // Fungsi saat opsi Radio diklik
  void selectRadio(int typeId, int optionId) {
    selectedRadios[typeId] = optionId;
  }

  // Fungsi saat opsi Checkbox diklik
  void toggleCheckbox(int optionId) {
    if (selectedCheckboxes.containsKey(optionId)) {
      selectedCheckboxes[optionId] = !selectedCheckboxes[optionId]!;
    } else {
      selectedCheckboxes[optionId] = true;
    }
  }

  List<Map<String, dynamic>> getSelectedVariants() {
    List<Map<String, dynamic>> result = [];

    if (product.variantTypes != null) {
      for (var type in product.variantTypes!) {
        if (type.variantOptions != null) {
          for (var option in type.variantOptions!) {
            if (selectedRadios[type.id] == option.id ||
                selectedCheckboxes[option.id] == true) {
              result.add({
                "variant_type_id": type.id,
                "variant_option_id": option.id,
              });
            }
          }
        }
      }
    }

    return result;
  }

  // Getter untuk menghitung total harga (Base Price + Price Impact) * Quantity
  int get totalPrice {
    int basePrice = product.price ?? 0;
    int totalImpact = 0;

    if (product.variantTypes != null) {
      for (var type in product.variantTypes!) {
        if (type.variantOptions != null) {
          for (var option in type.variantOptions!) {
            // Cek jika ini adalah opsi radio yang sedang dipilih user
            if (type.inputType == 'radio' &&
                selectedRadios[type.id] == option.id) {
              totalImpact += (option.priceImpact ?? 0);
            }
            // Cek jika ini adalah opsi checkbox yang sedang dicentang user
            else if (type.inputType == 'checkbox' &&
                selectedCheckboxes[option.id] == true) {
              totalImpact += (option.priceImpact ?? 0);
            }
          }
        }
      }
    }
    return (basePrice + totalImpact) * quantity.value;
  }
}
