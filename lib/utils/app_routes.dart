enum AppRoutes {
  productDetail('/product-detail'),
  cart('/cart'),
  productsOverviewScreen('/products-overview-screen'),
  orders('/orders'),
  products('/products'),
  productForm('/product-form'),
  auth('/');

  final String name;

  const AppRoutes(this.name);
}
