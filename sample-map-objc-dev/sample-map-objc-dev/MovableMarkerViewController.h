//
//  MovableMarkerViewController.h
//  sample-map-objc-dev
//
//  Created by Naver on 2016. 11. 21..
//  Copyright © 2016년 Naver. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NMapViewerSDK/NMapView.h>
#import <NMapViewerSDK/NMapLocationManager.h>

@interface MovableMarkerViewController : UIViewController<NMapViewDelegate, NMapPOIdataOverlayDelegate>

@end
