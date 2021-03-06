import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class BoxOffice {
  final String totalBoxDes;
  final String totalBoxUnit;

  BoxOffice({this.totalBoxDes, this.totalBoxUnit});

  factory BoxOffice.fromJson(Map<String, dynamic> parseJson) {
    return BoxOffice(
        totalBoxDes: parseJson["totalBoxDes"],
        totalBoxUnit: parseJson["totalBoxUnit"]);
  }
}

//
class ActorItem {
  final String img;
  final String name;
  final String nameEn;

  ActorItem({this.img, this.nameEn, this.name});

  factory ActorItem.fromJson(Map<String, dynamic> parseJson) {
    return ActorItem(
        img: parseJson["img"],
        nameEn: parseJson["nameEn"],
        name: parseJson["name"]);
  }
}

//
class StageImgItem {
  final String imgUrl;

  StageImgItem({this.imgUrl});

  factory StageImgItem.fromJson(Map<String, dynamic> parseJson) {
    return StageImgItem(imgUrl: parseJson["imgUrl"]);
  }
}

//
class VideoInfo {
  final String hightUrl;
  final String img;
  final int videoId;

  VideoInfo({this.img, this.hightUrl, this.videoId});

  factory VideoInfo.fromJson(Map<String, dynamic> parseJson) {
    return VideoInfo(
        img: parseJson["img"],
        hightUrl: parseJson["hightUrl"],
        videoId: parseJson["videoId"]);
  }
}

//
class DirectorInfo {
  final String name;
  final String nameEn;

  DirectorInfo({this.name, this.nameEn});

  factory DirectorInfo.fromJson(Map<String, dynamic> parseJson) {
    return DirectorInfo(name: parseJson["name"], nameEn: parseJson["nameEn"]);
  }
}

//
class Basic {
  final List<ActorItem> actors;
  final DirectorInfo director;
  final String commentSpecial;
  final String img;
  final String mins;
  final String name;
  final String nameEn;
  final overallRating;
  final List<StageImgItem> stageImg;
  final String story;
  final List<String> type;
  final VideoInfo video;
  final movieId;

  Basic(
      {this.commentSpecial,
      this.img,
      this.movieId,
      this.mins,
      this.name,
      this.nameEn,
      this.overallRating,
      this.story,
      this.actors,
      this.director,
      this.stageImg,
      this.type,
      this.video});

  factory Basic.fromJson(Map<String, dynamic> parseJson) {
    //actor list
    List<dynamic> actorsOriginal = parseJson["actors"];
    List<ActorItem> actors =
        actorsOriginal.map((item) => ActorItem.fromJson(item)).toList();
    //director
    DirectorInfo inf = DirectorInfo.fromJson(parseJson["director"]);
    //type
    List<dynamic> typesOriginal = parseJson["type"];
    List<String> types = typesOriginal.map((item) => item.toString()).toList();
    //video
    VideoInfo info = VideoInfo.fromJson(parseJson["video"]);
    //stageimg
    List<dynamic> stagesImgOr = parseJson["stageImg"]["list"];
    List<StageImgItem> stageImgs =
        stagesImgOr.map((item) => StageImgItem.fromJson(item)).toList();
//
    return Basic(
        commentSpecial: parseJson["commentSpecial"],
        img: parseJson["img"],
        mins: parseJson["mins"],
        nameEn: parseJson["nameEn"],
        name: parseJson["name"],
        overallRating: parseJson["overallRating"],
        story: parseJson["story"],
        movieId: parseJson["movieId"],
        actors: actors,
        director: inf,
        stageImg: stageImgs,
        type: types,
        video: info);
  }
}

//--------------------------------------------------------------------------------------------------------------------------------------------

class CommentItem {
  final String content;
  final String locationName;
  final String nickname;
  final rating;
  final commentDate;
  final String headImg;
  final String title;

  CommentItem(
      {this.commentDate,
      this.content,
      this.locationName,
      this.nickname,
      this.headImg,
      this.title,
      this.rating});

  factory CommentItem.fromJson(Map<String, dynamic> parseJson) {
    var titleVal = "";
    if (parseJson.containsKey("title")) titleVal = parseJson["title"];
    //
    return CommentItem(
        commentDate: parseJson["commentDate"],
        content: parseJson["content"],
        locationName: parseJson["locationName"],
        title: titleVal,
        nickname: parseJson["nickname"],
        headImg: parseJson["headImg"],
        rating: parseJson["rating"]);
  }
}

//
class CommentData {
  final List<CommentItem> mini;
  final List<CommentItem> plus;

  CommentData({this.mini, this.plus});

  //
  factory CommentData.fromJson(List<dynamic> listMini, List<dynamic> listPlus) {
    List<CommentItem> lstMini =
        listMini.map((item) => CommentItem.fromJson(item)).toList();
    List<CommentItem> lstPlus =
        listPlus.map((item) => CommentItem.fromJson(item)).toList();
    return CommentData(mini: lstMini, plus: lstPlus);
  }
}

//全部短评列表--------------------------------------------------------------------------------------------------------------------------------------------
class ShortReviewItem {
  final String ca;
  final String caimg;
  final cd;
  final String ce;
  final cr;

  ShortReviewItem({this.ca, this.caimg, this.cd, this.ce, this.cr});

  factory ShortReviewItem.fromJson(Map<String, dynamic> parseJson) {
    return ShortReviewItem(
        ca: parseJson["ca"],
        caimg: parseJson["caimg"],
        cd: parseJson["cd"],
        ce: parseJson["ce"],
        cr: parseJson["cr"]);
  }
}

//
class ShortReviewData {
  final List<ShortReviewItem> items;

  ShortReviewData({this.items});

  factory ShortReviewData.fromJson(List<dynamic> listData) {
    List<ShortReviewItem> list1 =
        listData.map((item) => ShortReviewItem.fromJson(item)).toList();
    return ShortReviewData(items: list1);
  }
}

//provider 相关
class ShortReviewModel extends ChangeNotifier {
  final List<ShortReviewItem> items = [];

  //
  List<ShortReviewItem> getListData() => items;

  //
  void getNetData(String sMovieId, int index) async {
    Response response = await Dio().get(
        'https://api-m.mtime.cn/Showtime/HotMovieComments.api',
        queryParameters: {"movieId": sMovieId, "pageIndex": index.toString()});
    final jsonStr = json.decode(response.toString());
    items.addAll(ShortReviewData.fromJson(jsonStr["data"]["cts"]).items);
    notifyListeners();
  }
}

//全部长评列表--------------------------------------------------------------------------------------------------------------------------------------------------------------
class LongReviewItem {
  final String content;
  final String headurl;
  final modifyTime;
  final String nickname;
  final rating;
  final String title;

  LongReviewItem(
      {this.content,
      this.headurl,
      this.modifyTime,
      this.nickname,
      this.rating,
      this.title});

  factory LongReviewItem.parseJson(Map<String, dynamic> parseJson) {
    return LongReviewItem(
        content: parseJson["content"],
        headurl: parseJson["headurl"],
        modifyTime: parseJson["modifyTime"],
        nickname: parseJson["nickname"],
        rating: parseJson["rating"],
        title: parseJson["title"]);
  }
}

class LongReviewList {
  final List<LongReviewItem> listData;

  LongReviewList({this.listData});

  factory LongReviewList.fromJson(List<dynamic> items) {
    List<LongReviewItem> lstData =
        items.map((item) => LongReviewItem.parseJson(item)).toList();
    return LongReviewList(listData: lstData);
  }
}

//
class LongReviewModel extends ChangeNotifier {
  List<LongReviewItem> items = [];

  //
  List<LongReviewItem> getLongData() => items;

  //
  void getNetData(String movieId, int pageIndex) async {
    Response response = await Dio().get(
        'https://api-m.mtime.cn/Movie/HotLongComments.api',
        queryParameters: {"movieId": movieId, "pageIndex": pageIndex});
    final jsonStr = json.decode(response.toString());
    items.addAll(LongReviewList.fromJson(jsonStr["comments"]).listData);
    notifyListeners();
  }
}

//all video-----------------------------------------------------------------------------------------------------------------------------------------
class VideoItem {
  final String image;
  final length;
  final String playCount;
  final vId;
  final String title;

  //
  VideoItem({this.image, this.length, this.playCount, this.title, this.vId});

  //
  factory VideoItem.fromJson(Map<String, dynamic> param) {
    return VideoItem(
        image: param["image"],
        length: param["length"],
        playCount: param["playCount"],
        title: param["title"],
        vId: param["vId"]);
  }
}

class AllVideoData {
  final pageCount;
  final List<VideoItem> videoList;

  AllVideoData({this.pageCount, this.videoList});

  //
  factory AllVideoData.fromJson(
      Map<String, dynamic> param1, List<dynamic> lstData) {
    final pageCount1 = param1["pageCount"];
    List<VideoItem> items =
        lstData.map((item) => VideoItem.fromJson(item)).toList();
    return AllVideoData(pageCount: pageCount1, videoList: items);
  }
}

class AllVideoBloc extends ChangeNotifier {
  var pageCount = 1;
  final List<VideoItem> items = new List();

  AllVideoData getData() {
    return AllVideoData(pageCount: pageCount, videoList: items);
  }

  void getNetData(final movieId, int pageIndex) async {
    Response response = await Dio().get(
        'https://ticket-api-m.mtime.cn/movie/category/video.api',
        queryParameters: {
          "movieId": movieId.toString(),
          "pageIndex": pageIndex.toString()
        });
    //
    final jsonStr = json.decode(response.toString());
    AllVideoData data =
        AllVideoData.fromJson(jsonStr["data"], jsonStr["data"]["videoList"]);
    pageCount = data.pageCount;
    items.addAll(data.videoList);
    notifyListeners();
  }
}
