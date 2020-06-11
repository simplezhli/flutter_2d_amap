
class PoiSearch {

  PoiSearch({
		this.cityCode,
		this.cityName,
		this.provinceName,
		this.title,
		this.adName,
		this.provinceCode,
		this.latitude,
		this.longitude,
  });

	PoiSearch.fromJsonMap(Map<String, dynamic> map): 
		cityCode = map['cityCode'] as String,
		cityName = map['cityName'] as String,
		provinceName = map['provinceName'] as String,
		title = map['title'] as String,
		adName = map['adName'] as String,
		provinceCode = map['provinceCode'] as String,
		latitude = map['latitude'] as String,
		longitude = map['longitude'] as String;

	String cityCode;
	String cityName;
	String provinceName;
	String title;
	String adName;
	String provinceCode;
	String latitude;
	String longitude;

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
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
