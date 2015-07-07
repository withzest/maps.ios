//
//  NMapViewerLibAppDelegate.h
//  NMapViewerLib
//
//  Created by KJ KIM on 10. 04. 14.
//  Copyright NHN 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMapViewController.h"

@interface NMapViewerLibAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;

	NMapViewController *mapViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

