//
//  FlickrPhotoAnnotation.h
//  Shutterbug
//
//  Created by Tarik Djebien on 15/05/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotoAnnotation *) annotationForPhoto:(NSDictionary *) photo; // Flickr Photo Dictionnary 

@property (nonatomic, strong) NSDictionary* photo;

@end
