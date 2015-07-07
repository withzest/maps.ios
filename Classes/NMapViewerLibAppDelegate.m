//
//  NMapViewerLibAppDelegate.m
//  NMapViewerLib
//
//  Created by KJ KIM on 10. 04. 14.
//  Copyright NHN 2010. All rights reserved.
//

#import "NMapViewerLibAppDelegate.h"

@implementation NMapViewerLibAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    mapViewController = [[NMapViewController alloc] init];	
	[window addSubview:[mapViewController view]];	
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[mapViewController release];
	
    [window release];
    [super dealloc];
}


@end
