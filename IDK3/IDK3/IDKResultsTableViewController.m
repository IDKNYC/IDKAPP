
//
//  IDKResultsTableViewController.m
//  IDK3
//
//  Created by Mahdi Makki on 7/15/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import "IDKResultsTableViewController.h"

@interface IDKResultsTableViewController () {
    NSMutableArray *searchResults;
}

//@property NSMutableArray *searchResults;
@property (strong, nonatomic) UIBarButtonItem *pickForMe;
@property (weak, nonatomic) IBOutlet UIButton *searchAgainButton;

@end

@implementation IDKResultsTableViewController

- (IBAction)searchAgain:(id)sender {
    [self executeSearch];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToDetail"]) {
        IDKDetailsViewController *detailView = [segue destinationViewController];
        detailView.selectedVenue = [[IDKDetail alloc] init];
        
        // get selectev venue to pass
        IDKDetail *selectedVenue = [[IDKDetail alloc] init];
        selectedVenue = [self->searchResults objectAtIndex:self.tableView.indexPathForSelectedRow.row ];
        
        detailView.selectedVenue = selectedVenue;
    }
}

- (void) executeSearch {
    
    // actually connecting to db
    HomeModel *dbSvc = [[HomeModel alloc] init];
    dbSvc.delegate = self;
    
    
    // set criteria for search
    
    dbSvc.criteriaPrice = _maxPx;
    dbSvc.criteriaRadius = _maxRadius;
    
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
    
//    [[self.searchAgainButton layer] setBorderWidth:3.0f];
//    [[self.searchAgainButton layer] setBorderColor:[UIColor grayColor].CGColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.pickForMe = [[UIBarButtonItem alloc] initWithTitle:@"Pick one" style:UIBarButtonItemStylePlain target:self action:@selector(pickForMeHandler:)];
    self.navigationItem.rightBarButtonItem = self.pickForMe;
    self->searchResults = [[NSMutableArray alloc] init];
    [self executeSearch];
    
//    NSLog(@"Number of people:", self.numPeople);
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImage *image = [UIImage imageNamed: @"ios-search-top.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
    
    self.navigationController.navigationBar.topItem.title = @"Back";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Search Results";
    
    // set the text view to the image view
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void) pickForMeHandler:(UIBarButtonItem *)barButtonItem
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    NSLog(@"pick for me handler");
    int numberOfResults = [self->searchResults count];
    
    int random = arc4random_uniform(numberOfResults*10);
    int selectedRow = 0;
    if (random < 10) {
        // Pick the first
        selectedRow = 0;
    }
    else if (random < 20)
    {
        selectedRow = 1;
    }
    else
    {
        selectedRow = 2;
    }
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
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
    //Set background color of table view (translucent)
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.5 alpha:0.7];
    
//    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     IDKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] init];
    // Configure the cell...
    IDKDetail *venue =[self->searchResults objectAtIndex:indexPath.row];
//    cell.textLabel.text = venue.venueName;
    cell.cellName.text = venue.Name;
    cell.cellAddress.text = venue.address;
    cell.cellType.text = venue.type;
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:137.0/255.0 green:207.0/255.0 blue:240.0/255.0 alpha:1.0];
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
        
    }
    
    return cell;
}

- (NSIndexPath*) tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    return indexPath;
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
    // [self performSegueWithIdentifier:@"goToDetail" sender:self];
    
    NSLog(@"I'm here");
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
