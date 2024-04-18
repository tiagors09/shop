enum AppRoutes {
  productDetail('/product-detail'),
  cart('/cart'),
  productsOverviewScreen('/products-overview-screen'),
  orders('/orders'),
  products('/products');

  final String name;

  const AppRoutes(this.name);
}
