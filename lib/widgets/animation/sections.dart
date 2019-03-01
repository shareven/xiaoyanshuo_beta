// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Raw data for the animation demo.

import 'package:flutter/material.dart';
import 'package:xiaoyanshuo_beta/config/Global.dart';

const Color _mariner = Color(0xFF3B5F8F);
const Color _mediumPurple = Color(0xFF8266D4);
const Color _tomato = Color(0xFFF95B57);
const Color _mySin = Color(0xFFF3A646);

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class SectionDetail {
  const SectionDetail({
    this.title,
    this.subtitle,
    this.imageAsset,
    this.imageAssetPackage,
  });
  final String title;
  final String subtitle;
  final String imageAsset;
  final String imageAssetPackage;
}

class Section {
  const Section({
    this.title,
    this.backgroundAsset,
    this.backgroundAssetPackage,
    this.leftColor,
    this.rightColor,
    this.details,
  });
  final String title;
  final String backgroundAsset;
  final String backgroundAssetPackage;
  final Color leftColor;
  final Color rightColor;
  final List<SectionDetail> details;

  @override
  bool operator==(Object other) {
    if (other is! Section)
      return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}
// the const vars like _eyeglassesDetail and insert a variety of titles and
// image SectionDetails in the allSections list.

const SectionDetail _eyeglassesDetail = SectionDetail(
  imageAsset: Global.bannerImg1,
  imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _eyeglassesImageDetail = SectionDetail(
  imageAsset: Global.bannerImg1,
  imageAssetPackage: _kGalleryAssetsPackage,
);

const SectionDetail _seatingDetail = SectionDetail(
  imageAsset: Global.bannerImg2,
  imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _seatingImageDetail = SectionDetail(
  imageAsset: Global.bannerImg2,
  imageAssetPackage: _kGalleryAssetsPackage,
);

const SectionDetail _decorationDetail = SectionDetail(
  imageAsset: Global.bannerImg3,
  imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _decorationImageDetail = SectionDetail(
  imageAsset: Global.bannerImg3,
  imageAssetPackage: _kGalleryAssetsPackage,
);

const SectionDetail _protectionDetail = SectionDetail(
  imageAsset: Global.bannerImg1,
  imageAssetPackage: _kGalleryAssetsPackage,
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _protectionImageDetail = SectionDetail(
  imageAsset: Global.bannerImg1,
  imageAssetPackage: _kGalleryAssetsPackage,
);

final List<Section> allSections = <Section>[
  const Section(
    title: 'SUNGLASSES',
    leftColor: _mediumPurple,
    rightColor: _mariner,
    backgroundAsset: Global.bannerImg1,
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: <SectionDetail>[
      _eyeglassesDetail,
      _eyeglassesImageDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
    ],
  ),
  const Section(
    title: 'FURNITURE',
    leftColor: _tomato,
    rightColor: _mediumPurple,
    backgroundAsset: Global.bannerImg2,
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: <SectionDetail>[
      _seatingDetail,
      _seatingImageDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
    ],
  ),
  const Section(
    title: 'JEWELRY',
    leftColor: _mySin,
    rightColor: _tomato,
    backgroundAsset:Global.bannerImg3,
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: <SectionDetail>[
      _decorationDetail,
      _decorationImageDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
    ],
  ),
  const Section(
    title: 'HEADWEAR',
    leftColor: Colors.white,
    rightColor: _tomato,
    backgroundAsset: Global.bannerImg2,
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: <SectionDetail>[
      _protectionDetail,
      _protectionImageDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
    ],
  ),
];
