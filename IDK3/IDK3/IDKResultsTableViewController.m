
//
//  IDKResultsTableViewController.m
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 SATOKO HIGHSTEIN. All rights reserved.
//

#import "IDKResultsTableViewController.h"

@interface IDKResultsTableViewController () {
    NSMutableArray *searchResults;
}

//@property NSMutableArray *searchResults;

@end

@implementation IDKResultsTableViewController

- (IBAction)searchAgain:(id)sender {
    [self executeSearch];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"gotoDetail"]) {
        IDKDetailViewController *detailView = [segue destinationViewController];
        detailView.selectedVenue = [[IDKDetail alloc] init];
        
        // get selectev venue to pass
        IDKDetail *selectedVenue = [[IDKDetail alloc] init];
        selectedVenue = [self->searchResults objectAtIndex:self.tableView.indexPathForSelectedRow.row ];
        selectedVenue.isEvent = self.isEvent;
        
        detailView.selectedVenue = selectedVenue;
        
    }
}

- (void) executeSearch {
    
    // actually connecting to db
    HomeModel *dbSvc = [[HomeModel alloc] init];
    dbSvc.delegate = self;
    
    
    // set criteria for search
    
    dbSvc.criteriaPrice = _maxPx? _maxPx : [NSMutableString stringWithString:@"1"];
    dbSvc.criteriaRadius = _maxRadius? _maxRadius :[NSMutableString stringWithString:@"1"];
    
    if( _isEvent ) {
        dbSvc.isEvent = TRUE;
        [dbSvc downloadItems];
    } else {
        dbSvc.isEvent = FALSE;
        [dbSvc downloadGooglePlaces];
    }
}


-(void)itemsDownloaded:(NSMutableArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    searchResults = items;
    
    // Reload the table view
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set this view controller object as the delegate and data source for the table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self->searchResults = [[NSMutableArray alloc] init ];
    [self executeSearch];
    
//    NSLog(@"Number of people:", self.numPeople);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self->searchResults count];
//    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     IDKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    // Configure the cell...
    IDKDetail *venue =[self->searchResults objectAtIndex:indexPath.row];
//    cell.textLabel.text = venue.venueName;
    cell.cellName.text = venue.Name;
    cell.cellAddress.text = venue.address;
    cell.cellType.text = venue.type;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    IDKDetailViewController *detailViewController = [[IDKDetailViewController alloc] initWithNibName:@"IDKDetailViewController" bundle:nil];

    [self performSegueWithIdentifier:@"gotoDetail" sender:self];
    
    NSLog(@"I'm here");
//    detailViewController.selectedVenue = [[IDKDetail alloc] init];
//    
//    // Pass the selected object to the new view controller.
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    IDKDetail *tempVenue = [[IDKDetail alloc] init];
//    tempVenue.venueName = cell.textLabel.text; // @"temp name";
//    
//    detailViewController.selectedVenue = tempVenue;
    
    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
