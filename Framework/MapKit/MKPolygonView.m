//
//  MKPolygonView.m
//  MapKit
//
//  Created by Rick Fillion on 7/15/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <MapKit/MKPolygonView.h>
#import <MapKit/MKWebScriptObject.h>

@interface MKPolygonView (Private)

- (NSArray *)pathForPolygon:(MKPolygon *)aPolygon webScriptObject:(MKWebScriptObject *)webScriptObject;

@end

@implementation MKPolygonView

- (id)initWithPolygon:(MKPolygon *)polygon;
{
    if (self = [super initWithOverlay:polygon]) {
        
    }
    return self;
}

- (MKPolygon *)polygon
{
    return [super overlay];
}

- (NSString *)viewPrototypeName
{
    return @"google.maps.Polygon";
}

- (NSDictionary *)options
{
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:[super options]];
    
    if (path) {
        if (!interiorPaths) {
            [options setObject:path forKey:@"path"];
        } else {
            NSMutableArray *allPaths = [NSMutableArray arrayWithObject:path];
            [allPaths addObjectsFromArray:interiorPaths];
            [options setObject:allPaths forKey:@"paths"];
        }

    }
    
    return [options copy];
}

- (void)draw:(MKWebScriptObject *)overlayScriptObject
{
    if (!path) {
        path = [self pathForPolygon:[self polygon] webScriptObject:overlayScriptObject];
        if ([self polygon].interiorPolygons) {
            NSMutableArray *interiorPolygonPaths = [NSMutableArray array];
            for (MKPolygon *aPolygon in [self polygon].interiorPolygons) {
                NSArray *interiorPath = [self pathForPolygon:aPolygon webScriptObject:overlayScriptObject];
                [interiorPolygonPaths addObject:interiorPath];
            }
            interiorPaths = [interiorPolygonPaths copy];
        }
    }
    
    [super draw:overlayScriptObject];
}

#pragma mark Private

- (NSArray *)pathForPolygon:(MKPolygon *)aPolygon webScriptObject:(MKWebScriptObject *)webScriptObject
{
    CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * aPolygon.coordinateCount);
    NSRange range = NSMakeRange(0, aPolygon.coordinateCount);
    [aPolygon getCoordinates:coordinates range:range];
    NSMutableArray *newPath = [NSMutableArray array];
    
    for (int i = 0; i< aPolygon.coordinateCount; i++) {
        CLLocationCoordinate2D coordinate = coordinates[i];
        NSString *script = [NSString stringWithFormat:@"new google.maps.LatLng(%f, %f)", coordinate.latitude, coordinate.longitude];
        [newPath addObject:script];
    }
    return [newPath copy];
}

@end
