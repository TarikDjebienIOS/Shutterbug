//
//  FlickrPhotoAnnotation.m
//  Shutterbug
//
//  Created by Tarik Djebien on 15/05/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoAnnotation

@synthesize photo = _photo;

+ (FlickrPhotoAnnotation*) annotationForPhoto:(NSDictionary *)photo
{
    FlickrPhotoAnnotation* annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

- (NSString *) title
{
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (NSString *) subTitle
{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
