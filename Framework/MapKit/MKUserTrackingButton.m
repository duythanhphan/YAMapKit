//
//  MKUserTrackingButton.m
//  MapKit
//
//  Created by kishikawa katsumi on 2012/10/23.
//
//

#import <MapKit/MKUserTrackingButton.h>
#import <MapKit/MKUserTrackingBarButtonItem.h>

////////////////////////////////////////////////////////////////////////
#pragma mark - Customize Section
////////////////////////////////////////////////////////////////////////

// animation durations
#define kShrinkAnimationDuration            0.25
#define kExpandAnimationDuration            0.25
#define kExpandAnimationDelay               0.1

// size & insets
#define kWidthPortrait                      32.f
#define kHeightPortrait                     44.f
#define kWidthLandscape                    32.f
#define kHeightLandscape                    32.f

#define kActivityIndicatorInsetPortrait     6.f
#define kImageViewInsetPortrait             5.f

#define kActivityIndicatorInsetLandscape    8.f
#define kImageViewInsetLandscape            6.f

@interface MKUserTrackingButton ()

// Subview: activity indicator is shown during MKLocationStatusSearching
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
// Subview: Holds image that is shown in all other LocationStati
@property (nonatomic, strong) UIImageView *buttonImageView;
// the initial frame of the activity indicator
@property (nonatomic, assign) CGRect activityIndicatorFrame;
// the initial frame of the image view
@property (nonatomic, assign) CGRect imageViewFrame;
// the currently displayed sub-view
@property (nonatomic, unsafe_unretained) UIView *activeSubview;
@property (unsafe_unretained, nonatomic, readonly) UIView *inactiveSubview;

@end

@implementation MKUserTrackingButton

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle, Memory Management
////////////////////////////////////////////////////////////////////////

// TrackingEmpty~iphone.png
unsigned char TrackingEmpty_iphone_png[] = {
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x14,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x8d, 0x89, 0x1d, 0x0d, 0x00, 0x00, 0x00,
    0x1e, 0x49, 0x44, 0x41, 0x54, 0x38, 0x8d, 0x63, 0xfc, 0xff, 0xff, 0x3f,
    0x03, 0x35, 0x01, 0xe3, 0xa8, 0x81, 0xa3, 0x06, 0x8e, 0x1a, 0x38, 0x6a,
    0xe0, 0xa8, 0x81, 0x23, 0xd5, 0x40, 0x00, 0x6b, 0x82, 0x3b, 0xd9, 0xc2,
    0xd5, 0x78, 0xdc, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4e, 0x44, 0xae,
    0x42, 0x60, 0x82
};
unsigned int TrackingEmpty_iphone_png_len = 87;

// TrackingEmpty~iphone@2x.png
unsigned char TrackingEmpty_iphone_2x_png[] = {
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x28, 0x00, 0x00, 0x00, 0x28,
    0x01, 0x03, 0x00, 0x00, 0x00, 0xb6, 0x30, 0x2a, 0x2e, 0x00, 0x00, 0x00,
    0x03, 0x50, 0x4c, 0x54, 0x45, 0xff, 0xff, 0xff, 0xa7, 0xc4, 0x1b, 0xc8,
    0x00, 0x00, 0x00, 0x01, 0x74, 0x52, 0x4e, 0x53, 0x00, 0x40, 0xe6, 0xd8,
    0x66, 0x00, 0x00, 0x00, 0x0c, 0x49, 0x44, 0x41, 0x54, 0x08, 0x1d, 0x63,
    0x60, 0x18, 0x59, 0x00, 0x00, 0x00, 0xf0, 0x00, 0x01, 0x94, 0xb1, 0xe2,
    0x56, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60,
    0x82
};
unsigned int TrackingEmpty_iphone_2x_png_len = 97;

// TrackingLocation~iphone.png
unsigned char TrackingLocation_iphone_png[] = {
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x13, 0x00, 0x00, 0x00, 0x10,
    0x08, 0x06, 0x00, 0x00, 0x00, 0xf4, 0xc4, 0x44, 0x62, 0x00, 0x00, 0x01,
    0x13, 0x49, 0x44, 0x41, 0x54, 0x78, 0xda, 0xad, 0x92, 0x3f, 0x4b, 0xc3,
    0x40, 0x18, 0x87, 0xa3, 0x55, 0x90, 0xa2, 0x14, 0x07, 0x41, 0xc1, 0x06,
    0x87, 0x0a, 0x62, 0x47, 0xa7, 0x2e, 0x7e, 0x05, 0x47, 0x27, 0xbf, 0x82,
    0x53, 0x70, 0x6a, 0x8a, 0x9f, 0xc0, 0x29, 0x0e, 0xa5, 0xe0, 0x27, 0x90,
    0x6c, 0x8e, 0x92, 0x5d, 0xcc, 0xec, 0xe2, 0x90, 0x6c, 0xd9, 0x22, 0x04,
    0x22, 0x98, 0x3f, 0xe7, 0x43, 0x79, 0x0f, 0xb2, 0x84, 0xa6, 0x9e, 0x3f,
    0x78, 0x78, 0x2f, 0xe4, 0x78, 0xf8, 0x71, 0x77, 0xd6, 0x1f, 0xb3, 0x09,
    0xdb, 0xd0, 0x53, 0x4a, 0x59, 0x9a, 0x65, 0x58, 0x74, 0x82, 0x6c, 0xc1,
    0x3e, 0x9c, 0xba, 0xae, 0x3b, 0xce, 0xf3, 0xfc, 0x78, 0x6d, 0x99, 0xb4,
    0x38, 0x80, 0x33, 0xc7, 0x71, 0xae, 0xe2, 0x38, 0x5e, 0xd4, 0x75, 0x9d,
    0xf0, 0x6f, 0xb7, 0xb3, 0x8c, 0xec, 0xc0, 0x11, 0x9c, 0x7b, 0x9e, 0x77,
    0x13, 0x45, 0xd1, 0x73, 0x55, 0x55, 0xdf, 0x8a, 0x14, 0x45, 0x31, 0x93,
    0x7d, 0xed, 0x32, 0xb2, 0x01, 0x7d, 0x18, 0xc2, 0xd8, 0xf7, 0xfd, 0xdb,
    0x24, 0x49, 0x5e, 0x97, 0x12, 0x09, 0xad, 0x32, 0x86, 0xdd, 0x26, 0xd3,
    0x87, 0xba, 0x07, 0x27, 0xb6, 0x6d, 0x5f, 0x04, 0x41, 0x70, 0x9f, 0xa6,
    0xe9, 0x9b, 0x96, 0x34, 0x53, 0x96, 0xe5, 0x5c, 0x0b, 0x9a, 0x68, 0xc9,
    0x00, 0x46, 0x97, 0x24, 0x0c, 0xc3, 0x87, 0x2c, 0xcb, 0x3e, 0x54, 0x4b,
    0x68, 0x95, 0x33, 0x26, 0x60, 0xb5, 0x35, 0x3b, 0x84, 0x29, 0x7c, 0xa9,
    0x15, 0xe1, 0xac, 0x5e, 0x9a, 0x82, 0xb5, 0x6f, 0x93, 0x36, 0x3f, 0x8d,
    0x56, 0xd7, 0x06, 0x32, 0x90, 0x70, 0x7e, 0xef, 0x8c, 0x9e, 0x91, 0x4c,
    0xb7, 0x42, 0x76, 0x27, 0xdf, 0x66, 0x32, 0x44, 0x9f, 0x8c, 0x81, 0xb1,
    0x4c, 0x9e, 0xc3, 0xa3, 0xac, 0xcd, 0x64, 0xf2, 0x48, 0x47, 0xff, 0x22,
    0xa3, 0xd5, 0x53, 0x87, 0xf6, 0x22, 0x5a, 0xcd, 0xa4, 0xcb, 0xbe, 0x5f,
    0x97, 0x56, 0x24, 0x0b, 0xeb, 0xb2, 0x91, 0x94, 0x00, 0x00, 0x00, 0x00,
    0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82
};
unsigned int TrackingLocation_iphone_png_len = 332;

// TrackingLocation~iphone@2x.png
unsigned char TrackingLocation_iphone_2x_png[] = {
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x26, 0x00, 0x00, 0x00, 0x20,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x7e, 0x64, 0x0a, 0xb3, 0x00, 0x00, 0x02,
    0x02, 0x49, 0x44, 0x41, 0x54, 0x78, 0xda, 0xc5, 0x96, 0xbd, 0x4b, 0x42,
    0x51, 0x18, 0xc6, 0xb3, 0xec, 0xcb, 0x2c, 0x31, 0x0a, 0x82, 0x22, 0x68,
    0x28, 0x28, 0x0c, 0x82, 0xa0, 0xa2, 0x12, 0xb7, 0x0b, 0x0d, 0xad, 0x51,
    0x4b, 0x88, 0x34, 0xf8, 0x07, 0xd4, 0xd6, 0x10, 0x12, 0xad, 0x91, 0x63,
    0x83, 0x10, 0xb6, 0x47, 0x24, 0xde, 0x29, 0x42, 0xfc, 0x03, 0x42, 0x69,
    0xd3, 0x26, 0x49, 0x32, 0x74, 0x50, 0x0b, 0x15, 0x3f, 0x4e, 0xcf, 0x8d,
    0x13, 0x45, 0x5f, 0xaf, 0xda, 0xad, 0xf7, 0x81, 0x1f, 0x67, 0x10, 0xce,
    0xfd, 0x9d, 0xc3, 0x7d, 0x1f, 0x6f, 0x8b, 0x10, 0xe2, 0x05, 0x86, 0x18,
    0x80, 0x7c, 0xfe, 0x67, 0x68, 0x31, 0xfd, 0x65, 0x3a, 0x80, 0x09, 0x58,
    0x41, 0x1b, 0x21, 0xf6, 0xb7, 0x20, 0xad, 0x52, 0xc8, 0x02, 0x26, 0xc0,
    0xbc, 0x5c, 0x8d, 0x2c, 0x62, 0x52, 0xa8, 0x0b, 0xf4, 0x83, 0x49, 0xb0,
    0x08, 0xec, 0x7e, 0xbf, 0x7f, 0x27, 0x95, 0x4a, 0xed, 0x69, 0xbf, 0xff,
    0xab, 0x18, 0xd2, 0x06, 0xba, 0xc1, 0x20, 0x98, 0x06, 0xcb, 0x66, 0xb3,
    0xd9, 0xa1, 0xaa, 0xea, 0x41, 0x2e, 0x97, 0xbb, 0x15, 0x48, 0x32, 0x99,
    0x54, 0x7e, 0xda, 0x43, 0x4f, 0x19, 0x03, 0x30, 0x02, 0x13, 0x18, 0x02,
    0x33, 0x60, 0xd9, 0x66, 0xb3, 0x29, 0xe1, 0x70, 0xf8, 0xa8, 0x58, 0x2c,
    0x3e, 0x08, 0x99, 0x52, 0xa9, 0x74, 0xa3, 0xc9, 0x13, 0x62, 0xba, 0x08,
    0xb5, 0x83, 0x1e, 0x30, 0x02, 0x66, 0x81, 0x5d, 0x51, 0x94, 0xd5, 0x68,
    0x34, 0x7a, 0x5a, 0x2e, 0x97, 0x1f, 0xc5, 0x87, 0xa4, 0xd3, 0xe9, 0x4d,
    0x6a, 0xdf, 0xdf, 0x0a, 0x75, 0x80, 0x5e, 0x30, 0x06, 0xe6, 0x80, 0xdd,
    0xed, 0x76, 0xaf, 0xc7, 0xe3, 0xf1, 0xf3, 0x6a, 0xb5, 0x5a, 0x14, 0x5f,
    0x04, 0xa2, 0x77, 0x4e, 0xa7, 0xb3, 0x8b, 0x16, 0x6b, 0x7e, 0xc2, 0xfa,
    0xc0, 0x38, 0x58, 0x00, 0x76, 0x8f, 0xc7, 0xb3, 0x95, 0x48, 0x24, 0x2e,
    0x05, 0x91, 0x6c, 0x36, 0xbb, 0xab, 0x1d, 0x8a, 0x16, 0x6b, 0x4c, 0xa8,
    0x13, 0x58, 0xdf, 0x4f, 0x98, 0xcf, 0xe7, 0xdb, 0xce, 0x64, 0x32, 0xd7,
    0xa2, 0x8e, 0xe0, 0x16, 0x9f, 0x82, 0xc1, 0xe0, 0x60, 0x3d, 0xcf, 0x6b,
    0x64, 0xc2, 0x06, 0x80, 0x0d, 0x2c, 0x69, 0x13, 0x16, 0x08, 0x04, 0xf6,
    0xe5, 0x84, 0xd5, 0x9d, 0x7c, 0x3e, 0x7f, 0x4c, 0xde, 0x96, 0xa4, 0xe1,
    0x09, 0x0b, 0x85, 0x42, 0x87, 0x85, 0x42, 0xe1, 0x5e, 0x34, 0x98, 0x5a,
    0xad, 0x56, 0x8d, 0xc5, 0x62, 0x53, 0xa4, 0x94, 0xe4, 0x1b, 0xa1, 0xcf,
    0x13, 0x16, 0x89, 0x44, 0x4e, 0xf0, 0xe2, 0x66, 0x45, 0x93, 0xc1, 0x61,
    0xd4, 0xb7, 0x42, 0xa5, 0xf9, 0xea, 0x1d, 0x1a, 0x7e, 0x15, 0x72, 0xb9,
    0x5c, 0x6b, 0x38, 0xe5, 0x99, 0x9c, 0xb0, 0xa6, 0x43, 0x14, 0x2a, 0x29,
    0xd6, 0x0e, 0x46, 0xc1, 0xb4, 0xd7, 0xeb, 0xdd, 0xc0, 0x46, 0xaa, 0xd0,
    0x29, 0x28, 0xd4, 0xc8, 0x0f, 0x85, 0x4a, 0xdf, 0x18, 0x46, 0x79, 0xa5,
    0x52, 0xa9, 0x5c, 0xe9, 0xe0, 0x42, 0x14, 0x2a, 0x8d, 0x5e, 0x7f, 0x47,
    0x16, 0x81, 0x10, 0x85, 0xca, 0x23, 0x46, 0x15, 0x2a, 0x9b, 0x18, 0x55,
    0xa8, 0x6c, 0x62, 0x44, 0xa1, 0xf2, 0x89, 0x11, 0x85, 0xca, 0x27, 0x46,
    0x14, 0x2a, 0xa3, 0x18, 0x5d, 0xa8, 0xfc, 0x62, 0xf8, 0x5a, 0xbd, 0x96,
    0x85, 0xca, 0x2f, 0x46, 0x14, 0x2a, 0x9f, 0x18, 0x51, 0xa8, 0x7c, 0x62,
    0x44, 0xa1, 0xf2, 0x89, 0x11, 0x85, 0xca, 0x26, 0x66, 0x26, 0x0a, 0x95,
    0x4d, 0xac, 0x13, 0x6b, 0x85, 0x28, 0x54, 0x16, 0xb1, 0x56, 0x7c, 0x2e,
    0x5d, 0x68, 0x2b, 0x83, 0x18, 0x89, 0x43, 0xae, 0xba, 0xf0, 0x0c, 0x13,
    0x1f, 0xf8, 0xba, 0xac, 0x02, 0xe6, 0xef, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82
};
unsigned int TrackingLocation_iphone_2x_png_len = 571;

// TrackingHeading~iphone.png
unsigned char TrackingHeading_iphone_png[] = {
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x17, 0x00, 0x00, 0x00, 0x18,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x11, 0x7c, 0x66, 0x75, 0x00, 0x00, 0x02,
    0x30, 0x49, 0x44, 0x41, 0x54, 0x48, 0xc7, 0xb5, 0x95, 0xbf, 0x4f, 0xdb,
    0x40, 0x14, 0xc7, 0x7d, 0xb6, 0x93, 0x80, 0x9b, 0xa6, 0x40, 0x29, 0xad,
    0x44, 0x69, 0xfb, 0x0f, 0x64, 0xab, 0xc4, 0xce, 0x56, 0x89, 0x01, 0xb1,
    0x23, 0x55, 0x22, 0xca, 0x1f, 0xd0, 0xad, 0xea, 0x7f, 0x50, 0x75, 0xed,
    0x14, 0xc4, 0x4a, 0xa7, 0x6e, 0x99, 0x3a, 0xbb, 0x73, 0x51, 0x24, 0x2a,
    0x31, 0x24, 0x45, 0x61, 0x6a, 0x12, 0x21, 0x39, 0xc4, 0xc6, 0xc6, 0x3f,
    0xfa, 0x1e, 0xfa, 0x1e, 0x7a, 0xb5, 0x20, 0x46, 0x0a, 0x9c, 0xf4, 0xd1,
    0x5d, 0xce, 0xef, 0x3e, 0xf7, 0xee, 0x7c, 0xe7, 0xa8, 0x2c, 0xcb, 0x8c,
    0x29, 0xc5, 0x06, 0x8a, 0x28, 0x89, 0xfe, 0x98, 0x48, 0x51, 0xc7, 0xd3,
    0x06, 0xe7, 0x8b, 0x49, 0xcc, 0x01, 0x16, 0x5a, 0x62, 0x02, 0x26, 0x03,
    0x09, 0xc4, 0x97, 0xc4, 0x05, 0x48, 0x6f, 0x93, 0x2b, 0x08, 0xab, 0x44,
    0x99, 0xa8, 0x80, 0x92, 0x58, 0x81, 0xcc, 0x5c, 0x8b, 0x43, 0x10, 0x11,
    0x13, 0x22, 0xc0, 0xe4, 0xd7, 0x03, 0x38, 0xbb, 0x1a, 0x31, 0x0f, 0x1e,
    0x89, 0x76, 0x05, 0x93, 0xd9, 0x22, 0xf3, 0x18, 0xb2, 0x10, 0xb2, 0x00,
    0xe2, 0x12, 0xe2, 0x3d, 0x5e, 0x99, 0x8d, 0x8e, 0x1a, 0x84, 0x55, 0x50,
    0x13, 0xed, 0x79, 0x21, 0x37, 0xc5, 0x5e, 0x47, 0x90, 0x9e, 0x03, 0x0f,
    0xb5, 0x8e, 0xf3, 0xb8, 0xe1, 0x40, 0xfc, 0x84, 0x58, 0x00, 0x8b, 0xc4,
    0x63, 0xc8, 0x1d, 0x64, 0x73, 0x93, 0xdc, 0x17, 0x62, 0xbd, 0x4a, 0x4b,
    0x6f, 0x9d, 0x8d, 0x07, 0xcb, 0x10, 0x72, 0xfd, 0x14, 0xed, 0x05, 0xc8,
    0xe7, 0xc4, 0x20, 0x2d, 0x4f, 0x72, 0x99, 0x3b, 0xe2, 0xfd, 0x28, 0x6c,
    0xd1, 0x55, 0xe6, 0xbc, 0x87, 0x7f, 0x88, 0x35, 0x62, 0x05, 0x13, 0x2c,
    0x61, 0x6b, 0x9c, 0xdc, 0xa9, 0x51, 0xe2, 0xa4, 0xe8, 0x97, 0xa9, 0x63,
    0xca, 0x88, 0x19, 0x11, 0x27, 0x1c, 0xa7, 0x5f, 0x28, 0x07, 0xbb, 0xc4,
    0x1b, 0xe2, 0x19, 0x32, 0xaf, 0xe6, 0x06, 0x99, 0x42, 0x2e, 0xb3, 0xaf,
    0x88, 0x98, 0x3e, 0xf1, 0x13, 0xcf, 0xfe, 0x3b, 0x5e, 0x9c, 0xc9, 0x01,
    0xf1, 0x8a, 0x78, 0x8d, 0x8c, 0xe4, 0x8b, 0x54, 0x22, 0x56, 0x4f, 0x60,
    0x8b, 0xe7, 0xc7, 0xc4, 0x37, 0x78, 0xae, 0x2f, 0x8c, 0x2c, 0xbc, 0xcc,
    0xcf, 0xd8, 0x26, 0x9d, 0x91, 0x3e, 0xe7, 0x96, 0x40, 0x4b, 0xf5, 0x7d,
    0xe8, 0x12, 0x5f, 0x30, 0xde, 0xb8, 0x4d, 0x6e, 0xe0, 0xa6, 0x7d, 0x24,
    0x8e, 0x72, 0x59, 0xfb, 0x93, 0xc9, 0x64, 0x17, 0x27, 0x44, 0x89, 0x49,
    0x38, 0xee, 0x13, 0xc6, 0x19, 0x45, 0x72, 0x03, 0xa7, 0xe0, 0x03, 0x71,
    0xa8, 0xaf, 0x7d, 0x10, 0x04, 0xdf, 0x9b, 0xcd, 0xe6, 0x29, 0xd7, 0xe2,
    0x53, 0x70, 0x88, 0xb8, 0xe0, 0x46, 0x0b, 0x7f, 0xb8, 0xa6, 0xe0, 0x10,
    0x7b, 0x84, 0xdb, 0x6a, 0xb5, 0x5e, 0x7a, 0x9e, 0xb7, 0xcf, 0x35, 0xff,
    0x46, 0xbf, 0x33, 0x6d, 0x7c, 0x91, 0xfc, 0x6a, 0x02, 0xda, 0x8e, 0x2d,
    0xd7, 0x75, 0x37, 0xa8, 0x9d, 0xb5, 0xdb, 0xed, 0x75, 0xdf, 0xf7, 0xb7,
    0x8b, 0xc4, 0x77, 0x92, 0x63, 0xf9, 0xce, 0x68, 0x34, 0xda, 0x67, 0xf9,
    0x70, 0x38, 0xfc, 0x8a, 0xdb, 0xa8, 0xee, 0x43, 0x6e, 0x35, 0x1a, 0x8d,
    0xe7, 0x49, 0x92, 0x9c, 0xb1, 0x3c, 0x8e, 0xe3, 0xbf, 0xf5, 0x7a, 0x9d,
    0xef, 0x81, 0x75, 0x1f, 0xf2, 0x72, 0xaf, 0xd7, 0x7b, 0x9f, 0x89, 0xd2,
    0xed, 0x76, 0x77, 0xb8, 0x7f, 0x26, 0xb9, 0xfe, 0xc6, 0x47, 0x51, 0xf4,
    0x83, 0x32, 0x3f, 0x1e, 0x0c, 0x06, 0x6f, 0xa9, 0xfe, 0x1d, 0x86, 0x61,
    0x1b, 0xe7, 0x5b, 0xcd, 0x22, 0x37, 0x3b, 0x9d, 0xce, 0x5a, 0x9a, 0xa6,
    0x9d, 0x7e, 0xbf, 0xbf, 0xca, 0x7d, 0xb4, 0x8a, 0x17, 0xf4, 0xfb, 0x17,
    0xf7, 0xf3, 0xf3, 0x99, 0x32, 0xa7, 0x3d, 0xde, 0x1c, 0x8f, 0xc7, 0x2b,
    0xb2, 0x9f, 0x7f, 0x53, 0xff, 0xbb, 0xa2, 0xcc, 0x55, 0xc1, 0x1f, 0xf4,
    0x4c, 0xc5, 0x34, 0x1e, 0xb0, 0x3c, 0xa8, 0xfc, 0x1f, 0x2b, 0xbb, 0x71,
    0x2b, 0x2e, 0xbc, 0x20, 0x4d, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4e,
    0x44, 0xae, 0x42, 0x60, 0x82
};
unsigned int TrackingHeading_iphone_png_len = 617;

// TrackingHeading~iphone@2x.png
unsigned char TrackingHeading_iphone_2x_png[] = {
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x2e, 0x00, 0x00, 0x00, 0x30,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x6e, 0x65, 0x48, 0xdc, 0x00, 0x00, 0x04,
    0xe4, 0x49, 0x44, 0x41, 0x54, 0x68, 0xde, 0xed, 0x99, 0xcf, 0x6b, 0x14,
    0x49, 0x14, 0xc7, 0xbb, 0xfa, 0xc7, 0x4c, 0x26, 0x23, 0xa2, 0x28, 0x2c,
    0xbb, 0x1b, 0x61, 0xbd, 0x45, 0x62, 0x0e, 0x9e, 0xbc, 0xea, 0xc9, 0xa3,
    0x20, 0x0b, 0x2b, 0xcb, 0x7a, 0x58, 0x48, 0x54, 0x56, 0x10, 0x03, 0xfe,
    0x0b, 0x7a, 0x10, 0x05, 0xbd, 0x89, 0xe2, 0xc9, 0x28, 0xa2, 0xc1, 0x8b,
    0x17, 0xc5, 0xdc, 0x72, 0xd8, 0xc3, 0x4a, 0x20, 0xb0, 0x17, 0x2f, 0x66,
    0xb3, 0x89, 0x92, 0x38, 0x06, 0x9d, 0x30, 0x99, 0x71, 0x7a, 0x7a, 0xba,
    0x7d, 0x4f, 0x5e, 0xc9, 0xe3, 0x51, 0xd5, 0xf3, 0xab, 0xc0, 0x11, 0x2c,
    0xf8, 0x52, 0x35, 0x5d, 0xd5, 0x55, 0x9f, 0x7e, 0xf5, 0xea, 0x55, 0x75,
    0x8f, 0xca, 0xb2, 0xcc, 0x1b, 0x30, 0x29, 0x52, 0x00, 0xf2, 0xa9, 0xec,
    0xd1, 0x6f, 0x4c, 0x6d, 0xca, 0x71, 0xa0, 0x94, 0x69, 0xa0, 0x81, 0xc3,
    0x3e, 0xef, 0x43, 0xa8, 0x88, 0xe5, 0x8a, 0x01, 0xcb, 0x3c, 0x33, 0xe4,
    0xa8, 0x44, 0xa8, 0x37, 0x6b, 0xf5, 0x60, 0x71, 0x9f, 0x20, 0x8b, 0xcc,
    0xba, 0x3e, 0x83, 0xf6, 0x0d, 0xd0, 0x9e, 0x05, 0x3a, 0x15, 0x33, 0x80,
    0xb3, 0x12, 0x93, 0x52, 0x57, 0xe0, 0x3e, 0xc1, 0x16, 0xa9, 0x1c, 0x32,
    0x68, 0x29, 0x4f, 0x3c, 0x80, 0x27, 0x80, 0xa5, 0xbb, 0x70, 0x25, 0x94,
    0x23, 0x7c, 0x93, 0xb9, 0x58, 0xcf, 0xe0, 0x38, 0xf8, 0x08, 0xc9, 0x27,
    0x2b, 0x87, 0xcc, 0xda, 0x81, 0x28, 0x73, 0x78, 0x25, 0x5c, 0x45, 0x0f,
    0xc2, 0x2d, 0xac, 0x73, 0x5e, 0x4e, 0xd8, 0x6f, 0x84, 0x6f, 0xd8, 0xd6,
    0x82, 0xcd, 0xc7, 0x0b, 0xa0, 0x12, 0x83, 0xe5, 0x0a, 0x44, 0x59, 0xce,
    0x82, 0xb2, 0x80, 0x67, 0x06, 0xeb, 0x26, 0x02, 0x98, 0xfb, 0xbc, 0x22,
    0xd7, 0x6c, 0xd0, 0x2c, 0xe4, 0x82, 0x2b, 0x02, 0x2e, 0x0a, 0xd8, 0x48,
    0x94, 0x23, 0x01, 0x1f, 0x18, 0xfc, 0x5e, 0xba, 0x4a, 0x2a, 0xac, 0xac,
    0x41, 0x5b, 0x22, 0xd7, 0xe5, 0x80, 0xca, 0x7a, 0x6d, 0xd5, 0xb9, 0xf5,
    0x43, 0xe1, 0xcb, 0x65, 0x06, 0x15, 0x09, 0x15, 0x48, 0x21, 0xe5, 0x36,
    0x78, 0xb9, 0x50, 0xf9, 0x62, 0x94, 0xd0, 0x09, 0x59, 0xb3, 0xc5, 0x14,
    0x53, 0x3f, 0x2d, 0xc3, 0xe2, 0xaf, 0x6b, 0xdf, 0x0f, 0x59, 0x78, 0xe3,
    0xd0, 0x05, 0x01, 0xab, 0x55, 0x64, 0x65, 0x9b, 0xe5, 0xbb, 0x01, 0xe7,
    0x96, 0x6d, 0x91, 0x3f, 0xeb, 0x3c, 0x64, 0xf0, 0xa6, 0xc8, 0xb5, 0x8d,
    0xf7, 0xea, 0x41, 0xcb, 0xcc, 0xca, 0x12, 0x94, 0x6b, 0x44, 0xd4, 0x73,
    0xf8, 0x40, 0x6c, 0x42, 0xca, 0x10, 0x02, 0x4d, 0xd6, 0x8e, 0xa9, 0xef,
    0x98, 0xfa, 0x6a, 0x8a, 0xf5, 0x23, 0xfb, 0x43, 0xd6, 0x7a, 0x48, 0x3e,
    0xcd, 0xad, 0x2c, 0x41, 0xb9, 0x24, 0xbc, 0x09, 0x3c, 0xb0, 0xf8, 0x78,
    0x3b, 0x07, 0x1c, 0xf5, 0xd1, 0xd0, 0x9f, 0x6f, 0xd9, 0x1f, 0x4a, 0x21,
    0xf9, 0x4d, 0x89, 0x6e, 0xe0, 0x70, 0x25, 0x06, 0x5c, 0x62, 0xbf, 0x8b,
    0xcc, 0x65, 0xa4, 0xbb, 0xf8, 0x1d, 0x2c, 0x9e, 0x8a, 0xc8, 0x11, 0xb3,
    0xb8, 0x1d, 0xb1, 0x35, 0x14, 0xe4, 0xcc, 0x20, 0x3e, 0x78, 0x35, 0xa4,
    0xc2, 0x7b, 0xd0, 0x3e, 0x02, 0xd2, 0x80, 0xa3, 0x0c, 0x78, 0x94, 0x3d,
    0x40, 0x91, 0xb9, 0x51, 0x24, 0xa2, 0x4f, 0xb7, 0xe0, 0x6d, 0xb1, 0x18,
    0xf5, 0x0c, 0x36, 0x0c, 0x6e, 0xc7, 0x2d, 0x8d, 0xf7, 0x7e, 0xd0, 0x3e,
    0xee, 0x51, 0x07, 0xaf, 0x41, 0x07, 0x08, 0xb0, 0x4c, 0x90, 0x65, 0x06,
    0x6e, 0xb3, 0x78, 0x98, 0x33, 0xb5, 0xb6, 0x70, 0xc8, 0x17, 0x67, 0x6c,
    0x99, 0xb9, 0x40, 0x18, 0x40, 0x33, 0xc6, 0x32, 0x1c, 0xe2, 0x74, 0xbd,
    0x04, 0x1d, 0x66, 0xd0, 0x65, 0x61, 0x79, 0x0e, 0x6e, 0x5b, 0x98, 0xbe,
    0x65, 0x53, 0x4b, 0x0d, 0x0b, 0xb4, 0x95, 0xe3, 0xd7, 0xbc, 0x9f, 0x8f,
    0xc4, 0xd6, 0xb4, 0x6d, 0x40, 0x38, 0x55, 0x2f, 0x40, 0xc7, 0x18, 0x74,
    0xd9, 0x00, 0x5e, 0xb0, 0x58, 0x48, 0xba, 0x89, 0x67, 0x89, 0x2c, 0xda,
    0x65, 0x22, 0x82, 0xcf, 0x7b, 0x78, 0x64, 0xfa, 0x87, 0xd6, 0x62, 0xee,
    0x96, 0x5f, 0x03, 0x3d, 0x07, 0x9d, 0x34, 0x58, 0x5c, 0xc6, 0xf1, 0x30,
    0xe7, 0xac, 0x62, 0x3a, 0x1d, 0x72, 0xab, 0x87, 0x04, 0x2f, 0xad, 0xcc,
    0x1f, 0x1c, 0x59, 0xe6, 0x29, 0xef, 0xfa, 0x90, 0xb5, 0x0b, 0x74, 0x1a,
    0xf4, 0x13, 0x5b, 0x9c, 0x12, 0x5a, 0x9f, 0x5b, 0x54, 0x8e, 0xb5, 0x3d,
    0xcb, 0x22, 0x95, 0x2e, 0xc3, 0xc3, 0x22, 0x5a, 0x77, 0x1d, 0x74, 0x1b,
    0xb4, 0x69, 0x3b, 0xb2, 0xda, 0x12, 0xae, 0xde, 0x3b, 0x34, 0x55, 0x23,
    0x22, 0xbe, 0x17, 0x0c, 0xee, 0x62, 0xda, 0xfe, 0xb9, 0xf8, 0x83, 0xca,
    0x63, 0x84, 0xdc, 0x3b, 0x9a, 0x79, 0xd0, 0x9d, 0xc0, 0x3d, 0xba, 0xf1,
    0x2a, 0x3d, 0x44, 0xa7, 0xad, 0x5e, 0x9e, 0xcd, 0x4d, 0xd7, 0x4d, 0x0f,
    0x23, 0x1f, 0x62, 0x8b, 0xc6, 0xdc, 0x74, 0xf1, 0x06, 0xb4, 0x17, 0x74,
    0x05, 0x34, 0x66, 0x38, 0x93, 0x2b, 0xc3, 0x51, 0xd6, 0xeb, 0xe0, 0x2e,
    0x19, 0xdb, 0x4d, 0x79, 0x88, 0x7c, 0x03, 0xba, 0x08, 0x7a, 0xe7, 0xf2,
    0xd5, 0x0d, 0xe1, 0x6f, 0x10, 0xbc, 0xed, 0x1c, 0xe1, 0x75, 0x58, 0x9c,
    0x79, 0xfe, 0xbe, 0x06, 0x9a, 0x01, 0xbd, 0x75, 0xfd, 0xce, 0xc9, 0xe1,
    0xf7, 0x1b, 0xc2, 0x96, 0xea, 0x12, 0x3c, 0x33, 0xc4, 0x76, 0x84, 0xfe,
    0xab, 0x1b, 0x4b, 0x77, 0xeb, 0xe3, 0x32, 0x61, 0xc7, 0x17, 0x40, 0xab,
    0x96, 0xd7, 0xb4, 0x2f, 0xe5, 0x34, 0x4d, 0xef, 0x82, 0x6e, 0xe5, 0xb5,
    0xa1, 0x3e, 0xd0, 0x3d, 0xce, 0xf5, 0x02, 0xdd, 0x8f, 0xc5, 0x75, 0xda,
    0x03, 0xba, 0x09, 0xfa, 0xc5, 0x64, 0x61, 0xe8, 0xf3, 0x7f, 0xdf, 0xf7,
    0x4f, 0xd2, 0x03, 0x3c, 0x54, 0x4a, 0x8d, 0x59, 0x66, 0xe0, 0x3f, 0xb2,
    0x74, 0xa5, 0x57, 0x00, 0xdf, 0xeb, 0x2f, 0xe1, 0x8a, 0x3f, 0x0b, 0x5a,
    0x36, 0x2d, 0xc8, 0x66, 0xb3, 0xf9, 0x78, 0x61, 0x61, 0x61, 0x12, 0x05,
    0xe5, 0x27, 0x96, 0x17, 0xf1, 0x15, 0xea, 0xa3, 0xd2, 0x0f, 0x40, 0xbf,
    0xe0, 0x1a, 0xfe, 0x0c, 0xe8, 0x95, 0xe4, 0x9e, 0x9d, 0x9d, 0x7d, 0x3e,
    0x3e, 0x3e, 0xfe, 0x07, 0x6a, 0x7e, 0x7e, 0xfe, 0xa9, 0xe1, 0x5b, 0xc9,
    0x2b, 0xba, 0x77, 0xb3, 0xef, 0xd1, 0xd1, 0x55, 0x06, 0xd4, 0x6e, 0xd0,
    0x03, 0xd0, 0x0b, 0x54, 0xbb, 0xdd, 0xbe, 0x34, 0x39, 0x39, 0xb9, 0x3b,
    0x49, 0x92, 0x35, 0x14, 0x96, 0xe1, 0xda, 0x55, 0x5d, 0x0f, 0x7a, 0x48,
    0xf7, 0x0c, 0x34, 0xae, 0x0b, 0x70, 0x0d, 0x7f, 0x1f, 0xc1, 0xd6, 0xd7,
    0xd7, 0x0f, 0x2f, 0x2d, 0x2d, 0xfd, 0x9a, 0x51, 0xc2, 0x72, 0xa5, 0x52,
    0x39, 0x4a, 0xd0, 0xf7, 0x5d, 0x40, 0xbb, 0x04, 0x47, 0xed, 0x04, 0x5d,
    0xc6, 0x73, 0xcd, 0xd6, 0xd6, 0xd6, 0x23, 0x0d, 0x8e, 0xe5, 0x89, 0x89,
    0x89, 0x1d, 0x50, 0xbc, 0xee, 0x0a, 0xda, 0x35, 0xf8, 0xe7, 0xd3, 0xe6,
    0xcc, 0xcc, 0xcc, 0xcf, 0x10, 0x49, 0x1a, 0x1a, 0x1c, 0xcb, 0x78, 0x0d,
    0xeb, 0x9c, 0x8e, 0xe5, 0x18, 0xbc, 0xb8, 0xbc, 0xbc, 0x7c, 0x3e, 0x13,
    0x69, 0x65, 0x65, 0x05, 0x63, 0x7f, 0x71, 0x28, 0xc1, 0x29, 0x42, 0xed,
    0xa8, 0xd7, 0xeb, 0x7f, 0x4b, 0x70, 0xbc, 0x86, 0x75, 0xd8, 0x66, 0x18,
    0xc1, 0xa3, 0xb9, 0xb9, 0xb9, 0x43, 0x99, 0x25, 0x61, 0x1d, 0xb6, 0x19,
    0x2a, 0x70, 0xfd, 0x65, 0x77, 0x63, 0x63, 0xe3, 0x8a, 0x0d, 0x1c, 0xea,
    0xae, 0xd1, 0x59, 0x5b, 0xb9, 0x18, 0x53, 0x39, 0xf8, 0x2b, 0xc5, 0x83,
    0x2d, 0xfd, 0xf3, 0x27, 0xbc, 0x38, 0x8e, 0xff, 0x8d, 0xa2, 0x68, 0x9f,
    0xa9, 0x4d, 0xab, 0xd5, 0x5a, 0x2d, 0x14, 0x0a, 0x07, 0xf1, 0x13, 0x1a,
    0x8c, 0xd9, 0x1e, 0x74, 0x4c, 0xdf, 0x73, 0x93, 0x82, 0xc5, 0xc5, 0xc5,
    0x23, 0x1c, 0x1a, 0xfc, 0x7a, 0x1a, 0xa5, 0x3f, 0x52, 0x62, 0x1d, 0xb6,
    0x61, 0xff, 0x0d, 0x0d, 0x96, 0x1c, 0xb9, 0xc9, 0x68, 0xb5, 0x5a, 0xbd,
    0x47, 0x5e, 0x91, 0x6c, 0x6f, 0x6f, 0x4f, 0xe9, 0x53, 0x20, 0x96, 0xf1,
    0x1a, 0x56, 0x40, 0x9b, 0x07, 0xf4, 0xfe, 0xaa, 0xbe, 0xba, 0x8f, 0xa3,
    0x05, 0xa7, 0xa6, 0xa6, 0x7e, 0x80, 0x78, 0x5d, 0x45, 0xc0, 0x5a, 0xad,
    0xf6, 0x27, 0x07, 0xc3, 0x72, 0xa3, 0xd1, 0x38, 0x85, 0x75, 0xd0, 0xa6,
    0x86, 0x6d, 0xf1, 0x9e, 0x61, 0x00, 0x8f, 0x60, 0xe1, 0x9d, 0x46, 0x30,
    0x04, 0x34, 0x59, 0x93, 0xe0, 0x7f, 0xc7, 0x36, 0xb0, 0xfd, 0x4f, 0xbb,
    0x88, 0x2e, 0x4e, 0x76, 0x4b, 0x38, 0x4c, 0x3d, 0x43, 0xb0, 0x3c, 0x17,
    0xc0, 0x3a, 0xf0, 0xf9, 0xdf, 0xb0, 0xad, 0x8b, 0x5d, 0x74, 0x60, 0x70,
    0xf0, 0xe1, 0x1f, 0x01, 0xe6, 0x44, 0x37, 0x7e, 0x8b, 0x6d, 0xa0, 0xed,
    0x71, 0xbc, 0x67, 0x18, 0xc2, 0x61, 0xd0, 0xe9, 0xaf, 0x3d, 0x47, 0xf7,
    0x38, 0x79, 0x75, 0xfb, 0xea, 0xc9, 0xf7, 0xbe, 0xd1, 0xf4, 0x1d, 0xfc,
    0x3b, 0x78, 0x97, 0xe9, 0x13, 0x94, 0x67, 0x40, 0xf4, 0x7c, 0x45, 0xd4,
    0x81, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60,
    0x82
};
unsigned int TrackingHeading_iphone_2x_png_len = 1309;

+ (UIImage *)_trackingEmpty
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [UIImage imageNamed:@"TrackingEmpty~ipad"];
    }
    if (scale >= 2.0f) {
        return [UIImage imageWithData:[NSData dataWithBytes:TrackingEmpty_iphone_2x_png length:TrackingEmpty_iphone_2x_png_len]];
    } else {
        return [UIImage imageWithData:[NSData dataWithBytes:TrackingEmpty_iphone_png length:TrackingEmpty_iphone_png_len]];
    }
}

+ (UIImage *)_trackingNoneImage
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [UIImage imageNamed:@"TrackingLocation~ipad"];
    }
    if (scale >= 2.0f) {
        return [UIImage imageWithData:[NSData dataWithBytes:TrackingLocation_iphone_2x_png length:TrackingLocation_iphone_2x_png_len]];
    } else {
        return [UIImage imageWithData:[NSData dataWithBytes:TrackingLocation_iphone_png length:TrackingLocation_iphone_png_len]];
    }
}

+ (UIImage *)_trackingFollowImage
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [UIImage imageNamed:@"TrackingLocation~ipad"];
    }
    if (scale >= 2.0f) {
        return [UIImage imageWithData:[NSData dataWithBytes:TrackingLocation_iphone_2x_png length:TrackingLocation_iphone_2x_png_len]];
    } else {
        return [UIImage imageWithData:[NSData dataWithBytes:TrackingLocation_iphone_png length:TrackingLocation_iphone_png_len]];
    }
}

+ (UIImage *)_trackingFollowWithHeadingImage
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [UIImage imageNamed:@"TrackingHeading~ipad"];
    }
    if (scale >= 2.0f) {
        return [UIImage imageWithData:[NSData dataWithBytes:TrackingHeading_iphone_2x_png length:TrackingHeading_iphone_2x_png_len]];
    } else {
        return [UIImage imageWithData:[NSData dataWithBytes:TrackingHeading_iphone_png length:TrackingHeading_iphone_png_len]];
    }
}

- (id)initWithFrame:(CGRect)frame {
	CGSize buttonSize = CGSizeMake(kWidthLandscape, kHeightLandscape);
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        buttonSize = CGSizeMake(kWidthPortrait, kHeightPortrait);
    }
    
    if ((self = [super initWithFrame:(CGRect){frame.origin, buttonSize}])) {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            _activityIndicatorFrame = CGRectInset(self.bounds, kActivityIndicatorInsetLandscape, kActivityIndicatorInsetLandscape);
            _imageViewFrame = CGRectInset(self.bounds, kImageViewInsetLandscape , kImageViewInsetLandscape);
        } else {
            _activityIndicatorFrame = CGRectInset(self.bounds, kActivityIndicatorInsetPortrait, kActivityIndicatorInsetPortrait);
            _imageViewFrame = CGRectInset(self.bounds, kImageViewInsetPortrait, kImageViewInsetPortrait);
        }
        
		_trackingMode = MKUserTrackingModeNone;
		_headingEnabled = YES;
        
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:_activityIndicatorFrame];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		_activityIndicator.contentMode = UIViewContentModeScaleAspectFit;
		_activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_activityIndicator.userInteractionEnabled = NO;
        
		_buttonImageView = [[UIImageView alloc] initWithFrame:_imageViewFrame];
		_buttonImageView.contentMode = UIViewContentModeScaleAspectFit;
		_buttonImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
		[self addSubview:_buttonImageView];
        [self addSubview:_activityIndicator];
		[self addTarget:self action:@selector(trackingModeToggled:) forControlEvents:UIControlEventTouchUpInside];
        
		[self updateUI];
	}
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Setter/Getter
////////////////////////////////////////////////////////////////////////

- (UIView *)inactiveSubview {
	if (self.activeSubview == self.activityIndicator) {
		return self.buttonImageView;
	} else {
		return self.activityIndicator;
	}
}

- (BOOL)headingEnabled {
	return [CLLocationManager headingAvailable] && _headingEnabled;
}

- (void)setTrackingMode:(MKUserTrackingMode)trackingMode {
	if (_trackingMode != trackingMode) {
		_trackingMode = trackingMode;
		[self updateUI];
	}
}

- (void)setTrackingMode:(MKUserTrackingMode)trackingMode animated:(BOOL)animated {
	if (_trackingMode != trackingMode) {
		if (animated) {
			// Important: do not use setter here, because otherwise updateUI is triggered too soon!
			_trackingMode = trackingMode;
			[self setSmallFrame:self.inactiveSubview];
            
			// animate currently visible subview to a smaller frame
			// when finished, animate currently invisible subview to big frame
			[UIView beginAnimations:@"AnimateLocationStatusShrink" context:(__bridge void *)[NSNumber numberWithInt:trackingMode]];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:kShrinkAnimationDuration];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(locationStatusAnimationShrinkDidFinish:finished:context:)];
            
			[self setSmallFrame:self.activeSubview];
            
			[UIView commitAnimations];
		} else {
			self.trackingMode = trackingMode;
		}
	}
}

- (void)setActivityIndicatorColor:(UIColor *)activityIndicatorColor {
    if ([self.activityIndicator respondsToSelector:@selector(setColor:)]) {
        self.activityIndicator.color = activityIndicatorColor;
    }
}

- (UIColor *)activityIndicatorColor {
    if ([self.activityIndicator respondsToSelector:@selector(setColor:)]) {
        return self.activityIndicator.color;
    } else {
        return [UIColor whiteColor];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Portrait/Landscape
////////////////////////////////////////////////////////////////////////

- (void)setFrameForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.frame = (CGRect){{self.frame.origin.x, self.frame.origin.y}, kWidthPortrait, kHeightPortrait};
        
        self.activityIndicatorFrame = CGRectInset(self.bounds, kActivityIndicatorInsetPortrait, kActivityIndicatorInsetPortrait);
        self.imageViewFrame = CGRectInset(self.bounds, kImageViewInsetPortrait , kImageViewInsetPortrait);
    } else {
        self.frame = (CGRect){self.frame.origin.x, self.frame.origin.y, kWidthLandscape, kHeightLandscape};
        
        self.activityIndicatorFrame = CGRectInset(self.bounds, kActivityIndicatorInsetLandscape, kActivityIndicatorInsetLandscape);
        self.imageViewFrame = CGRectInset(self.bounds, kImageViewInsetLandscape, kImageViewInsetLandscape);
    }
    
    [self setBigFrame:self.activeSubview];
}


////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Animations
////////////////////////////////////////////////////////////////////////

- (void)locationStatusAnimationShrinkDidFinish:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	// location status changed, now another subview is visible
	[self updateUI];
	// set the inactive subview back to the original frame
	[self setBigFrame:self.inactiveSubview];
    
	// animate the currently visible subview back to a big frame
	[UIView beginAnimations:@"AnimateLocationStatusExpand" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelay:kExpandAnimationDelay];
	[UIView setAnimationDuration:kExpandAnimationDuration];
    
	[self setBigFrame:self.activeSubview];
    
	[UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
////////////////////////////////////////////////////////////////////////

- (void)updateUI {
	switch (self.trackingMode) {
		case MKUserTrackingModeNone:
			[self.activityIndicator stopAnimating];
			self.buttonImageView.image = [[self class] _trackingNoneImage];
			self.activeSubview = self.buttonImageView;
            
            self.userTrackingBarButtonItem.style = UIBarButtonItemStyleBordered;
            
			break;
            
		case MKUserTrackingModeSearching:
			[self.activityIndicator startAnimating];
			self.buttonImageView.image = nil;
			self.activeSubview = self.activityIndicator;
            
            self.userTrackingBarButtonItem.style = UIBarButtonItemStyleBordered;
            
			break;
            
		case MKUserTrackingModeFollow:
			[self.activityIndicator stopAnimating];
			self.buttonImageView.image = [[self class] _trackingFollowImage];
			self.activeSubview = self.buttonImageView;
            
            self.userTrackingBarButtonItem.style = UIBarButtonItemStyleDone;
            
			break;
            
		case MKUserTrackingModeFollowWithHeading:
			[self.activityIndicator stopAnimating];
			self.buttonImageView.image = [[self class] _trackingFollowWithHeadingImage];
			self.activeSubview = self.buttonImageView;
            
            self.userTrackingBarButtonItem.style = UIBarButtonItemStyleDone;
            
			break;
	}
}

// is called when the user taps the button
- (void)trackingModeToggled:(id)sender {
	MKUserTrackingMode newTrackingMode = MKUserTrackingModeNone;
    
	// set new location status
	switch (self.trackingMode) {
			// if we are currently idle, search for location
		case MKUserTrackingModeNone:
			newTrackingMode = MKUserTrackingModeSearching;
			break;
            
			// if we are currently searching, abort and switch back to idle
		case MKUserTrackingModeSearching:
			newTrackingMode = MKUserTrackingModeNone;
			break;
            
			// if we are currently receiving updates next status depends whether heading is supported or not
		case MKUserTrackingModeFollow:
			newTrackingMode = self.headingEnabled ? MKUserTrackingModeFollowWithHeading : MKUserTrackingModeNone;
			break;
            
			// if we are currently receiving heading updates, switch back to idle
		case MKUserTrackingModeFollowWithHeading:
			newTrackingMode = MKUserTrackingModeNone;
			// post notification that heading updates stopped
			[[NSNotificationCenter defaultCenter] postNotificationName:MKLocationManagerDidStopUpdatingHeading object:self userInfo:nil];
			break;
	}
    
	// update to new location status
	[self setTrackingMode:newTrackingMode animated:YES];
    
	// call delegate
    [self.delegate userTrackingButton:self didChangeTrackingMode:newTrackingMode];
}

// sets a view to a smaller frame, used for animation
- (void)setSmallFrame:(UIView *)view {
	double inset = view.frame.size.width / 2.;
    
	view.frame = CGRectMake(view.frame.origin.x + inset, view.frame.origin.y + inset,
							view.frame.size.width - 2*inset, view.frame.size.height - 2*inset);
}

// sets a view to the original bigger frame, used for animation
- (void)setBigFrame:(UIView *)view {
	if (view == self.activityIndicator) {
		view.frame = self.activityIndicatorFrame;
	} else {
		view.frame = self.imageViewFrame;
	}
}

@end
