//
//  NMapViewResource.h
//  NaverMap
//
//  Created by KJ KIM on 10. 9. 15..
//  Copyright 2010 NHN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NMapPOIitem.h"

// 
// POI flag type
//
enum {
	NMapPOIflagTypeBase = NMapPOIflagTypeReserved,	
		
	NMapPOIflagTypePin,
    NMapPOIflagTypeSpot,
	
	NMapPOIflagTypeFrom,
	NMapPOIflagTypeTo,	
	NMapPOIflagTypeNumber,
};

@interface NMapViewResource : NSObject {

}

+ (UIImage *) imageWithType:(NMapPOIflagType)poiFlagType iconIndex:(int)index selectedImage:(UIImage **)selectedImage;

+ (CGPoint) anchorPointWithType:(NMapPOIflagType)poiFlagType;

+ (UIImage*) imageForCalloutOverlayItem:(NMapPOIitem *)poiItem constraintSize:(CGSize)constraintSize selected:(BOOL)selected 
		  imageForCalloutRightAccessory:(UIImage *)imageForCalloutRightAccessory
						calloutPosition:(CGPoint *)calloutPosition calloutHitRect:(CGRect *)calloutHitRect;

+ (CGPoint) calloutOffsetWithType:(NMapPOIflagType)poiFlagType;

+ (UIImage*) imageForOverlayItem:(NMapPOIitem *)poiItem selected:(BOOL)selected constraintSize:(CGSize)constraintSize;

@end
