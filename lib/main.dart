import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(NikeStoreApp());
}

class NikeStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nike Store',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4C1D95),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Color(0xFF071129),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardColor: Color(0xFF071A2A),
        // Card elevation/shape handled per widget to avoid SDK compatibility issues.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6D28D9),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Color(0xFF0E1720),
          labelStyle: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          selectedColor: Color(0xFF6D28D9),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF0B1320),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF0A1520),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: ProductPage(),
    );
  }
}

// ================= MODEL =================
class Product {
  final String name;
  final int price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

// ================= DATA =================
List<Product> products = [
  Product(
    name: 'Nike Air Max',
    price: 1500000,
    imageUrl: 'assets/images/nike_air_max.png',
  ),
  Product(
    name: 'Nike Revolution',
    price: 900000,
    imageUrl: 'assets/images/nike_revolution.png',
  ),
  Product(
    name: 'Nike Zoom Fly',
    price: 1800000,
    imageUrl: 'assets/images/nike_zoom_fly.png',
  ),
  Product(
    name: 'Nike Pegasus',
    price: 1350000,
    imageUrl: 'assets/images/nike_pegasus.png',
  ),
  Product(
    name: 'Nike Classic',
    price: 750000,
    imageUrl: 'assets/images/nike_classic.png',
  ),
];

List<Product> cart = [];

// ================= HALAMAN PRODUK =================
class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController _pageController = PageController(viewportFraction: 0.93);
  int _page = 0;
  String _query = '';
  bool _imagesPrecached = false;

  List<Product> get filtered => _query.isEmpty
      ? products
      : products
            .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      for (var p in products) {
        precacheImage(AssetImage(p.imageUrl), context);
      }
      _imagesPrecached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4C1D95), Color(0xFF0EA5A3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.directions_run),
            SizedBox(width: 8),
            Text('Nike Store', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              SizedBox(height: 12),
              _buildCarousel(),
              SizedBox(height: 12),
              _buildCategories(),
              SizedBox(height: 12),
              Expanded(child: _buildGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari sepatu, kategori, model...',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (v) => setState(() => _query = v),
    );
  }

  Widget _buildCarousel() {
    final promos = products.take(3).toList();
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _page = i),
        itemCount: promos.length,
        itemBuilder: (context, index) {
          final p = promos[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    p.imageUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 1200,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rp ${p.price}',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    final cats = ['Running', 'Lifestyle', 'Training', 'Basketball'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (c, i) => Chip(label: Text(cats[i])),
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemCount: cats.length,
      ),
    );
  }

  Widget _buildGrid() {
    final list = filtered;
    return GridView.builder(
      padding: EdgeInsets.only(
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final p = list[index];
        return _buildProductCard(p);
      },
    );
  }

  Widget _buildProductCard(Product p) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    p.imageUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 700,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(p.name, style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('Rp ${p.price}', style: TextStyle(color: Colors.grey[700])),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add_shopping_cart_outlined),
                      label: Text('Tambah'),
                      onPressed: () {
                        setState(() => cart.add(p));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"${p.name}" ditambahkan')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HALAMAN KERANJANG =================
class CartPage extends StatelessWidget {
  int getTotal() {
    int total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4C1D95), Color(0xFF0EA5A3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('Keranjang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: cart.isEmpty
                  ? Center(child: Text('Keranjang kosong'))
                  : ListView.separated(
                      itemCount: cart.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, i) {
                        final item = cart[i];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              item.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              cacheWidth: 112,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 20,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                            ),
                          ),
                          title: Text(item.name),
                          trailing: Text('Rp ${item.price}'),
                        );
                      },
                    ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${getTotal()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Checkout'),
                onPressed: cart.isEmpty
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CheckoutPage()),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= HALAMAN CHECKOUT =================
class CheckoutPage extends StatelessWidget {
  int getTotal() {
    int total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4C1D95), Color(0xFF0EA5A3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Bayar',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 8),
                Text(
                  'Rp ${getTotal()}',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Bayar Sekarang'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InvoicePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= HALAMAN NOTA =================
class InvoicePage extends StatelessWidget {
  int getTotal() {
    int total = 0;
    for (var item in cart) {
      total += item.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4C1D95), Color(0xFF0EA5A3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('Nota Pembelian'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NOTA NIKE STORE',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Expanded(
              child: ListView(
                children: cart.map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name),
                    trailing: Text('Rp ${item.price}'),
                  );
                }).toList(),
              ),
            ),
            Divider(),
            Text(
              'TOTAL: Rp ${getTotal()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              child: Text('Selesai'),
              onPressed: () {
                cart.clear();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
