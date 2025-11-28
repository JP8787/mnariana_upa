import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda_tech/src/models/product.dart';

class CartItem {
  final Product product;
  int qty;
  final String? selectedSize;
  final String? selectedColor;
  CartItem(
      {required this.product,
      this.qty = 1,
      this.selectedSize,
      this.selectedColor});
}

class CartState {
  final List<CartItem> items;
  CartState(this.items);
  double get total => items.fold(0, (s, i) => s + i.product.price * i.qty);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState([]));

  void add(Product p, {String? selectedSize, String? selectedColor}) {
    // Try to match existing cart item by product id and selected options
    final idx = state.items.indexWhere((i) =>
        i.product.id == p.id &&
        i.selectedSize == selectedSize &&
        i.selectedColor == selectedColor);
    if (idx >= 0) {
      state.items[idx].qty += 1;
      state = CartState([...state.items]);
    } else {
      state = CartState([
        ...state.items,
        CartItem(
            product: p,
            selectedSize: selectedSize,
            selectedColor: selectedColor)
      ]);
    }
  }

  void remove(Product p) {
    state = CartState(state.items.where((i) => i.product.id != p.id).toList());
  }

  void changeQty(Product p, int qty) {
    final idx = state.items.indexWhere((i) => i.product.id == p.id);
    if (idx >= 0) {
      state.items[idx].qty = qty;
      state = CartState([...state.items]);
    }
  }

  void clear() => state = CartState([]);
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
