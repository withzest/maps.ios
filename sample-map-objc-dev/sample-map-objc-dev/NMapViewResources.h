//
//  NMapViewResources.h
//  sample-map-objc-dev
//
//  Created by Naver on 2016. 11. 23..
//  Copyright © 2016년 Naver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NMapViewerSDK/NMapView.h>

//
// POI flag type : User Defined
//
static const NMapPOIflagType UserPOIflagTypeDefault = NMapPOIflagTypeReserved + 1;
static const NMapPOIflagType UserPOIflagTypeInvisible = NMapPOIflagTypeReserved + 2;

@interface NMapViewResources : NSObject

+ (UIImage *)imageWithType:(NMapPOIflagType) poiFlagType selected:(BOOL)selected;

+ (CGPoint)anchorPoint:(NMapPOIflagType)poiFlagType;

@end
