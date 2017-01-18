//
//  ReverseGeocoderViewController.h
//  ios_navermap_objc
//
//  Created by Naver on 2016. 11. 14..
//  Copyright © 2016년 Naver. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <NMapViewerSDK/NMapView.h>
#import <NMapViewerSDK/NMapLocationManager.h>

@interface ReverseGeocoderViewController : UIViewController<NMapViewDelegate, NMapPOIdataOverlayDelegate, MMapReverseGeocoderDelegate>

@end
