enum AppRoutes {
  productDetail('/product-detail'),
  cart('/cart'),
  productsOverviewScreen('/products-overview-screen'),
  orders('/orders');

  final String name;

  const AppRoutes(this.name);
}
