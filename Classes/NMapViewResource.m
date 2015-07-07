//
//  NMapViewResource.m
//  NaverMap
//
//  Created by KJ KIM on 10. 9. 15..
//  Copyright 2010 NHN. All rights reserved.
//


#import "NMapViewResource.h"


// 말풍선
#define kCalloutTextSize 14.0
#define kCalloutHeightForText 34
//
#define kCalloutMarginHorizLeft 13
#define kCalloutMarginHorizRight 11
//
#define kCalloutGapIcon 5 // [NAVERMAPUXRENEWAL-1218] 7에서 5pt로 변경, 20120117
// [NAVERMAPUXRENEWAL-1203] 최대 크기 제한
#define kCalloutOffsetLeft 0 // 10
#define kCalloutOffsetRight 0 // 10
//
#define kCalloutSizeMin 89
//
//
#define kTestLongText @"명칭이 긴 경우에는 적당히 말줄임이 되어야 하는데 잘되나요????????"
//


//
// To set callout position correctly
//
#define kPinInfoIconOffsetX (0.0)
#define kPinInfoIconOffsetY (0.0)

#define kNumberIconColor (1.0*0x77/0xFF) 
#define kNumberIconColorOver (1.0) 

@implementation NMapViewResource

static UIImage* makeNumberIconImage(NSString *backImageName, float color, int iconNumber)
{
	UIImage *backImage = [UIImage imageNamed:backImageName];
	if (!backImage) {
		return nil;
	}
	
	CGSize iconSize = backImage.size;
	CGSize imageSize = iconSize;
	imageSize.width += 2;
	imageSize.height += 2;
	
	NSString *iconText = [NSString stringWithFormat:@"%d", iconNumber];
	
	// font size
	CGFloat actualFontSize = 10; // for 3 digits 
	if (iconNumber < 10) actualFontSize = 12; // for 1 digit
	else if (iconNumber < 100) actualFontSize = 11; // for 2 digits
	// text size
	UIFont *font = [UIFont boldSystemFontOfSize:actualFontSize];
	CGSize sizeText = [iconText sizeWithFont:font constrainedToSize:iconSize lineBreakMode:UILineBreakModeTailTruncation];
	
	// create High-Resolution Bitmap Images Programmatically
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(imageSize);
	}	
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	// set fill color
	//CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
	//CGContextFillRect(context, CGRectMake(0,0,imageSize.width,imageSize.height));	
	
	// draw background image
	CGPoint pt = CGPointZero;
	pt.x = (imageSize.width - iconSize.width)/2;
	pt.y = (imageSize.height - iconSize.height)/2;
	// to prevent blur effect
	pt.x = roundf(pt.x);
	pt.y = roundf(pt.y);	
	[backImage drawAtPoint:pt blendMode:kCGBlendModeCopy/*kCGBlendModeNormal*/ alpha:1.0];
	
	// draw number
	CGRect rectText;
	rectText.origin.x = pt.x + (iconSize.width - sizeText.width)/2;
	rectText.origin.y = pt.y + (iconSize.height - sizeText.height)/2;
	rectText.size.width = sizeText.width;
	rectText.size.height = sizeText.height;
	// to prevent blur effect
	rectText.origin.x = roundf(rectText.origin.x);
	rectText.origin.y = roundf(rectText.origin.y);
	
	// set fill color
	CGContextSetRGBFillColor(context, color, color, color, 1.0);		
	[iconText drawAtPoint:rectText.origin forWidth:rectText.size.width withFont:font lineBreakMode:UILineBreakModeTailTruncation];			
	
	// get image
	UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();	
	
	//NSLog(@"makeNumberIconImage: size=%@", NSStringFromCGSize(iconImage.size));
    
    UIGraphicsEndImageContext();		
	
	return iconImage;
}

+ (UIImage *) imageWithType:(NMapPOIflagType)poiFlagType iconIndex:(int)index selected:(BOOL)selected
{
	UIImage *image = nil;
    
	switch (poiFlagType) {			
		case NMapPOIflagTypePin:
        case NMapPOIflagTypeSpot:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"pubtrans_exact_default.png"];
			}
			break;
			
		case NMapPOIflagTypeLocation:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"pubtrans_ic_mylocation_on.png"];
			}
			break;
			
		case NMapPOIflagTypeLocationOff:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"pubtrans_ic_mylocation_off.png"];
			}
			break;										
			
		case NMapPOIflagTypeCompass:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"ic_angle.png"];
			}
			break;														
			
		case NMapPOIflagTypeFrom:
			if (index >= 0 && index < 1) {
                if (selected) {
                    image = [UIImage imageNamed:@"start_icon_over.png"];
                } else {
                    image = [UIImage imageNamed:@"start_icon.png"];
                }
			}		
			break;			
			
		case NMapPOIflagTypeTo:
			if (index >= 0 && index < 1) {
                if (selected) {
                    image = [UIImage imageNamed:@"arr_icon_over.png"];
                } else {
                    image = [UIImage imageNamed:@"arr_icon.png"];
                }
			}		
			break;	
			
		case NMapPOIflagTypeNumber:
			// create number icons on demand
            if (selected) {
                image = makeNumberIconImage(@"by_00_over.png", kNumberIconColorOver, (index+1));
            } else {
                image = makeNumberIconImage(@"by_00.png", kNumberIconColor, (index+1));
            }					
			break;
			
		default:
			break;
	}
    
	return image;
}

+ (UIImage *) imageWithType:(NMapPOIflagType)poiFlagType iconIndex:(int)index selectedImage:(UIImage **)selectedImage
{
	UIImage *image = nil;
	
    image = [self imageWithType:poiFlagType iconIndex:index selected:NO];
	
	if (image) {
		if (selectedImage && (*selectedImage) == nil) {
			*selectedImage = image;
		}
	} else {
		NSAssert2(NO, @"poiIconWithType=> Failed to load for poiFlagType: %d, iconIndex: %d", poiFlagType, index);
	}
	
	return image;
}

+ (CGPoint) anchorPointWithType:(NMapPOIflagType)poiFlagType{

	CGPoint anchorPoint;
	
	switch (poiFlagType) {
		case NMapPOIflagTypePin:			
		case NMapPOIflagTypeFrom:
		case NMapPOIflagTypeTo:
			anchorPoint.x = 0.5;
			anchorPoint.y = 1.0;				
			break;
			
		case NMapPOIflagTypeLocation:
		case NMapPOIflagTypeLocationOff:	
		case NMapPOIflagTypeCompass:
			anchorPoint.x = 0.5;
			anchorPoint.y = 0.5;					
			break;									
			
		case NMapPOIflagTypeNumber:
			anchorPoint.x = 0.5;
			anchorPoint.y = 0.5;				
			break;
			
		default:
			anchorPoint.x = 0.5;
			anchorPoint.y = 1.0;			
			break;
	}
	
	return anchorPoint;
}

+ (UIImage *) imageForRightCalloutWithType:(NMapPOIflagType)poiFlagType selected:(BOOL)selected {
	
	UIImage *arrowIcon = nil;
	
	if (selected)
		arrowIcon = [UIImage imageNamed:@"pin_ballon_arrow_on.png"];
	else 
		arrowIcon = [UIImage imageNamed:@"pin_ballon_arrow.png"];
	
	return arrowIcon;
}

+ (CGPoint) calloutOffsetWithType:(NMapPOIflagType)poiFlagType {
	
	CGPoint offset;
	
	// check POI flag type
	switch (poiFlagType) {					
		default:
			offset.x = kPinInfoIconOffsetX;
			offset.y = kPinInfoIconOffsetY;	
			break;
			
	}	
	
	return offset;
}

+ (UIImage*) imageForCalloutOverlayItem:(NMapPOIitem *)poiItem constraintSize:(CGSize)constraintSize selected:(BOOL)selected
          imageForCalloutRightAccessory:(UIImage *)imageForCalloutRightAccessory
                        calloutPosition:(CGPoint *)calloutPosition calloutHitRect:(CGRect *)calloutHitRect
{
	// left
	UIImage *leftImage = [UIImage imageNamed:@"pin_ballon_left.png"];
	// right
	UIImage *rightImage = [UIImage imageNamed:@"pin_ballon_right.png"];
	// center
	UIImage *centerImage = [UIImage imageNamed:@"pin_ballon_center.png"];
	// tag
	UIImage *tagImage = [UIImage imageNamed:@"pin_ballon_bottom.png"];
    
	NSString *strText = poiItem.title;
	//strText = kTestLongText;
    
    NSString *tailText = poiItem.tail;
    //tailText = @"(17-201)";
	
	NMapPOIflagType poiFlagType = poiItem.poiFlagType;
	BOOL hasCalloutRightAccessory = poiItem.hasRightCalloutAccessory;
    
	// image for right callout accessory
	if (imageForCalloutRightAccessory == nil) {
		imageForCalloutRightAccessory = [self imageForRightCalloutWithType:poiFlagType selected:selected];
	}
    
	CGSize rightAccessorySize = CGSizeZero;
	if (!hasCalloutRightAccessory) {
		imageForCalloutRightAccessory = nil;
	} else {
		rightAccessorySize = imageForCalloutRightAccessory.size;
	}
    
	constraintSize.width -= kCalloutOffsetLeft + kCalloutMarginHorizLeft + kCalloutGapIcon + rightAccessorySize.width
    + kCalloutMarginHorizRight + kCalloutOffsetRight;
	constraintSize.height = kCalloutTextSize * 1.5;
    
    // font size
	CGFloat actualFontSize = kCalloutTextSize;
	UIFont *font = [UIFont systemFontOfSize:actualFontSize];
    
    // account for headerText
	CGSize tailTextSize = CGSizeZero;
	if (tailText) {
		tailTextSize = [tailText sizeWithFont:font];
        
		if (tailTextSize.width > 0) {
			constraintSize.width -= tailTextSize.width;
		}
	}
    
	// adjust text size
	CGSize sizeText = [strText sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeTailTruncation];
    
    CGSize sizeContent = sizeText;
	if (tailTextSize.width > 0) {
		sizeContent.width += tailTextSize.width;
	}
    
	// info image size
	CGRect rectImage = CGRectZero;
	rectImage.size.width = kCalloutMarginHorizLeft + sizeContent.width
    + (imageForCalloutRightAccessory ? (kCalloutGapIcon + rightAccessorySize.width) : 0) + kCalloutMarginHorizRight;
	rectImage.size.height = tagImage.size.height;
    
	// adjust minimum size
	float expandedTextSizeWidth = sizeContent.width;
	if (rectImage.size.width < kCalloutSizeMin) {
		expandedTextSizeWidth += kCalloutSizeMin - rectImage.size.width;
        
		rectImage.size.width = kCalloutSizeMin;
	}
    
	// check pin position
	// align at center for info object
	calloutPosition->x = (rectImage.size.width)/2;
	calloutPosition->x = roundf(calloutPosition->x);
    
	int centerImageWidth = (rectImage.size.width - leftImage.size.width - tagImage.size.width - rightImage.size.width)/2;
    
	// create High-Resolution Bitmap Images Programmatically
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		UIGraphicsBeginImageContextWithOptions(rectImage.size, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(rectImage.size);
	}
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGPoint pt = CGPointZero;
    
	// draw left image
	const float alpha = 1.0;
	[leftImage drawAtPoint:pt blendMode:kCGBlendModeCopy alpha:alpha];
	pt.x += leftImage.size.width;
    
	// draw center image at left
	CGRect rect;
	rect.origin = pt;
	rect.size.width = centerImageWidth;
	rect.size.height = centerImage.size.height;
    
	if (rect.size.width > 0) {
		CGContextSaveGState(context);
        
		CGContextTranslateCTM(context, 0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
        
		CGContextSetAlpha(context, alpha);
		CGContextDrawImage(context, rect, centerImage.CGImage);
        
		CGContextRestoreGState(context);
	}
	pt.x += rect.size.width;
    
	// draw tag
	rect.origin = pt;
	[tagImage drawAtPoint:pt blendMode:kCGBlendModeCopy alpha:alpha];
	pt.x += tagImage.size.width;
    
	// draw center image at right
	rect.origin = pt;
	rect.size.width = rectImage.size.width - rect.origin.x - rightImage.size.width;
	rect.size.height = centerImage.size.height;
    
	if (rect.size.width > 0) {
		CGContextSaveGState(context);
        
		CGContextTranslateCTM(context, 0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
        
		CGContextSetBlendMode(context, kCGBlendModeCopy);
		CGContextSetAlpha(context, alpha);
		CGContextDrawImage(context, rect, centerImage.CGImage);
        
		CGContextRestoreGState(context);
	}
	pt.x += rect.size.width;
    
	// draw right image
	rect.origin = pt;
	[rightImage drawAtPoint:pt blendMode:kCGBlendModeCopy alpha:alpha];
    
	// draw text
	CGRect rectText;
    if (tailTextSize.width > 0) {
        rectText.origin.x = kCalloutMarginHorizLeft;
    } else {
        rectText.origin.x = kCalloutMarginHorizLeft + (expandedTextSizeWidth - sizeText.width)/2;
    }	
	rectText.origin.y = (kCalloutHeightForText - sizeText.height)/2;
	rectText.size.width = sizeText.width;
	rectText.size.height = sizeText.height;
	// to prevent blur effect
	rectText.origin.x = roundf(rectText.origin.x);
	rectText.origin.y = roundf(rectText.origin.y);
    
	// set fill color
	if (selected) {
		CGContextSetRGBFillColor(context, 0x9c/255.0, 0xa1/255.0, 0xaa/255.0, 1.0);
	} else {
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	}
	[strText drawAtPoint:rectText.origin forWidth:rectText.size.width 
                withFont:font lineBreakMode:UILineBreakModeTailTruncation];
    
    pt.x = rectText.origin.x + rectText.size.width;
    
    // draw tail text
    if (tailTextSize.width > 0) {
        rectText.origin.x = pt.x;
        rectText.origin.y = (kCalloutHeightForText - tailTextSize.height)/2;
        rectText.size.width = tailTextSize.width;
        rectText.size.height = tailTextSize.height;
        // to prevent blur effect
        rectText.origin.x = roundf(rectText.origin.x);
        rectText.origin.y = roundf(rectText.origin.y);
        
        [tailText drawAtPoint:rectText.origin forWidth:rectText.size.width 
                     withFont:font lineBreakMode:UILineBreakModeTailTruncation];
    }
    
	// draw arrow
	if (imageForCalloutRightAccessory)
	{
		pt.x = kCalloutMarginHorizLeft + expandedTextSizeWidth + kCalloutGapIcon;
		pt.y = (kCalloutHeightForText - rightAccessorySize.height)/2;
		// to prevent blur effect
		pt.x = roundf(pt.x);
		pt.y = roundf(pt.y);
		[imageForCalloutRightAccessory drawAtPoint:pt];
        
		// set hit rect for overall callout image except tag image
		*calloutHitRect = CGRectMake(0, 0, rectImage.size.width, rectImage.size.height);
		calloutHitRect->size.height -= (tagImage.size.height - centerImage.size.height);
	}
	else
	{
		*calloutHitRect = CGRectZero;
	}
    
	// get image
	UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	return myImage;
}

+ (UIImage*) imageForOverlayItem:(NMapPOIitem *)poiItem selected:(BOOL)selected constraintSize:(CGSize)constraintSize {
    
	UIImage *image = nil;
    
	int poiFlagType = poiItem.poiFlagType;
	int index = poiItem.iconIndex;
    
	if (image == nil) {
		image = [NMapViewResource imageWithType:poiFlagType iconIndex:index selected:selected];
	}
    
	return image;
}

@end
