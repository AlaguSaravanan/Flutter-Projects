import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/services/data.dart';
import 'package:news/services/slider_data.dart';

import '../model/category_model.dart';
import '../model/slider_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];

  double? _deviceHeight, _deviceWidth;

  @override
  void initState() {
    categories = getCategories();
    sliders = getSlider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter ',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(
              'News',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            )
          ],
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: _deviceHeight! * 0.15,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CategoryTile(
                    image: categories[index].image,
                    categoryName: categories[index].categoryName,
                  );
                },
                itemCount: categories.length,
              ),
            ),
            Container(
              child: CarouselSlider(
                items: generateSliderItems(sliders),
                options: CarouselOptions(
                    height: _deviceHeight! * 0.30,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> generateSliderItems(List<SliderModel> sliders) {
    return List<Widget>.generate(sliders.length, (index) {
      String? res = sliders[index].image;
      String? res1 = sliders[index].name;
      return _buildImage(res, index, res1);
    });
  }

  Widget _buildImage(String urlImage, int index, String name) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              urlImage,
              fit: BoxFit.cover,
              width: _deviceWidth!,
            ),
          ),
          Container(

            width: _deviceWidth!,
            height: _deviceHeight! * 0.15,
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatefulWidget {
  final image, categoryName;

  CategoryTile({super.key, this.image, this.categoryName});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  double? _deviceHeight, _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(5),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              widget.image,
              width: _deviceWidth! * 0.30,
              height: _deviceHeight! * 0.10,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black45,
            ),
            width: _deviceWidth! * 0.30,
            height: _deviceHeight! * 0.10,
            child: Center(
              child: Text(
                widget.categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
