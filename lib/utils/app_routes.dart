enum AppRoutes {
  productDetail('/product-detail'),
  cart('/cart'),
  productsOverviewScreen('/products-overview-screen');

  final String name;

  const AppRoutes(this.name);
}
