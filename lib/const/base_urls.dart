class ApiUrl {
  static const baseUrl = 'https://greenhouse-5wj5.onrender.com/';
  // static const baseUrl = 'http://172.70.106.12:3000/';
  static const login = 'vendorLogin';
  static const signUp = 'vendorRegister';
  static const sendOtpVendor = 'sendOtpVendor';
  static const verifyOtpVendor = 'verifyOtpVendor';

  static const category = 'category';
  static const addNewCategory = 'addNewCategory';
  static const subcategory = 'subcategory';
  static const addSubCategory = 'addSubCategory';
  static const specificCategory = 'specificCategory';
  static const products = 'products';
  static const addNewProduct = 'addNewProduct';
  static const deleteProduct = 'deleteProduct';
  static const updateProduct = 'updateProduct';
  static const productByCatId = 'productByCatId';
  static const productBySubCatId = 'productBySubCatId';
  static const productDetails = 'productDetails';

  static const addToCart = 'add/cart';
  static const checkExistInCart = 'check/cart';
  static const incToCart = 'inc/cart';
  static const decToCart = 'dec/cart';
  static const getCartList = 'cart';
  static const deleteCart = 'delete/cart';

  static const getWishlist = 'wishlist-products';
  static const addWishlist = 'add-wishlist';

  static const getDefaultAddress = 'getDefaultAddress';
  static const updateDefaultAddress = 'updateDefaultAddress';
  static const getAllAddress = 'getAllAddress';
  static const setAddress = 'addAddress';
  static const specificAddress = 'specificAddress';

  static const placeorder = 'placeorder';
  static const allUserOrders = 'allUserOrders';
  static const allOrders = 'allOrders';
  static const orderStatus = 'orderStatus';

  static const addpayment = 'addpayment';
  static const allpayments = 'allpayments';
  static const orderListSpecificOrder = 'orderListSpecificOrder';
}
