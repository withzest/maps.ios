//
//  LocationMapViewController.h
//  ios_navermap_objc
//
//  Created by Naver on 2016. 11. 11..
//  Copyright © 2016년 Naver. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NMapViewerSDK/NMapView.h>
#import <NMapViewerSDK/NMapLocationManager.h>

@interface LocationMapViewController : UIViewController<NMapViewDelegate, NMapPOIdataOverlayDelegate, NMapLocationManagerDelegate>

@end
