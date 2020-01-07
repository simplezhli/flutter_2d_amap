
class PoiSearch {

  String cityCode;
  String cityName;
  String provinceName;
  String title;
  String adName;
  String provinceCode;
  String latitude;
  String longitude;

	PoiSearch.fromJsonMap(Map<String, dynamic> map): 
		cityCode = map['cityCode'],
		cityName = map['cityName'],
		provinceName = map['provinceName'],
		title = map['title'],
		adName = map['adName'],
		provinceCode = map['provinceCode'],
		latitude = map['latitude'],
		longitude = map['longitude'];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['cityCode'] = cityCode;
		data['cityName'] = cityName;
		data['provinceName'] = provinceName;
		data['title'] = title;
		data['adName'] = adName;
		data['provinceCode'] = provinceCode;
		data['latitude'] = latitude;
		data['longitude'] = longitude;
		return data;
	}
}
