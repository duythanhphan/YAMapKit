//
//  MapViewController.m
//  Demo
//
//  Created by kishikawa katsumi on 2012/10/21.
//  Copyright (c) 2012 kishikawa katsumi. All rights reserved.
//

#import "MapViewController.h"
#import "DetailViewController.h"
#import "ConfigurationViewController.h"
#import "Placemark.h"

@interface MapViewController () <UISearchBarDelegate, MKMapViewDelegate> {
    Placemark *droppedPin;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Map", nil);
    _searchBar.placeholder = NSLocalizedString(@"Search or Address", nil);
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.containerView.bounds];
    self.mapView = mapView;
    _mapView.delegate = self;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:_mapView];
    
    UIBarButtonItem *userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    
    UIBarButtonItem *configurationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(configure:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _toolbar.items = @[userTrackingButton, flexibleSpace, configurationButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)setMapType:(MKMapType)mapType
{
    _mapType = mapType;
    _mapView.mapType = mapType;
}

#pragma mark -

- (void)configure:(id)sender
{
    [self performSegueWithIdentifier:@"Configure" sender:self];
}

#pragma mark -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         _dimView.alpha = 0.7f;
     } completion:nil];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSArray *annotations = _mapView.annotations;
    for (id annotation in annotations) {
        if (annotation != _mapView.userLocation) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
//    MKMapRect visibleMapRect = _mapView.visibleMapRect;
//    MKMapPoint northeast = MKMapPointMake(MKMapRectGetMaxX(visibleMapRect), MKMapRectGetMinY(visibleMapRect));
//    MKMapPoint southwest = MKMapPointMake(MKMapRectGetMinX(visibleMapRect), MKMapRectGetMaxY(visibleMapRect));
//    CLLocationCoordinate2D neCoord = MKCoordinateForMapPoint(northeast);
//    CLLocationCoordinate2D swCoord = MKCoordinateForMapPoint(southwest);
//    CLLocationDistance diameter = [self getDistanceFrom:neCoord to:swCoord];
//    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:_mapView.centerCoordinate radius:(diameter / 2) identifier:@"search"];
//    
//    [_geocoder geocodeAddressString:searchBar.text inRegion:region completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (!error) {
//             NSInteger index = 0;
//             for (CLPlacemark *placemark in placemarks) {
//                 if (index == 0) {
//                     [_mapView setCenterCoordinate:placemark.location.coordinate animated:NO];
//                 }
//                 [_mapView addAnnotation:[[MKPlacemark alloc] initWithPlacemark:placemark]];
//                 index++;
//             }
//         }
//     }];
    
    [self finishSearch];
}

- (IBAction)dimmingViewTapped:(id)sender {
    [self finishSearch];
}

- (void)finishSearch
{
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         _dimView.alpha = 0.0f;
     } completion:nil];
    
    [self.searchBar resignFirstResponder];
}

- (CLLocationDistance)getDistanceFrom:(CLLocationCoordinate2D)start to:(CLLocationCoordinate2D)end
{
	CLLocation *startLoccation = [[CLLocation alloc] initWithLatitude:start.latitude longitude:start.longitude];
	CLLocation *endLoccation = [[CLLocation alloc] initWithLatitude:end.latitude longitude:end.longitude];
    
	return [startLoccation distanceFromLocation:endLoccation];
}

#pragma mark -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if (annotation == mapView.userLocation) {
		return nil;
	}
    
    if (annotation == droppedPin) {
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        annotationView.annotation = annotation;
        int64_t delayInSeconds = 0.4;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mapView selectAnnotation:annotation animated:YES];
        });
        
        return annotationView;
    }
    
	MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    annotationView.draggable = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
	annotationView.annotation = annotation;
    int64_t delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [mapView selectAnnotation:annotation animated:YES];
    });
    
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"Details" sender:view];
}

#pragma mark -

- (void)configurationViewController:(ConfigurationViewController *)controller mapTypeChanged:(MKMapType)mapType
{
    self.mapType = mapType;
}

- (void)configurationViewControllerWillAddPin:(ConfigurationViewController *)controller
{
    CLLocationCoordinate2D centerCoordinate = _mapView.centerCoordinate;
    
    [_mapView removeAnnotation:droppedPin];
    
    droppedPin = [[Placemark alloc] initWithCoordinate:centerCoordinate addressDictionary:nil];
    droppedPin.coordinate = centerCoordinate;
    droppedPin.title = NSLocalizedString(@"Dropped Pin", nil);
    [_mapView addAnnotation:droppedPin];
    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
//    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (!error && placemarks.count > 0) {
//             CLPlacemark *placemark = placemarks[0];
//             droppedPin.subtitle = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
//             droppedPin.addressDictionary = placemark.addressDictionary;
//         }
//     }];
}


- (void)configurationViewControllerWillPrintMap:(ConfigurationViewController *)configurationViewController
{
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        return;
    }
    
    UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(completed && error) {
            return;
        }
    };
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputPhoto;
    
    controller.printInfo = printInfo;
    controller.printFormatter = [_mapView viewPrintFormatter];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //        [controller presentFromBarButtonItem:printButton animated:YES completionHandler:completionHandler];
    } else {
        [controller presentAnimated:YES completionHandler:completionHandler];
    }
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Configure"]) {
        ConfigurationViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.mapType = _mapType;
    } else if ([segue.identifier isEqualToString:@"Details"]) {
        DetailViewController *controller = segue.destinationViewController;
        controller.mapView = _mapView;
        controller.placemark = [sender annotation];
    }
}

#pragma mark -

- (void)saveSessionState {
    MKCoordinateRegion region = _mapView.region;
    CLLocationCoordinate2D center = region.center;
    MKCoordinateSpan span = region.span;
    
    NSMutableDictionary *lastSession = [NSMutableDictionary dictionary];
    [lastSession setObject:[NSNumber numberWithDouble:center.latitude] forKey:@"center.latitude"];
    [lastSession setObject:[NSNumber numberWithDouble:center.longitude] forKey:@"center.longitude"];
    [lastSession setObject:[NSNumber numberWithDouble:span.latitudeDelta] forKey:@"span.latitudeDelta"];
    [lastSession setObject:[NSNumber numberWithDouble:span.longitudeDelta] forKey:@"span.longitudeDelta"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lastSession forKey:@"LastSession"];
}

- (void)restoreSessionState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *lastSession = [defaults objectForKey:@"LastSession"];
    
    if (lastSession) {
        NSNumber *latitude = [lastSession objectForKey:@"center.latitude"];
        NSNumber *longitude = [lastSession objectForKey:@"center.longitude"];
        NSNumber *latitudeDelta = [lastSession objectForKey:@"span.latitudeDelta"];
        NSNumber *longitudeDelta = [lastSession objectForKey:@"span.longitudeDelta"];
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta.doubleValue, longitudeDelta.doubleValue);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        _mapView.region = region;
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self saveSessionState];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [self restoreSessionState];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self saveSessionState];
}

@end
