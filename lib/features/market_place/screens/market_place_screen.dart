import 'package:facebook_clone/constants/global_variables.dart';
import 'package:facebook_clone/features/market_place/screens/product_details_screen.dart';
import 'package:facebook_clone/models/product.dart';
import 'package:facebook_clone/models/user.dart';
import 'package:flutter/material.dart';

class MarketPlaceScreen extends StatefulWidget {
  static double offset = 0;
  const MarketPlaceScreen({super.key});

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  ScrollController scrollController =
      ScrollController(initialScrollOffset: MarketPlaceScreen.offset);
  ScrollController headerScrollController = ScrollController();

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
          'Laptop ASUS TUF Gaming A15 FA507NV-LP046W R7-7735HS|8GB|512GB|RTX™ 4060 8G',
      price: 29590000,
      user: User(name: 'Doraemon', avatar: 'assets/images/user/doraemon.jpg'),
      status: 'Đã qua sử dụng - Như mới',
      description:
          'Thông số kỹ thuật\n•	CPU	AMD Ryzen 7 7735HS 3.2GHz up to 4.75GHz 16MB\n•	RAM	8GB DDR5 4800MHz (2x SO-DIMM socket, up to 32GB SDRAM)\n•	Ổ cứng	512GB PCIe® 4.0 NVMe™ M.2 SSD (2230) (Còn trống 1 khe SSD M.2 PCIE)\n•	Card đồ họa	NVIDIA® GeForce RTX™ 4060 8GB GDDR6, Up to 2420MHz* at 140W (2370MHz Boost Clock+50MHz OC, 115W+25W Dynamic Boost)\n•	Màn hình	15.6" FHD (1920 x 1080) IPS, 144Hz, Wide View, 250nits, Narrow Bezel, Non-Glare with 72% NTSC, 100% sRGB, 75.35% Adobe RGB, G-Sync\n•	Cổng giao tiếp	1x Type C USB 4 support DisplayPort™ / G-SYNC\n•	1x USB 3.2 Gen 2 Type-C support DisplayPort™ / power delivery / G-SYNC\n•	2x USB 3.2 Gen 1 Type-A\n•	1x RJ45 LAN port\n•	1x HDMI 2.1 FRL\n•	1x 3.5mm Combo Audio Jack\n•	Audio	2-speaker system, Dolby Atmos\n•	Bàn phím	Backlit Chiclet Keyboard RGB\n•	Chuẩn LAN	10/100/1000 Mbps\n•	Chuẩn WIFI	Wi-Fi 6(802.11ax) (Dual band) (2X2)\n•	Bluetooth	v5.2\n•	Webcam	HD 720p\n•	Hệ điều hành	Windows 11 Home\n•	Pin	4 Cell 90WHrs\n•	Trọng lượng	2.2 kg\n•	Màu sắc	Jaeger Gray\n•	Kích thước	35.4 x 25.1 x 2.24 ~ 2.49 cm\n• Bảo hành 24 tháng chính hãng\n• Xuất xứ: Trung Quốc\n• Bảo hành chính hãng 24 tháng tại TTBH của Asus\n• Sản phẩm full box (Sản phẩm + sạc + hướng dẫn sử dụng )',
      location: 'Mỹ Tho',
      images: [
        'https://down-vn.img.susercontent.com/file/sg-11134201-7qvfj-lhxbgsjjv35kf8',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lhx8ohn6ivet9b',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lhx8ohn6enph87'
      ],
    ),
    Product(
      name: 'Điện thoại iPhone 14 Pro Max 256GB',
      price: 23680000,
      user: User(name: 'Minh Trí', avatar: 'assets/images/user/minhtri.jpg'),
      status: 'Đã qua sử dụng - Như mới',
      description:
          'Mới đây thì chiếc điện thoại iPhone 14 Pro Max 256GB cũng đã được chính thức lộ diện trên toàn cầu và đập tan bao lời đồn đoán bấy lâu nay, bên trong máy sẽ được trang bị con chip hiệu năng khủng cùng sự nâng cấp về camera đến từ nhà Apple.',
      location: 'Bình Dương',
      images: [
        'https://cdn.tgdd.vn/comment/54815677/2E796D29-3CA3-4B91-9D97-42DC190334E1JX5SC.jpeg',
        'https://cdn.tgdd.vn/comment/54450277/D7C0D7BA-AEA8-4B2E-8667-AFEA3C576886HKCAQ.jpeg',
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
      name: 'Áo dài cách tân suông phối tay tơ hiện đại',
      price: 320000,
      user: User(name: 'Bảo Ngân', avatar: 'assets/images/user/baongan.jpg'),
      status: 'Mới',
      description:
          '👉 Thiết kế : Tạo cảm giác thoải mái không bị nóng, không sợ xuyên thấu.\n👉 Áo dài nữ form chuẩn Đường may đẹp.\n👉 Vải lụa mềm, mịn, mát, co giãn tốt, bay tà. Vải  phù hợp may áo dài, ngoài ra có thể may áo lẻ, đầm...với phong cách trẻ trung, thanh lịch, giản dị phù hợp với mọi lứa tuổi. ',
      location: 'Tiền Giang',
      images: [
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lf837rylkh935a',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lf837rylnadzd6',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lf837rylooyf1a',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lf82hjplr68n17',
      ],
    ),
    Product(
      name:
          'Giày_Adidas Samba Low đế đen đế nâu, Giày Das Order mới 100% Full box billsize 36_43',
      price: 1150000,
      user: User(
          name: 'Vương Hồng Thúy',
          avatar: 'assets/images/user/vuonghongthuy.jpg'),
      status: 'Đã qua sử dụng - Như mới',
      description:
          '💥 Hình ảnh là do shop chụp 100% \n💥 Khách nhận hàng Đúng như mô tả\n💥 Không độn size sản phẩm\n💥 Gửi hàng nhanh nhất có thể\n💥 đóng hàng luôn đầy đủ full bill full box tặng kèm tất và hộp chống sốc',
      location: 'Hà Nội',
      images: [
        'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lkmf4auzqweo26',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lkmf4auztpjk60',
        'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-lkmf4auzphu8e2',
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    headerScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      headerScrollController.jumpTo(headerScrollController.offset +
          scrollController.offset -
          MarketPlaceScreen.offset);
      MarketPlaceScreen.offset = scrollController.offset;
    });
    return Scaffold(
      body: NestedScrollView(
        controller: headerScrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            toolbarHeight: 60,
            titleSpacing: 0,
            pinned: true,
            floating: true,
            primary: false,
            centerTitle: true,
            automaticallyImplyLeading: false,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            bottom: const PreferredSize(
                preferredSize: Size.fromHeight(0), child: SizedBox()),
            title: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        splashRadius: 20,
                        onPressed: () {},
                        icon: const ImageIcon(
                          AssetImage('assets/images/menu.png'),
                          color: Colors.black,
                          size: 50,
                        ),
                      ),
                      const Text(
                        'Marketplace',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                        ),
                        child: IconButton(
                          splashRadius: 18,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.person_rounded,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                        ),
                        child: IconButton(
                          splashRadius: 18,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.grey[200],
                          shadowColor: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/edit.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Bán',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.grey[200],
                          shadowColor: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/list.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Hạng mục',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 5,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lựa chọn hôm nay',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: GlobalVariables.secondaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Cai Lậy (huyện)',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Table(
                children: [
                  for (int i = 0; i < products.length - 1; i += 2)
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 5,
                              bottom: 10,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ProductDetailsScreen.routeName,
                                  arguments: products[i],
                                );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    products[i].images[0],
                                    fit: BoxFit.cover,
                                    width: (MediaQuery.of(context).size.width -
                                            5) /
                                        2,
                                    height: (MediaQuery.of(context).size.width -
                                            5) /
                                        2,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${products[i].price} đ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      const Icon(
                                        Icons.circle,
                                        size: 2,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          products[i].name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ProductDetailsScreen.routeName,
                                  arguments: products[i + 1],
                                );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    products[i + 1].images[0],
                                    fit: BoxFit.cover,
                                    width: (MediaQuery.of(context).size.width -
                                            5) /
                                        2,
                                    height: (MediaQuery.of(context).size.width -
                                            5) /
                                        2,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${products[i + 1].price} đ',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      const Icon(
                                        Icons.circle,
                                        size: 2,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          products[i + 1].name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
