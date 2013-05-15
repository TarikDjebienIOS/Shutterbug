//
//  FlickrPhotoTableViewController.m
//  Shutterbug
//
//  Created by Tarik Djebien on 07/05/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhotoTableViewController.h"
#import "FlickrFetcher.h"


@implementation FlickrPhotoTableViewController

@synthesize photos = _photos;

- (IBAction)refresh:(id)sender 
{
    // Ajout d'un feedback pour indiquer qu'une action asynchrone est en cours
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    // On retire le bouton refresh et on le replace par le spinner
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    // Creation d'un nouveau thread
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    // Lance un traitement run() sur le thread avec le bloc anonyme en parametre
    dispatch_async(downloadQueue, ^{
        // On recupere les photos via HTTP REST
        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Toutes les actions de UIKit sont à executer dans le thread principal
            self.navigationItem.rightBarButtonItem = sender; // On replace le bouton refresh une fois le traitement termine
            self.photos = photos;
        });
    });
    // Ne pas oublier de liberer le thread
    dispatch_release(downloadQueue);
}

-(void) setPhotos:(NSArray *)photos
{
    if(_photos != photos){
        _photos = photos;
        // Optimisation, on refresh la tableView uniquement si elle est présente sur l'écran
        // sur cette application de test, elle est toujours présente
        if(self.tableView.window) [self.tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *photo =[self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = [photo objectForKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo objectForKey:FLICKR_PHOTO_OWNER];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
