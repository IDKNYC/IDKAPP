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
        destViewController.maxPx = @2.00; // [NSMutableString stringWithString:@"2"];
        destViewController.maxRadius = @1.00; // [NSMutableString stringWithString:@"1"];
        
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
    
    _picker = [[UIPickerView alloc] init];
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
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [self.view endEditing:YES];
}

- (IBAction)textFieldEditBegin:(id)sender {
    [sender resignFirstResponder];
    
}

// --------------- //

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSegmentedControl];
    [self initPicker];
    self.maxRadius.inputView = self.picker;
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
