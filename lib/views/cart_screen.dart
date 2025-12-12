import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

/// CartScreen displays the shopping cart with items, add/remove, and checkout.
class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final items = widget.cart.items;
    final totalPrice = widget.cart.totalPrice;
    final isEmpty = widget.cart.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
          style: heading1,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isEmpty
          ? const Center(
              child: Text('Your cart is empty', style: normalText),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemTile(
                        item: item,
                        index: index,
                        onQuantityChanged: (newQty) {
                          setState(() {
                            widget.cart.updateQuantity(index, newQty);
                          });
                        },
                        onRemove: () {
                          setState(() {
                            widget.cart.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: normalText),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            key: const Key('cart_total'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const Key('checkout_button'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            _showCheckoutDialog(context, totalPrice);
                          },
                          child: const Text(
                            'Checkout',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showCheckoutDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout Confirmation'),
        content: Text('Total: \$${total.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            key: const Key('confirm_checkout'),
            onPressed: () {
              widget.cart.clear();
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

/// CartItemTile displays a single cart item with quantity controls.
class CartItemTile extends StatefulWidget {
  final CartItem item;
  final int index;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    final sandwich = widget.item.sandwich;
    final sizeLabel = sandwich.isFootlong ? 'Footlong' : 'Six-inch';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sandwich.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$sizeLabel · ${sandwich.breadType.name}',
                        style: normalText,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: Key('remove_item_${widget.index}'),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      key: Key('decrease_qty_${widget.index}'),
                      icon: const Icon(Icons.remove),
                      onPressed: _quantity > 1
                          ? () => _updateQuantity(_quantity - 1)
                          : null,
                    ),
                    Text(
                      '$_quantity',
                      key: Key('qty_display_${widget.index}'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      key: Key('increase_qty_${widget.index}'),
                      icon: const Icon(Icons.add),
                      onPressed: () => _updateQuantity(_quantity + 1),
                    ),
                  ],
                ),
                Text(
                  '\$${widget.item.totalPrice.toStringAsFixed(2)}',
                  key: Key('item_total_${widget.index}'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(int newQty) {
    setState(() {
      _quantity = newQty;
    });
    widget.onQuantityChanged(newQty);
  }
}
