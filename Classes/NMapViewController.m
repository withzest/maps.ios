//
//  NMapViewController.m
//  MapViewer
//
//  Created by KJ KIM on 08. 10. 21.
//  Copyright 2008 NHN. All rights reserved.
//

#import "NMapViewController.h"

#import "NMapViewResource.h"

#define kMyLocationStr @"내위치"
#define kMapModeStr @"지도보기"
#define kClearMapStr @"초기화"
#define KTestModeStr @"테스트"

#define KMapModeStandardStr @"일반지도"
#define KMapModeSatelliteStr @"위성지도"
#define KMapModeTrafficStr @"실시간교통"
#define KMapModeBicycleStr @"자전거지도"

#define kCancelStr @"취소"

#define kMapInvalidCompassValue (-360)


@implementation NMapViewController

- (void) addBottomBar
{
	UIBarButtonItem *locItem = [[[UIBarButtonItem alloc] initWithTitle:kMyLocationStr
																 style:UIBarButtonItemStylePlain
																target:self
																action:@selector(findMyLocation:)] autorelease];
	UIBarButtonItem *mapModeItem = [[[UIBarButtonItem alloc] initWithTitle:kMapModeStr
																	 style:UIBarButtonItemStylePlain
																	target:self
																	action:@selector(mapModeAction:)] autorelease];
	UIBarButtonItem *clearMapItem = [[[UIBarButtonItem alloc] initWithTitle:kClearMapStr
																	  style:UIBarButtonItemStylePlain
																	 target:self
																	 action:@selector(clearMap:)] autorelease];	
	UIBarButtonItem *testModeItem = [[[UIBarButtonItem alloc] initWithTitle:KTestModeStr
																	  style:UIBarButtonItemStylePlain
																	 target:self
																	 action:@selector(testModeAction:)] autorelease];	
	NSArray *items = [NSArray arrayWithObjects: 
					  locItem,
					  mapModeItem,
					  clearMapItem,
					  testModeItem,
					  nil];
	_toolbar.items = items;
	
	// size up the toolbar and set its frame
	[_toolbar sizeToFit];
	
	[_toolbar.layer setOpacity:0.9];
}

- (void) setMapViewVisibleBounds
{
	CGRect frameOfParentView = [[_mapView superview] frame];
	frameOfParentView.origin = CGPointZero;
	
	CGRect boundsVisible = frameOfParentView;

	if (![_toolbar isHidden]) {
        boundsVisible.size.height -= _toolbar.frame.size.height;
	}	
	
	[_mapView setBoundsVisible:boundsVisible];
}

- (void) setCompassHeadingValue:(double)headingValue	{	
	
	if ([_mapView isAutoRotateEnabled]) {		
		
		if (headingValue <= kMapInvalidCompassValue) {
			// stop rotating map view 
			[_mapView setAutoRotateEnabled:NO];			
		} else {					
			// set rotate angle of map view
            [_mapView setRotateAngle:(CGFloat) headingValue];
		}				
	}
}

- (void) stopLocationUpdating {
	NMapLocationManager *lm = [NMapLocationManager getSharedInstance];
	if ([lm isUpdateLocationStarted]) {		
		// stop updating location
		[lm stopUpdateLocationInfo];
		[lm setDelegate:nil];		
	}
	if ([lm isHeadingUpdateStarted]){
		// stop updating heading
		[lm stopUpdatingHeading];
	}			
	
	if ([_mapView isAutoRotateEnabled]) {
		// stop rotating map view 
		[self setCompassHeadingValue:kMapInvalidCompassValue];
	}			
}

- (void)findMyLocation:(id)sender
{	
	NMapLocationManager *lm = [NMapLocationManager getSharedInstance];
	BOOL isAvailableCompass = [lm headingAvailable];
    
    if ([lm locationServiceEnabled] == NO) {
        [self locationManager:lm didFailWithError:NMapLocationManagerErrorTypeDenied];
        return;
    }
	
	if ([lm isUpdateLocationStarted]){
		if (isAvailableCompass && [lm isTrackingEnabled]) {
			if ([_mapView isAutoRotateEnabled]) {
				// stop updating location
				[self stopLocationUpdating];
			} else {
				[_mapView setAutoRotateEnabled:YES];
				
				// start updating heading
				[lm startUpdatingHeading];												
			}
		} else {
			// stop updating location
			[self stopLocationUpdating];
		}		
	}
	else {
		// set delegate
		[lm setDelegate:self];
		
		// start updating location
		[lm startContinuousLocationInfo];
	}
}

- (void)clearOverlays {	
	NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
	[mapOverlayManager clearOverlays];
	
	[_mapPOIdataOverlay release];
	_mapPOIdataOverlay = nil;
}

- (void)testPOIdata {
	[self clearOverlays];
	
	NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
	
	// create POI data overlay
	NMapPOIdataOverlay *poiDataOverlay = [mapOverlayManager newPOIdataOverlay];
	
	[poiDataOverlay initPOIdata:3];		
	[poiDataOverlay addPOIitemAtLocation:NGeoPointMake(126.979, 37.567) title:@"마커 1" type:NMapPOIflagTypePin iconIndex:0 withObject:nil];
	[poiDataOverlay addPOIitemAtLocation:NGeoPointMake(126.974, 37.566) title:@"마커 2" type:NMapPOIflagTypeFrom iconIndex:0 withObject:nil];
	[poiDataOverlay addPOIitemAtLocation:NGeoPointMake(126.984, 37.565) title:@"마커 3" type:NMapPOIflagTypeTo iconIndex:0 withObject:nil];
	[poiDataOverlay endPOIdata];
	
	// show all POI data
	[poiDataOverlay showAllPOIdata];
	
	[poiDataOverlay release];	
}

- (void)testPathData {
	[self clearOverlays];
	
	NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];	
	
	// create path POI data overlay
	NMapPOIdataOverlay *pathPOIdataOverlay = [mapOverlayManager newPOIdataOverlay];
	
	if (pathPOIdataOverlay) {		
		[pathPOIdataOverlay initPOIdata:4];
		
		[pathPOIdataOverlay addPOIitemAtLocationInUtmk:NPointMake(349652983, 149297368) title:@"출발" type:NMapPOIflagTypeFrom iconIndex:0 withObject:nil];
		[pathPOIdataOverlay addPOIitemAtLocationInUtmk:NPointMake(349652966, 149296906) title:nil type:NMapPOIflagTypeNumber iconIndex:0 withObject:nil];
		[pathPOIdataOverlay addPOIitemAtLocationInUtmk:NPointMake(349651062, 149296913) title:nil type:NMapPOIflagTypeNumber iconIndex:1 withObject:nil];
		[pathPOIdataOverlay addPOIitemAtLocationInUtmk:NPointMake(349651376, 149297750) title:@"도착" type:NMapPOIflagTypeTo iconIndex:0 withObject:nil];
		
		[pathPOIdataOverlay endPOIdata];
		
		[pathPOIdataOverlay release];
	}
	
	// set path data points
	NMapPathData *pathData = [[NMapPathData alloc] initWithCapacity:9];
	[pathData initPathData];		
	[pathData addPathPointLongitude:127.108099 latitude:37.366034 lineType:NMapPathLineTypeSolid];
	[pathData addPathPointLongitude:127.108088 latitude:37.366043 lineType:0];
	[pathData addPathPointLongitude:127.108079 latitude:37.365619 lineType:0];
	[pathData addPathPointLongitude:127.107458 latitude:37.365608 lineType:0];
	[pathData addPathPointLongitude:127.107232 latitude:37.365608 lineType:0];
	[pathData addPathPointLongitude:127.106904 latitude:37.365624 lineType:0];
	[pathData addPathPointLongitude:127.105933 latitude:37.365621 lineType:NMapPathLineTypeDash];
	[pathData addPathPointLongitude:127.105929 latitude:37.366378 lineType:0];
	[pathData addPathPointLongitude:127.106279 latitude:37.366380 lineType:0];
	[pathData endPathData];
	
	// create path data overlay
	NMapPathDataOverlay *pathDataOverlay = [mapOverlayManager newPathDataOverlay:pathData];
	if (pathDataOverlay) {
        
        // add path data with polygon type
        NMapPathData *pathData2 = [[NMapPathData alloc] initWithCapacity:4];
        [pathData2 initPathData];
        [pathData2 addPathPointLongitude:127.106 latitude:37.367 lineType:NMapPathLineTypeSolid];
        [pathData2 addPathPointLongitude:127.107 latitude:37.367 lineType:0];
        [pathData2 addPathPointLongitude:127.107 latitude:37.368 lineType:0];
        [pathData2 addPathPointLongitude:127.106 latitude:37.368 lineType:0];
        [pathData2 endPathData];
        [pathDataOverlay addPathData:pathData2];
        // set path line style
        NMapPathLineStyle *pathLineStyle = [[NMapPathLineStyle alloc] init];
        [pathLineStyle setPathDataType:NMapPathDataTypePolygon];
        [pathLineStyle setLineColorWithRed:0xA0*1.0/255.0 green:0x4D*1.0/255.0 blue:0xD2*1.0/255.0 alpha:0xFF*1.0/255.0];
        [pathLineStyle setFillColor:[UIColor clearColor]];
        [pathData2 setPathLineStyle:pathLineStyle];
        [pathLineStyle release];
        [pathData2 release];
        
        // add circle data
        NMapCircleData *circleData = [[NMapCircleData alloc] initWithCapacity:1];
        [circleData initCircleData];
        [circleData addCirclePointLongitude:127.1075 latitude:37.3675 radius:50.0F];
        [circleData endCircleData];
        [pathDataOverlay addCircleData:circleData];
        // set circle style
        NMapCircleStyle *circleStyle = [[NMapCircleStyle alloc] init];
        [circleStyle setLineType:NMapPathLineTypeDash];
        [circleStyle setFillColor:[UIColor clearColor]];
        [circleData setCircleStyle:circleStyle];
        [circleStyle release];
        [circleData release];
        
		// show all path data
		[pathDataOverlay showAllPathData];
		
		[pathDataOverlay release];
	}
	[pathData release];	
}

- (void)testFloatingData {	
	[self clearOverlays];

	NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
	
	// create POI data overlay
	NMapPOIdataOverlay *poiDataOverlay = [mapOverlayManager newPOIdataOverlay];
	
	// set POI data
	[poiDataOverlay initPOIdata:1];	
	
	NMapPOIitem *poiItem = [poiDataOverlay addPOIitemAtLocation:NGeoPointMake(126.984, 37.565) title:@"Touch & Drag to Move" type:NMapPOIflagTypeTo iconIndex:0 withObject:nil];
	
	// set floating mode
	[poiItem setPOIflagMode:NMapPOIflagModeTouch];
	
	// hide right button on callout
	[poiItem setHasRightCalloutAccessory:NO];
	
	[poiDataOverlay endPOIdata];
	
	// select item
	[poiDataOverlay selectPOIitemAtIndex:0 moveToCenter:YES];
		
	_mapPOIdataOverlay = [poiDataOverlay retain];
	
	[poiDataOverlay release];
}

- (void)testAutoRotate {
	
	if ([_mapView isAutoRotateEnabled]) {
		[_mapView setAutoRotateEnabled:NO];
	} else {
		[_mapView setAutoRotateEnabled:YES];
		
		[self setCompassHeadingValue:-45.0];		
	}
	
	[self setMapViewVisibleBounds];
}

- (void)clearMap:(id)sender {
	
	[_mapView setMapViewMode:NMapViewModeVector];
	[_mapView setMapViewTrafficMode:NO];
	[_mapView setMapViewBicycleMode:NO];
	
	// clear overlays
	[self stopLocationUpdating];
	if ([[_mapView mapOverlayManager] hasMyLocationOverlay]) {	
		[[_mapView mapOverlayManager] clearMyLocationOverlay];										
	}
	
	[self clearOverlays];
}

- (void)mapModeAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:kMapModeStr delegate:self 
													cancelButtonTitle:kCancelStr destructiveButtonTitle:nil otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	[actionSheet addButtonWithTitle:KMapModeStandardStr];
	[actionSheet addButtonWithTitle:KMapModeSatelliteStr];
	if ([_mapView mapViewTrafficMode]) {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ Off", KMapModeTrafficStr]];
	} else {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ On", KMapModeTrafficStr]];
	}	
	if ([_mapView mapViewBicycleMode]) {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ Off", KMapModeBicycleStr]];
	} else {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ On", KMapModeBicycleStr]];
	}
	
	[actionSheet showInView:self.view]; 
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//NSLog(@"actionSheet:%@ clickedButtonAtIndex: %d", [actionSheet title], buttonIndex);
	
	if ([[actionSheet title] isEqualToString:kMapModeStr]) {
		switch (buttonIndex) {
			case 1:
				[_mapView setMapViewMode:NMapViewModeVector];
				break;
			case 2:
				[_mapView setMapViewMode:NMapViewModeHybrid];
				break;
			case 3:
				[_mapView setMapViewTrafficMode:(![_mapView mapViewTrafficMode])];
				break;
			case 4:
				[_mapView setMapViewBicycleMode:(![_mapView mapViewBicycleMode])];
				break;
		}
	}
	
	if ([[actionSheet title] isEqualToString:KTestModeStr]) {
		switch (buttonIndex) {
			case 1:
				[self testPOIdata];
				break;
			case 2:
				[self testPathData];
				break;		
			case 3:
				[self testFloatingData];
				break;	
			case 4:
				[self testAutoRotate];
				break;
		}
	}
}

- (void)testModeAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:KTestModeStr delegate:self 
													cancelButtonTitle:kCancelStr destructiveButtonTitle:nil otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	[actionSheet addButtonWithTitle:@"마커 표시"];
	[actionSheet addButtonWithTitle:@"경로선 표시"];
	[actionSheet addButtonWithTitle:@"직접 지정"];
	[actionSheet addButtonWithTitle:@"지도 회전"];
	
	[actionSheet showInView:self.view]; 
	[actionSheet release];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // create map view
    _mapView = [[NMapView alloc] initWithFrame:self.view.frame];

    // set delegate to use reverse geocoder API
    [_mapView setReverseGeocoderDelegate:self];
    
    // set delegate for map view
    [_mapView setDelegate:self];

    // set ClientID for Open MapViewer Library
    [_mapView setClientId:kClientID];

    self.navigationController.navigationBar.translucent = NO;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.title = kApplicationName;
    
    [self.view addSubview:_mapView];
    [self addBottomBar];	
    [self.view bringSubviewToFront:_toolbar];
    
    [self setMapViewVisibleBounds];
}

- (void)didReceiveMemoryWarning {
	NSLog(@"NMapViewController:didReceiveMemoryWarning ...");
	
	// release cached data in the map view
	[_mapView didReceiveMemoryWarning];
	
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	[_mapView viewWillAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
	[_mapView viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
	[_mapView viewWillDisappear];
    
    [self stopLocationUpdating];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [_mapView viewDidDisappear];
}

- (void)dealloc {
	
	[_mapPOIdataOverlay release];
	
    [_mapView setDelegate:nil];
	[_mapView release];
	
    [super dealloc];
}

- (void) applicationWillSuspend {
	NSLog(@"applicationWillSuspend");
}

- (void) applicationWillTerminate {
	NSLog(@"applicationWillTerminate");
}


#pragma mark NMapViewDelegate Method

- (void) onMapView:(NMapView *)mapView initHandler:(NMapError *)error {	
	
	if (error == nil) { // success
		// set map center and level
		[_mapView setMapCenter:NGeoPointMake(126.978371, 37.5666091) atLevel:11];
        [_mapView setMapEnlarged:YES mapHD:YES];
	} else { // fail	
		NSLog(@"onMapView:initHandler: %@", [error description]);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:[error description]
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];		
	}
}

- (void) onMapView:(NMapView *)mapView networkActivityIndicatorVisible:(BOOL)visible {
	//NSLog(@"onMapView:networkActivityIndicatorVisible: %d", visible);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
}

- (void) onMapView:(NMapView *)mapView didChangeMapLevel:(int)level {
	NSLog(@"onMapView:didChangeMapLevel: %d", level);
}

- (void) onMapView:(NMapView *)mapView didChangeViewStatus:(NMapViewStatus)status {
	//NSLog(@"onMapView:didChangeViewStatus: %d", status);
}

- (void) onMapView:(NMapView *)mapView didChangeMapCenter:(NGeoPoint)location {	
	NSLog(@"onMapView:didChangeMapCenter: (%f, %f)", location.longitude, location.latitude);
}

- (void) onMapView:(NMapView *)mapView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
- (void) onMapView:(NMapView *)mapView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
- (void) onMapView:(NMapView *)mapView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void) onMapView:(NMapView *)mapView handleLongPressGesture:(UIGestureRecognizer*)recogniser {
    
}
- (void) onMapView:(NMapView *)mapView handleSingleTapGesture:(UIGestureRecognizer*)recogniser {
    
    [_toolbar setHidden:![_toolbar isHidden]];
    
    [self setMapViewVisibleBounds];
}

- (BOOL) onMapViewIsGPSTracking:(NMapView *)mapView {
	return [[NMapLocationManager getSharedInstance] isTrackingEnabled];
}

#pragma mark NMapPOIdataOverlayDelegate

//
// DEPRECATED, use onMapOverlay:imageForOverlayItem:selected for efficiency
//
//- (UIImage *) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageWithType:(int)poiFlagType iconIndex:(int)index selectedImage:(UIImage **)selectedImage {
//    return nil;
////	return [NMapViewResource imageWithType:poiFlagType iconIndex:index selectedImage:selectedImage];
//}
//
- (UIImage *) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForOverlayItem:(NMapPOIitem *)poiItem selected:(BOOL)selected {
    
    return [NMapViewResource imageForOverlayItem:poiItem selected:selected constraintSize:_mapView.viewBounds.size];
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay anchorPointWithType:(NMapPOIflagType)poiFlagType {
	return [NMapViewResource anchorPointWithType:poiFlagType];
}

- (UIView*) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay viewForCalloutOverlayItem:(NMapPOIitem *)poiItem 
         calloutPosition:(CGPoint *)calloutPosition {
    
    // [TEST] nil을 리턴하면 onMapOverlay:imageForCalloutOverlayItem:... 이 다시 호출됨
    if ([poiItem.title length] > 10) {
        return nil;
    }
    
    CGSize constraintSize = _mapView.bounds.size;
    CGRect calloutHitRect;
	UIImage *image = [NMapViewResource imageForCalloutOverlayItem:poiItem constraintSize:constraintSize selected:NO
                                    imageForCalloutRightAccessory:nil
                                                  calloutPosition:calloutPosition calloutHitRect:&calloutHitRect];
    
    if ([poiItem.title length] > 5) {
        // [TEST] userInteractionEnabled 값이 YES인 UIView를 리턴하면 터치 이벤트를 직접 처리해야함
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        return [button autorelease];   
    }
    
    // [TEST] userInteractionEnabled 값이 NO인 UIView를 리턴하면 선택시 onMapOverlay:imageForCalloutOverlayItem:...이 호출됨
    UIImageView *calloutView = [[UIImageView alloc] initWithImage:image];
    return [calloutView autorelease];
}

- (UIImage*) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForCalloutOverlayItem:(NMapPOIitem *)poiItem 
		   constraintSize:(CGSize)constraintSize selected:(BOOL)selected 
		  imageForCalloutRightAccessory:(UIImage *)imageForCalloutRightAccessory
						calloutPosition:(CGPoint *)calloutPosition calloutHitRect:(CGRect *)calloutHitRect {
		
	// handle overlapped items
	if (!selected) {
		// check if it is selected by touch event
		if (!poiDataOverlay.focusedBySelectItem) {
			int countOfOverlappedItems = 1;
			
			NSArray *poiData = [poiDataOverlay poiData];
			
			for (NMapPOIitem *item in poiData) {
				// skip selected item
				if (item == poiItem) {
					continue;
				}
				
				// check if overlapped or not
				if (CGRectIntersectsRect([item frame], [poiItem frame])) {
					countOfOverlappedItems++;
				}
			}
			
			if (countOfOverlappedItems > 1) {
				// handle overlapped items
				NSString *strText = [NSString stringWithFormat:@"%d overlapped items for %@", countOfOverlappedItems, poiItem.title];
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:strText
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];	
				[alert release];	
				
				// do not show callout overlay
				return nil;
			}			
		}		
	}
	
	return [NMapViewResource imageForCalloutOverlayItem:poiItem constraintSize:constraintSize selected:selected
						  imageForCalloutRightAccessory:imageForCalloutRightAccessory
										calloutPosition:calloutPosition calloutHitRect:calloutHitRect];
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay calloutOffsetWithType:(NMapPOIflagType)poiFlagType {
	return [NMapViewResource calloutOffsetWithType:poiFlagType];
}

- (void) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay willShowCalloutOverlayItem:(NMapPOIitem *)poiItem {
    NSLog(@"onMapOverlay:willShowCalloutOverlayItem: %@", poiItem);
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didChangeSelectedPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didChangeSelectedPOIitemAtIndex: %d", index);
	
	return YES;
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didDeselectPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didDeselectPOIitemAtIndex: %d", index);
	
	return YES;
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didSelectCalloutOfPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didSelectCalloutOfPOIitemAtIndex: %d", index);
	
	NMapPOIitem *poiItem = [[poiDataOverlay poiData] objectAtIndex:index];
	
	if (poiItem.title) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:kApplicationName message:poiItem.title
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
		[alert show];	
	}
	
	return YES;
}

- (void) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didChangePOIitemLocationTo:(NGeoPoint)location withType:(NMapPOIflagType)poiFlagType {
	NSLog(@"onMapOverlay:didChangePOIitemLocationTo: (%f, %f)", location.longitude, location.latitude);
	
	[_mapView findPlacemarkAtLocation:location];
}

#pragma mark MMapReverseGeocoderDelegate

- (void) location:(NGeoPoint)location didFindPlacemark:(NMapPlacemark *)placemark
{
	NSLog(@"location:(%f, %f) didFindPlacemark: %@", location.longitude, location.latitude, [placemark address]);		
	
	if (_mapPOIdataOverlay) {
		NMapPOIitem *poiItem = [[_mapPOIdataOverlay poiData] objectAtIndex:0];
		
		if (NGeoPointIsEquals([poiItem location], location)) {
			[poiItem setTitle:[placemark address]];
			
			[_mapPOIdataOverlay selectPOIitemAtIndex:0 moveToCenter:NO];			
		}		
	}
}
- (void) location:(NGeoPoint)location didFailWithError:(NMapError *)error
{
	NSLog(@"location:(%f, %f) didFailWithError: %@", location.longitude, location.latitude, [error description]);
}

#pragma mark NMapLocationManagerDelegate

- (void)locationManager:(NMapLocationManager *)locationManager didUpdateToLocation:(CLLocation *)location {
	
	CLLocationCoordinate2D coordinate = [location coordinate];
	
	NGeoPoint myLocation;
	myLocation.longitude = coordinate.longitude;
	myLocation.latitude = coordinate.latitude;
	float locationAccuracy = [location horizontalAccuracy];
	
	[[_mapView mapOverlayManager] setMyLocation:myLocation locationAccuracy:locationAccuracy];
	
	[_mapView setMapCenter:myLocation];
}

- (void)locationManager:(NMapLocationManager *)locationManager didFailWithError:(NMapLocationManagerErrorType)errorType {
	NSString *message = nil;
	
	switch (errorType) {
		case NMapLocationManagerErrorTypeUnknown:
		case NMapLocationManagerErrorTypeCanceled:
		case NMapLocationManagerErrorTypeTimeout:
			message = @"일시적으로 내위치를 확인할 수 없습니다.";
			break;	
		case NMapLocationManagerErrorTypeDenied:
			if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0f )
				message = @"위치 정보를 확인할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오.";
			else
				message = @"위치 정보를 확인할 수 없습니다.";			
			break;
		case NMapLocationManagerErrorTypeUnavailableArea:
			message = @"현재 위치는 지도내에 표시할 수 없습니다.";			
			break;			
		case NMapLocationManagerErrorTypeHeading:
			[self setCompassHeadingValue:kMapInvalidCompassValue];	
			break;
		default:
			break;
	}
	
	if (message) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kApplicationName message:message
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];			
	}
	
	if ([_mapView isAutoRotateEnabled]) {
		[self setCompassHeadingValue:kMapInvalidCompassValue];
	}
	
	[[_mapView mapOverlayManager] clearMyLocationOverlay];
}

- (void)locationManager:(NMapLocationManager *)locationManager didUpdateHeading:(CLHeading *)heading {

	double headingValue = [heading trueHeading] < 0.0 ? [heading magneticHeading] : [heading trueHeading];
	[self setCompassHeadingValue:headingValue];	
}

@end
