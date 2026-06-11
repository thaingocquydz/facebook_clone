import 'package:carousel_slider/carousel_slider.dart';
import 'package:facebook_clone/constants/global_variables.dart';
import 'package:facebook_clone/features/market_place/screens/product_details_screen.dart';
import 'package:facebook_clone/models/product.dart';
import 'package:facebook_clone/models/user.dart';
import 'package:flutter/material.dart';

class RelatedProducts extends StatefulWidget {
  const RelatedProducts({super.key});

  @override
  State<RelatedProducts> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  final List<Product> products = [
    Product(
      name:
          'Thuốc Nhuộm Tóc Màu XANH DƯƠNG ĐEN KHÓI, Xanh Đen Khói Không Tẩy | Chenglovehair, Chenglovehairs',
      price: 160000,
      user:
          User(name: 'Minh Hương', avatar: 'assets/images/user/minhhuong.jpg'),
      status: 'Mới',
      description:
          'Thuốc nhuộm tóc màu Xanh Dương Đen Khói không tẩy\n💙 Xanh Dương Đen Khói trầm hơn Light Blue Sea và sáng hơn Xanh Than - một màu xanh cân bằng để ai cũng có thể nhuộm được. Điểm "ăn khách" nhất ở màu này theo Cheng chính là ánh khói nhẹ nhàng, giúp cho mái tóc có độ bóng cực kì ảo diệu mà vẫn giữ được nền tối hợp với mọi tone da.\n💙 Xanh Dương Đen Khói mang vẻ đẹp năng động, hiện đại và cá tính. Không chỉ hợp với những chuyến du lịch, chụp ảnh, nhuộm tóc màu Xanh Dương Đen Khói nhẹ có thể diện đi học, đi làm mà không bị lộ liễu hay rực rỡ quá.\n💙 Thuốc nhuộm Xanh Dương Đen Khói chỉ từ 65k. Hãy nhắn tin cho Cheng nếu bạn cần tư vấn thêm về cách nhuộm tại nhà.\n🔸 Tặng ngay 1 lọ trợ dưỡng khi mua hàng\n🔸 Phù hợp với mọi tone da\n🔸 Lên từ nền tóc đen tự nhiên không cần nâng tẩy\n🔸 Độ bền màu: 1-1,5 tháng\n🔸 Cách sử dụng: trộn thuốc nhuộm tóc Xanh Dương Đen Khói theo công thức và làm theo các bước nhuộm. Tất cả có trong hướng dẫn đính kèm sản phẩm.',
      location: 'Hồ Chí Minh',
      images: [
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj2ffdt2aolo12',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj2ffdssb37wc7',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj2ffdssqjgs56',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj2ffdsschsc07',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj2ffdssdwcs54',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj2ffdssfax8be',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lj2ffdssgpho9e',
      ],
    ),
    Product(
      name:
          'Set trang phục nữ MURIOKI gồm áo cardigan dệt kim dáng ngắn và chân váy ngắn ôm hông thời trang',
      price: 149000,
      user: User(name: 'Hà Linhh', avatar: 'assets/images/user/halinh.jpg'),
      status: 'Mới',
      description:
          '👇Chi tiết sản phẩm👇\nMàu sắc: Hồng/ khaki\nKích thước: S, M, L, XL,\nPhong cách: Gợi cảm\nChất vải chính: Sợi polyester\nKiểu dáng: Ôm sát\nLoại trang phục: Bộ chân váy\nHình dạng cổ áo: Cổ vuông\nChiều dài tay áo: Tay ngắn \nCác yếu tố phổ biến: Dệt kim\nThích hợp cho: Tiệc tùng, kỳ nghỉ, bãi biển, hẹn hò',
      location: 'Hồ Chí Minh',
      images: [
        'https://down-vn.img.susercontent.com/file/sg-11134211-7qvdl-lf0nyz2vq1yhc1',
        'https://down-vn.img.susercontent.com/file/a8916375b8b9a0770751a4ececca8604',
        'https://down-vn.img.susercontent.com/file/c7e3bc7cfbac3f913182aad21c7c9e5e',
        'https://down-vn.img.susercontent.com/file/10e207c47c07fffa110c5c208c7f58df',
      ],
    ),
    Product(
      name: 'Váy khoét lưng Mina dress dáng dài tiểu thư',
      price: 139000,
      user: User(
          name: 'Nguyễn Thị Minh Tuyền',
          avatar: 'assets/images/user/minhtuyen.jpg'),
      status: 'Đã qua sử dụng - Như mới',
      description: 'Sản phẩm 100% giống mô tả',
      location: 'Đồng Nai',
      images: [
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-livgbmwjka8i3c',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-livgbmwjhh3m53',
      ],
    ),
    Product(
      name: 'Váy 2 dây dáng dài chun lưng phong cách Hàn Quốc',
      price: 129000,
      user: User(name: 'Khánh Vy', avatar: 'assets/images/user/khanhvy.jpg'),
      status: 'Mới',
      description:
          '- Chất vải kaki hàn quốc, váy mềm mại thích hợp 4 mùa\n- Sản phẩm 100% giống mô tả. Hình ảnh sản phẩm là ảnh thật do shop tự chụp và giữ bản quyền hình ảnh\n- Xuất xứ: được thiết kế và gia công bởi xixeoshop.',
      location: 'Cần Thơ',
      images: [
        'https://down-vn.img.susercontent.com/file/sg-11134201-22100-9uflrvt69piv6f',
        'https://down-vn.img.susercontent.com/file/sg-11134201-23010-gp0rfbdv8amve9',
        'https://down-vn.img.susercontent.com/file/sg-11134201-23010-kvpedtfw8amv59',
        'https://down-vn.img.susercontent.com/file/vn-11134201-7qukw-lere6ek7u2xj3b',
        'https://down-vn.img.susercontent.com/file/vn-11134201-7qukw-lere6ells1uf6e',
        'https://down-vn.img.susercontent.com/file/sg-11134201-22100-detjvwt69piv8a',
        'https://down-vn.img.susercontent.com/file/sg-11134201-23010-cgru6vuf0amv1b',
        'https://down-vn.img.susercontent.com/file/vn-11134201-7qukw-lere6e6mdz0q50',
      ],
    ),
  ];

  List<int> _current = [];
  @override
  void initState() {
    super.initState();
    _current = List.filled(products.length, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        for (int i = 0; i < products.length - 1; i += 2)
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black12, width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage(products[i].user.avatar),
                              radius: 15,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              products[i].user.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ProductDetailsScreen.routeName,
                            arguments: products[i],
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  CarouselSlider(
                                    items: products[i].images.map((e) {
                                      return Builder(
                                        builder: (BuildContext context) =>
                                            Image.network(
                                          e,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      );
                                    }).toList(),
                                    options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current[i] = index;
                                        });
                                      },
                                      height: 200,
                                      padEnds: false,
                                      scrollDirection: Axis.horizontal,
                                      clipBehavior: Clip.none,
                                      enableInfiniteScroll: false,
                                      viewportFraction: 1,
                                    ),
                                  ),
                                  Positioned.fill(
                                    bottom: 10,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: products[i]
                                            .images
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return Container(
                                            width: 6,
                                            height: 6,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 3),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withOpacity(
                                                    _current[i] == entry.key
                                                        ? 1
                                                        : 0.5)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    products[i].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.more_horiz_rounded,
                                  size: 16,
                                  color: GlobalVariables.iconColor,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black12, width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage(products[i + 1].user.avatar),
                              radius: 15,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              products[i + 1].user.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            ProductDetailsScreen.routeName,
                            arguments: products[i + 1],
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  CarouselSlider(
                                    items: products[i + 1].images.map((e) {
                                      return Builder(
                                        builder: (BuildContext context) =>
                                            Image.network(
                                          e,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      );
                                    }).toList(),
                                    options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current[i + 1] = index;
                                        });
                                      },
                                      height: 200,
                                      padEnds: false,
                                      scrollDirection: Axis.horizontal,
                                      clipBehavior: Clip.none,
                                      enableInfiniteScroll: false,
                                      viewportFraction: 1,
                                    ),
                                  ),
                                  Positioned.fill(
                                    bottom: 10,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: products[i + 1]
                                            .images
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return Container(
                                            width: 6,
                                            height: 6,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 3),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withOpacity(
                                                    _current[i + 1] == entry.key
                                                        ? 1
                                                        : 0.5)),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    products[i + 1].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.more_horiz_rounded,
                                  size: 16,
                                  color: GlobalVariables.iconColor,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
