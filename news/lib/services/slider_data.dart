import 'package:news/model/slider_model.dart';

List<SliderModel> getSlider() {
  List<SliderModel> slider = [];
  SliderModel sliderModel = new SliderModel();

  sliderModel.name = "Business";
  sliderModel.image = "assets/images/business.jpg";
  slider.add(sliderModel);
  sliderModel = new SliderModel();

  sliderModel.name = "Entertainment";
  sliderModel.image = "assets/images/entertainment.jpg";
  slider.add(sliderModel);
  sliderModel = new SliderModel();

  sliderModel.name = "General";
  sliderModel.image = "assets/images/general.jpg";
  slider.add(sliderModel);
  sliderModel = new SliderModel();

  sliderModel.name = "Health";
  sliderModel.image = "assets/images/health.jpg";
  slider.add(sliderModel);
  sliderModel = new SliderModel();

  sliderModel.name = "Sports";
  sliderModel.image = "assets/images/sports.jpg";
  slider.add(sliderModel);
  sliderModel = new SliderModel();

  return slider;
}
