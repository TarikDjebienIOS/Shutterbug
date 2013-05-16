//
//  MapViewController.m
//  Shutterbug
//
//  Created by Tarik Djebien on 14/05/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "MapKit/MapKit.h"

@interface MapViewController() <MKMapViewDelegate> 
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end


@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

-(void) updateMapView
{
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    if (self.annotations) {
        [self.mapView addAnnotations:self.annotations];
    }
}

-(void) setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

-(void) setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 30, 30)];
    }
    aView.annotation = annotation;
    [(UIImageView *) aView.leftCalloutAccessoryView setImage:nil];
    return aView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    dispatch_queue_t downloadImageAnnotationQueue = dispatch_queue_create("image annotation downloader", NULL);
    dispatch_async(downloadImageAnnotationQueue, ^{
        UIImage *image = [self.delegate mapViewController:self imageForAnnotation:view.annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIImageView *) view.leftCalloutAccessoryView setImage:image];
        });
    });
    dispatch_release(downloadImageAnnotationQueue);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setAnnotations:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
