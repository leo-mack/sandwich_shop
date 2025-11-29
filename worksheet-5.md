# **Worksheet 5 — Data Models and Assets**

## **What you need to know beforehand**

Ensure that you have already completed the following:

- [Worksheet 0 — Introduction to Dart, Git and GitHub](./worksheet-0.md).
- [Worksheet 1 — Introduction to Flutter](./worksheet-1.md).
- [Worksheet 2 — Stateless Widgets](./worksheet-2.md).
- [Worksheet 3 — Stateful widgets](./worksheet-3.md).
- [Worksheet 4 — App Architecture and Testing](./worksheet-4.md).

## **Getting help**

To get support with this worksheet, join the [Discord channel](https://portdotacdotuk-my.sharepoint.com/:b:/g/personal/mani_ghahremani_port_ac_uk/EbX583gvURRAhqsnhYqmbSEBwIFw6tXRyz_Br1GxIyE8dg) and ask your questions there. Otherwise, attend your timetabled session and ask a member of staff for help.

## **Getting started**

⚠️ Recall that the first exercise from worksheet 3 required you to create a README.md file for your project. Hopefully you have managed to finish this task. Before we begin, compare your README with [the model README file that we have provided in branch 4](https://github.com/manighahrmani/sandwich_shop/blob/4/README.md).

For this worksheet, as an exception, start with the code from branch 5 of our [GitHub repository](https://github.com/manighahrmani/sandwich_shop/tree/5). You can either clone the repository and checkout branch 5:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git checkout 5
```

Or manually ensure your code matches the repository. Run the app to make sure everything works as expected before proceeding.

## **Introduction to Data Models**

So far, we've been passing simple data types like `String` and `int` between our widgets. As our app grows in complexity, it's better to group related data into custom data types (classes). We call these **data models**.

If you've worked with databases before, you can think of data models as being similar to **entities**. An entity is a real-world object or concept that can be distinctly identified. In our case, a "Sandwich" is a perfect example of an entity that we can represent with a data model.

### **Business Logic Decisions**

During your development, you as the developer would make certain business decisions about how the app should function. Here is an example of one such decision we have made regarding our app.

We assume that the price of a sandwich depends only on its size (footlong vs six-inch), not on the type of sandwich or bread type. This keeps our pricing simple and consistent.

This is why our `PricingRepository` only needs to know the quantity and size (`isFootlong`) to calculate the total price. The sandwich type (like "Veggie Delight" or "Turkey Club") and bread type don't affect the price.

### **Creating the `Sandwich` model**

Let's start by defining a `Sandwich` model. This will help us manage all the properties of a sandwich in one place.

Open the Explorer view in VS Code with **Ctrl + Shift + E** on Windows or **⌘ + Shift + E** on macOS. Right-click on the `lib` folder and select **New Folder**. Name this folder `models`. Right-click on the `models` folder and select **New File**. Name this file `sandwich.dart`. This is what your project structure may look like:

```text
lib/
├── main.dart
├── views/
│   └── app_styles.dart
├── view_models/
├── models/
│   └── sandwich.dart
└── repositories/
    └── pricing_repository.dart
```

You will notice that we have not listed `lib/repository/order_repository.dart`. You can **delete `order_repository.dart` from your `repositories` folder** as it's no longer needed with our new data model approach (more on this later). Make sure to remove the import statement for this file from `lib/main.dart` as well as the `order_repository_test.dart` unit test from the `test/repositories` folder. We will fix the errors that this causes later (you do not need to run the app for now).

Add the following code to `sandwich.dart`:

```dart
enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
  });

  String get name {
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    String typeString = type.name;
    String sizeString = '';
    if (isFootlong) {
      sizeString = 'footlong';
    } else {
      sizeString = 'six_inch';
    }
    return 'assets/images/${typeString}_$sizeString.png';
  }
}
```

Here we have defined a `Sandwich` class with properties for the sandwich type, size, and bread type. Notice how we use enums for both `SandwichType` and `BreadType` to ensure users can only select from valid options. This is a preferable approach to using `String`s, as it reduces the risk of typos and values that are not part of the defined set.

The `name` getter converts the enum value into a human-readable string, and the `image` getter automatically constructs the correct image path based on the sandwich type and size. For example, a footlong Veggie Delight would have the image path `assets/images/veggieDelight_footlong.png`.

Use your AI assistant to explain why we use getters here instead of storing the name and image as instance variables received in the constructor.

Before moving on, use your AI assistant to write a unit test for the `Sandwich` model. Remember to create a `models` folder inside the `test` folder to mirror the structure of the `lib` folder. Your test file should be named `sandwich_test.dart`.

#### **Commit your changes (1)**

Here's a reminder to commit your changes (commit them individually, the addition of the model and the test).

### **The `Cart` model**

Now that we can represent a single sandwich, we need a way to manage a collection of them in an order. We need to create a `Cart` class that can hold multiple `Sandwich` objects along with their quantities.

Right-click on the `models` folder and select **New File**. Name this file `cart.dart`. Ask your AI assistant to help you implement a `Cart` class. Take your time writing a prompt that clearly describes the functionality you want. Think about what typical operations a user would perform on a cart of a food delivery app.

Remember that the price calculation should use our existing `PricingRepository` since it's the single source of truth for pricing logic. You'll need to import the `PricingRepository` and use its `calculatePrice` method in the `cart.dart` file.

As before, write unit tests for the `Cart` model in a new file called `cart_test.dart` inside the `test/models` folder.

#### **Commit your changes (2)**

Commit the addition of the `Cart` model and its tests before moving on.

## **Managing Assets**

### **Adding assets to the project**

Our `Sandwich` model automatically generates image paths, but we haven't provided any images yet. In Flutter, static files like images, fonts, and configuration files are called **assets**.

First, create an `assets` folder in the root of your project, at the same level as the `lib` and `test` folders. Inside the `assets` folder, create another folder called `images`.

Next, you need to tell Flutter about these new assets. Open the `pubspec.yaml` file and add an `assets` section like this (**the `uses-material-design: true` line already exists there, just add everything below it**).

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Make sure the indentation is correct, as `pubspec.yaml` is sensitive to whitespace. The line `assets:` should be at the same indentation level as `uses-material-design:`.

Now you can use images saved in this folder in your app. For more information, you can read the official Flutter documentation on [adding assets and images](https://docs.flutter.dev/ui/assets/assets-and-images).

For your coursework you should **not** to incorporate any videos or audio files, but if you wish to explore this check out [this page](https://docs.flutter.dev/cookbook/plugins/play-video).

#### **Commit your changes (3)**

Commit your new assets before moving on.

### **Adding a simple logo to the app bar**

Before we dive into the more complex sandwich image display, let's start with a simple example of using images. We'll add a logo to the app bar.

We have already provided you with a logo image called `logo.png` for the app bar. If you have cloned/forked our repository, you should already have this, otherwise, download it from [this page](https://github.com/manighahrmani/sandwich_shop/blob/5/assets/images/logo.png) and save it as `logo.png` in the `assets/images` folder.

In your `lib/main.dart` file, update the `AppBar` in the `build` method of `_OrderScreenState` to include a logo. To change its size, you can wrap the `Image.asset()` widget in a `SizedBox`. Here's how you can do it:

```dart
appBar: AppBar(
  leading: SizedBox(
    height: 100,
    child: Image.asset('assets/images/logo.png'),
  ),
  title: const Text(
    'Sandwich Counter',
    style: heading1,
  ),
),
```

The `Image.asset()` widget loads an image from your assets folder. The `leading` property of `AppBar` places the widget before the title. Run your app to see the logo appear in the app bar.

Although the height of the `AppBar` is typically around 56 pixels so the image will be scaled down to fit, setting one of the dimensions in `SizedBox` helps maintain the aspect ratio of the image.

For more information about the `Image` widget and its properties, check the [Flutter documentation on Image](https://api.flutter.dev/flutter/widgets/Image-class.html).

#### **Commit your changes (4)**

Commit this simple logo addition before moving on to the more complex image display.

## **Updating the UI**

Your `main.dart` should still have several errors (all to do with the use of `OrderRepository`). We will fix these shortly while also creating a simple interface where users can select a sandwich type, size, bread type, and quantity, then add it to their cart.

### **Updating the imports**

First, open `lib/main.dart` and make sure you have exactly the following imports at its top:

```dart
import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
```

As mentioned before, you need to remove the import for `order_repository.dart` since it's no longer needed. Similarly, remove the old import for `pricing_repository.dart` as we will be using its `calculatePrice` method through the `Cart` model (it is indirectly imported).

You'll also need to remove the `BreadType` enum from `lib/main.dart` since it's now defined in the `sandwich.dart` file.

### **Displaying sandwich images**

Now let's add dynamic image display that updates based on the user's selection. We'll show the sandwich image that corresponds to the selected type and size.

You'll need to create images for each sandwich type and size combination. Based on our `SandwichType` enum, you'll need images named like: `veggieDelight_footlong.png` or `veggieDelight_six_inch.png` and so on for all the sandwich types (this means a total of 8 images).

Use your AI assistant to help you find or create placeholder images for the sandwiches and logo. You can use simple coloured rectangles or search for copyright-free images online. Save these images in the `assets/images` folder with the exact naming convention shown above.

Now we'll update the UI to include the image display and replace the old order management system with our new cart-based approach.

Since we're changing the UI structure significantly, you can remove the `OrderItemDisplay` classes from the bottom of your `lib/main.dart` file as it is no longer needed with our new approach.

Replace the entirety of `_OrderScreenState` with the following:

```dart
class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      setState(() {
        _cart.add(sandwich, quantity: _quantity);
      });

      String sizeText;
      if (_isFootlong) {
        sizeText = 'footlong';
      } else {
        sizeText = 'six-inch';
      }
      String confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      debugPrint(confirmationMessage);
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      Sandwich sandwich =
          Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> entry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  String _getCurrentImagePath() {
    final Sandwich sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() {
        _selectedSandwichType = value;
      });
    }
  }

  void _onSizeChanged(bool value) {
    setState(() {
      _isFootlong = value;
    });
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() {
        _selectedBreadType = value;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return _decreaseQuantity;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Image not found',
                        style: normalText,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: normalText,
                initialSelection: _selectedSandwichType,
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch', style: normalText),
                  Switch(
                    value: _isFootlong,
                    onChanged: _onSizeChanged,
                  ),
                  const Text('Footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 20),
              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: heading2),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StyledButton(
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
```

Notice that we are assuming your `Cart` model provides an `add` method that takes a `Sandwich` object and an optional `quantity` parameter. If your implementation differs, adjust the `_addToCart` method accordingly.

The `Image.asset()` shows the current sandwich image. The `_getCurrentImagePath()` method ensures the image updates automatically when users change their selections. If you are confused by what the `errorBuilder` property does, or how the `fit: BoxFit.cover` property affects image display, ask your AI assistant to explain these concepts.

The dropdown menus, switch, and quantity controls work together to update the image in real-time. When the user adds items to the cart, a confirmation message is printed to the debug console using `debugPrint()`. If you don't see the debug console in VS Code, open the Command Palette (**Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS) and type "Focus on Debug Console View" to open it.

Notice that we wrap our `Column` in a `SingleChildScrollView` widget. This makes the entire interface scrollable, which is important when the content becomes too tall for the screen. This is particularly useful on smaller devices or when the screen is resized to a smaller height. You may remember doing an exercise on scrollable widgets in [Worksheet 2](./worksheet-2.md).

As always, write widget tests to ensure your UI behaves as expected (several tests in the current `test/views/widget_test.dart` file that you have would almost certainly fail). Test scenarios like adding items to the cart, changing quantities, and selecting different sandwich options.

#### **Commit your changes (5)**

Make sure all your changes are committed separately before moving on to the exercises.

## **Loading Data from Files (Optional)**

So far, our sandwich types are hardcoded as enums in the `Sandwich` model. This means every time we want to add a new sandwich or change a name, we need to modify the code and rebuild the app. In real-world applications, data like menu items often comes from external sources like files or APIs.

We will see more about this in [Worksheet 7](./worksheet-7.md) but for now,let's quickly see how to load sandwich data from files.

There are several ways to store data in general.

- **Structured** - Data where every instance has the same properties
- **Semi-structured** - Data where instances have different properties
- **Unstructured** - Data where no rules or structure is enforced on the instances

Worksheet 7 will discuss structured data sources. As for the other two categories, a Flutter project will typically use one of the following:

- **Plain text files** - Unstructure but simple
- **JSON files** - (Semi-)structured but easy to parse and widely used
- **CSV files** - (Semi-)structured, good for tabular data, easy to edit
- **YAML files** - (Semi-)structured, human-readable, good for configuration

For this exercise, we'll focus on **JSON** as it's the most common format for mobile apps and provides a good balance between readability and structure.

### **Creating a JSON data file**

First, create a new file called `sandwiches.json` in your `assets` folder (not in the `images` subfolder, but directly in `assets`):

```text
assets/
├── images/
│   └── ...
└── sandwiches.json
```

Add the following content to `sandwiches.json`:

```json
{
  "sandwiches": [
    {
      "id": "veggie_delight",
      "name": "Veggie Delight",
      "description": "Fresh vegetables with your choice of bread",
      "available": true
    },
    {
      "id": "chicken_teriyaki",
      "name": "Chicken Teriyaki",
      "description": "Tender chicken with teriyaki sauce",
      "available": true
    },
    {
      "id": "tuna_melt",
      "name": "Tuna Melt",
      "description": "Classic tuna with melted cheese",
      "available": true
    },
    {
      "id": "meatball_marinara",
      "name": "Meatball Marinara",
      "description": "Italian meatballs in marinara sauce",
      "available": true
    }
  ]
}
```

Don't forget to register this file in your `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/sandwiches.json
```

### **Loading and parsing JSON**

To load JSON data in Flutter, you'll need to first read the file as a string using `rootBundle.loadString()`. Next, parse the JSON string using the `dart:convert` library (it is included in the Dart SDK by default). Finally, extract the relevant fields from the parsed data and convert the parsed data into your model objects.

Here's a basic example of how to load the JSON file:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadSandwichData() async {
  final String jsonString = await rootBundle.loadString('assets/sandwiches.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData['sandwiches']);
}
```

### **Updating your model**

You'll need to use your AI tools to update your `Sandwich` model to work with this data. Make sure to add:

- A factory constructor like `Sandwich.fromJson(Map<String, dynamic> json)` to create sandwich objects from JSON data
- An `id` field to identify each sandwich type
- A `description` and an `available` field

We will learn more about factory constructors in [Worksheet 8](./worksheet-8.md), but for now think of them as alternative constructors that can create objects from different data sources (like JSON) rather than requiring all parameters to be passed directly.

The enum approach can still be useful for bread types and sizes, but sandwich types can now be loaded dynamically.

### **Alternative: CSV files**

If you prefer a simpler format that's easy to edit in spreadsheet applications, you could use CSV instead. Here's what `sandwiches.csv` might look like:

```csv
id,name,description,available
veggie_delight,Veggie Delight,Fresh vegetables with your choice of bread,true
chicken_teriyaki,Chicken Teriyaki,Tender chicken with teriyaki sauce,true
tuna_melt,Tuna Melt,Classic tuna with melted cheese,true
meatball_marinara,Meatball Marinara,Italian meatballs in marinara sauce,true
```

You would need to write a parser to split each line by commas and create sandwich objects. Ask your AI assistant about the pros and cons of CSV vs JSON for this use case.

### **Where to implement data handling**

The best place to handle data loading is in a **repository** class. You could create a `SandwichRepository` in the `repositories` folder that loads the sandwich data from the file, stores it temporarily in memory (caches it) so you don't reload it every time and ultimately provides methods like `getAllSandwiches()` or `getSandwichById(String id)`.

This follows the MVVM architecture pattern we introduced in [Worksheet 4](./worksheet-4.md), keeping data access logic separate from your UI code.

### **Handling asynchronous data**

Since loading files is an asynchronous operation, you'll need to use `FutureBuilder` or similar widgets to handle the loading state in your UI. Don't worry if you don't fully understand the code or the concept of asynchronous programming yet; we will cover this in more detail in future worksheets. For now, just be aware that the data loading process won't be instantaneous. `snapshot.connectionState` helps you determine whether the data is still loading, has loaded successfully, or encountered an error. Based on this, the UI (in this case the dropdown menu) can display a loading indicator, an error message, or the actual data.

Here's a basic pattern:

```dart
FutureBuilder<List<Sandwich>>(
  future: sandwichRepository.getAllSandwiches(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error loading sandwiches');
    }
    // Use snapshot.data to build your dropdown
    return DropdownMenu(...);
  },
)
```

#### **Commit your changes (6)**

If you have implemented any of the above optional JSON/CSV loading functionality, make sure to commit your changes before moving on. You should have ideally committed each logical change separately (e.g., adding the JSON file, updating the model, creating the repository, updating the UI).

## **Exercises**

Complete the exercises below and show your work to a member of staff at your next practical session for a **sign-off**.

Even though your AI assistant may suggest this, for now, try not to use any third-party packages, only built-in Flutter widgets.

1. Our app currently only shows a message (`confirmationMessage`) in the debug console when items are added to the cart. Let's display this message in the UI instead.

    If you are using Copilot (or Gemini in Firebase), switch to Ask mode and write a prompt that explain what feature you want to implement (ideally with a use case/user story). Ask it to suggest a suitable Flutter widget to display this message on the screen. For each widget it suggests, ask it to explain why that widget is appropriate and how to implement it (ask it to provide code snippets). Take your time to understand each approach and decide which widget you want to use before switching back to Edit or Agent mode to implement it.

    Alternatively, use a browser based AI assistant but provide it with sufficient context about your app and what you want to achieve or manually browse [the catalog of Flutter widgets](https://docs.flutter.dev/ui/widgets) to find a suitable widget for this task. You may instead consider using the desktop version of your AI tool or a CLI-based AI tool that can access your files directly. For more information on this, visit [worksheet 3](./worksheet-3.md).

    Remember not to implement a separate page or a permanent UI for the cart in the home page yet. We will do that in a later exercise. Once you are done, update the widget tests to reflect your changes.

    ⚠️ **Show your running app displaying the confirmation message and the updated widget tests to a member of staff** for a sign-off.

2. In addition of just showing a confirmation message when items are added, let's show th number of items in the cart and maybe the total price to the user.

    Similar to the previous exercise, there are several ways to do this. Try to do this in a way you understand. Maybe think about how popular (food) shopping apps display a summary of the user's cart when they are not in the cart page. Just make sure that when the "Add to Cart" button is pressed, this summary is updated. As always, make sure to write widget tests to verify that the cart summary updates correctly when items are added.

    ⚠️ **Show your running app with the cart summary displaying the number of items and the updated widget tests to a member of staff** for a sign-off.

3. (Advanced) So far, our app only has one screen (`main.dart`). Let's add a second screen to view the cart contents. This is a task which we will cover in more detail in the next worksheet, but let's give it a try now. Here's a [link to the Flutter documentation on navigation](https://docs.flutter.dev/cookbook/navigation/navigation-basics) to help you get started.

    Create a new `StatefulWidget` called `CartScreen` (and its associated state class) in `main.dart` for now. It should display a list of all items in the cart. Each item should show the sandwich name, size, bread type, quantity, and individual total price.

    Think about what pieces of information would be most useful to display in the cart view and how the user might reach/interact with this screen. Write a user story if you are planning to use your AI assistant to help you implement this and make sure to provide sufficient context (e.g., the `Cart` model and its methods).

    Hint: You can use `Navigator.push()` to navigate to the cart screen and `Navigator.pop()` to go back to the main screen. Also, your `CartScreen` will need access to the cart data, so you'll need to pass it through the constructor. To display multiple items from a collection, you can use a for loop inside a `Column`'s children list like this:

    ```dart
    Column(
      children: [
        for (String item in itemList)
          Text(item),
      ],
    )
    ```

    Once you have implemented the new page, move the `CartScreen` widget to a new file called `cart_screen.dart` inside the `views` folder and import it where you are using it (in `OrderScreen`). You could additionally create a `order_screen.dart` file for the `OrderScreen` and `OrderScreenState` classes if you wish. This way, `main.dart` will be short and simple, only containing the `App` class and the `main()` function.

    This is what your `lib/main.dart` file may look like after the refactoring:

    ```dart
    import 'package:flutter/material.dart';
    import 'package:sandwich_shop/views/order_screen.dart';

    void main() {
      runApp(const App());
    }

    class App extends StatelessWidget {
      const App({super.key});

      @override
      Widget build(BuildContext context) {
        return const MaterialApp(
          title: 'Sandwich Shop App',
          home: OrderScreen(maxQuantity: 5),
        );
      }
    }
    ```

    Below is what your project folder may look like after this exercise. Remember to write widget tests to ensure the cart view behaves as expected.

    ```text
    sandwich_shop/
    ├── assets/
    │   └── images/
    ├── lib/
    │   ├── main.dart
    │   ├── views/
    │   │   ├── app_styles.dart
    │   │   ├── cart_screen.dart
    │   │   └── order_screen.dart
    │   ├── view_models/
    │   ├── models/
    │   │   ├── cart.dart
    │   │   └── sandwich.dart
    │   └── repositories/
    │       └── pricing_repository.dart
    ├── test/
    │   ├── views/
    │   │   ├── cart_screen_test.dart
    │   │   └── order_screen_test.dart
    │   ├── view_models/
    │   ├── models/
    │   │   ├── cart_test.dart
    │   │   └── sandwich_test.dart
    │   └── repositories/
    │       └── pricing_repository_test.dart
    ├── pubspec.yaml
    └── ...
    ```

    Notice that the widget tests for each screen are in separate files named after the screen they are testing. (Instead of a single `widget_test.dart` file we have `cart_screen_test.dart` and `order_screen_test.dart` files.)

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.

4. (Advanced) In the cart view, re-implement the order notes functionality, but this time for the entire order rather than individual sandwiches.

    Similar to what we used to have in [`main.dart`](https://github.com/manighahrmani/sandwich_shop/blob/5/lib/main.dart), add a `TextField` that allows users to add notes for the entire order (e.g., "No onions" or "Extra serviettes").

    Remember to store these notes in the `Cart` model. You may need to update the `Cart` class to include a `notes` property and a method to update it.

    As always remember to update the unit tests and widget tests to cover this new functionality.

    This task is **optional** and there's no need to show it to a member of staff for a sign-off.
