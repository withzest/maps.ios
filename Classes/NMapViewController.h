//
//  NMapViewController.h
//  MapViewer
//
//  Created by KJ KIM on 08. 10. 21.
//  Copyright 2008 NHN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMapView.h"
#import "NMapLocationManager.h"

// Set API key for Open MapViewer libarary.
#define kApiKey @"Your API Key"         //api key is deprecated
#define kClientID @"Your Client ID"     //get your clientID from developers.naver.com


@interface NMapViewController : UIViewController<UIActionSheetDelegate,
						NMapViewDelegate, NMapPOIdataOverlayDelegate, 
						MMapReverseGeocoderDelegate, NMapLocationManagerDelegate> {
	NMapView *_mapView;
	
	NMapPOIdataOverlay *_mapPOIdataOverlay;

	UIToolbar *_toolbar; 
}

@end
