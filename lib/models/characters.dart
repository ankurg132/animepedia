class AnimeData {
  Data? data;

  AnimeData({this.data});

  AnimeData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Page? page;

  Data({this.page});

  Data.fromJson(Map<String, dynamic> json) {
    page = json['Page'] != null ? new Page.fromJson(json['Page']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.page != null) {
      data['Page'] = this.page!.toJson();
    }
    return data;
  }
}

class Page {
  PageInfo? pageInfo;
  List<Media>? media;

  Page({this.pageInfo, this.media});

  Page.fromJson(Map<String, dynamic> json) {
    pageInfo = json['pageInfo'] != null
        ? new PageInfo.fromJson(json['pageInfo'])
        : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pageInfo != null) {
      data['pageInfo'] = this.pageInfo!.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PageInfo {
  late int currentPage;
  late bool hasNextPage;
  late int perPage;

  PageInfo({currentPage, hasNextPage, perPage});

  PageInfo.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    hasNextPage = json['hasNextPage'];
    perPage = json['perPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['hasNextPage'] = this.hasNextPage;
    data['perPage'] = this.perPage;
    return data;
  }
}

class Media {
  int? id;
  Title? title;
  String? type;
  String? description;
  StartDate? startDate;
  StartDate? endDate;
  CoverImage? coverImage;
  String? bannerImage;
  int? duration;
  bool? isAdult;
  List<String>? genres;
  int? averageScore;
  int? popularity;
  int? episodes;
  int? chapters;
  int? volumes;
  String? countryOfOrigin;
  String? hashtag;

  Media(
      {this.id,
      this.title,
      this.type,
      this.description,
      this.startDate,
      this.endDate,
      this.coverImage,
      this.bannerImage,
      this.duration,
      this.isAdult,
      this.genres,
      this.averageScore,
      this.popularity,
      this.episodes,
      this.chapters,
      this.volumes,
      this.countryOfOrigin,
      this.hashtag});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    type = json['type'];
    description = json['description'];
    startDate = json['startDate'] != null
        ? new StartDate.fromJson(json['startDate'])
        : null;
    endDate = json['endDate'] != null
        ? new StartDate.fromJson(json['endDate'])
        : null;
    coverImage = json['coverImage'] != null
        ? new CoverImage.fromJson(json['coverImage'])
        : null;
    duration = json['duration'];
    isAdult = json['isAdult'];
    genres = json['genres'].cast<String>();
    averageScore = json['averageScore'];
    popularity = json['popularity'];
    episodes = json['episodes'];
    chapters = json['chapters'];
    volumes = json['volumes'];
    countryOfOrigin = json['countryOfOrigin'];
    hashtag = json['hashtag'];
    bannerImage = json['bannerImage'];
    }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['type'] = this.type;
    data['description'] = this.description;
    if (this.startDate != null) {
      data['startDate'] = this.startDate!.toJson();
    }
    if (this.endDate != null) {
      data['endDate'] = this.endDate!.toJson();
    }
    if (this.coverImage != null) {
      data['coverImage'] = this.coverImage!.toJson();
    }
    data['duration'] = this.duration;
    data['isAdult'] = this.isAdult;
    data['genres'] = this.genres;
    data['averageScore'] = this.averageScore;
    data['popularity'] = this.popularity;
    data['episodes'] = this.episodes;
    data['chapters'] = this.chapters;
    data['volumes'] = this.volumes;
    data['countryOfOrigin'] = this.countryOfOrigin;
    data['hashtag'] = this.hashtag;
    return data;
  }
}

class Title {
  String? romaji;
  String? english;
  String? native;

  Title({this.romaji, this.english, this.native});

  Title.fromJson(Map<String, dynamic> json) {
    romaji = json['romaji'];
    english = json['english'];
    native = json['native'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['romaji'] = this.romaji;
    data['english'] = this.english;
    data['native'] = this.native;
    return data;
  }
}

class StartDate {
  int? year;
  int? month;
  int? day;

  StartDate({this.year, this.month, this.day});

  StartDate.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    return data;
  }
}

class CoverImage {
  String? medium;

  CoverImage({this.medium});

  CoverImage.fromJson(Map<String, dynamic> json) {
    medium = json['medium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medium'] = this.medium;
    return data;
  }
}
