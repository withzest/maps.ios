//
//  main.m
//  NMapViewerLib
//
//  Created by KJ KIM on 10. 04. 14.
//  Copyright NHN 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NMapViewerLibAppDelegate.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([NMapViewerLibAppDelegate class]));
    [pool release];
    return retVal;
}
