//
//  IDKLauncherViewController.m
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import "IDKLauncherViewController.h"

@interface IDKLauncherViewController ()

@property (retain, nonatomic) IBOutlet UISegmentedControl *catSelector;

@property (nonatomic, strong) NSMutableString *category;

@end

@implementation IDKLauncherViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoSearchResults"]) {
        IDKResultsTableViewController *destViewController = segue.destinationViewController;
        destViewController.whatType = _category;
        destViewController.maxPx = [NSMutableString stringWithString:@"2"];
        destViewController.maxRadius = [NSMutableString stringWithString:@"1"];
        
        if([ _category isEqualToString:@"Events"]) {
            destViewController.isEvent = YES;
        } else {
            destViewController.isEvent = NO;
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initSegmentedControl];
    }
    return self;
}

// --- segmented control --- //
- (void) initSegmentedControl {
    NSArray *categories = [NSArray arrayWithObjects:@"Test", @"Restaurant", nil];
    self.catSelector = [[UISegmentedControl alloc] initWithItems:categories];
    _catSelector.selectedSegmentIndex = 1;
    _category = [[NSMutableString alloc] initWithString:@"Events"];
//    [_category setString: @"Events"];

    [self.catSelector addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.catSelector];
}

-(IBAction) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    [_category setString: [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]] ];
}

// --- pickers --- //
- (void) initPicker {
    _radiusArray = @[@"0.5", @"1", @"2", @"5", @"10"];
    _priceArray = @[@"1", @"2", @"3", @"4"];
    
//    _picker = [[ UIPickerView alloc] init];
//    _picker.dataSource = self;
//    _picker.delegate = self;
    
//    [self.view addSubview: _picker ];
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _radiusArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _radiusArray[row];
}


#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{   
    _maxRadius.text = _radiusArray[row];
    _picker.hidden = YES;
}

-(IBAction)textFieldReturn:(id)sender
{
    [self.maxRadius resignFirstResponder];
    //    [self.view endEditing:YES];
    _picker.hidden = NO;
}

- (IBAction)valueCanged:(id)sender {
    
    if( sender == self.maxRadius ) {
        NSLog(@" raidus is %@", self.maxRadius.text );
        NSString *radiusInput = self.maxRadius.text;
        if( radiusInput == nil || [radiusInput  isEqual: @""] ) {
            return;
        }
        if(  ![ radiusInput isEqual:@"0.5" ] &&
           ![ radiusInput isEqual:@"1" ] &&
           ![ radiusInput isEqual:@"2"] &&
           ![ radiusInput isEqual:@"5" ] )   {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid radius" message:@"Must be 0.5, 1, 2 or 5" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
            
            self.maxRadius.text = @"0.5";
            [alert show];
        }
    } else if ( sender == self.maxPrice ) {
        if( ![_category  isEqual: @"Event"] ) {
            NSString *priceInput = self.maxPrice.text;
            if( priceInput == nil || [ priceInput  isEqual: @""] ) {
                return;
            }
            if( ![ priceInput isEqual:@"1"] &&
                ![ priceInput isEqual:@"2"] &&
                ![ priceInput isEqual:@"3"] &&
                ![ priceInput isEqual:@"4"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid price level" message:@"Must be 1, 2, 3 or 4" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
                
                self.maxRadius.text = @"1";
                [alert show];
                self.maxPrice.text = @"1";

            }
        }
    }
    
}

// --------------- //

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSegmentedControl];
    [self initPicker];
    
    self.maxPrice.text = @"1";
    self.maxRadius.text = @"0.5";
//    self.maxRadius.inputView = self.picker;
//    NSLog(@"check:%@", [self.picker numberOfComponents] );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
