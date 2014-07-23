//
//  IDKLauncherViewController.m
//  IDK3
//
//  Created by SATOKO HIGHSTEIN on 7/1/14.
//  Copyright (c) 2014 IDKNY. All rights reserved.
//

#import "IDKLauncherViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface IDKLauncherViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *catSelector;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *randomizerButton;

@property (nonatomic, strong) NSMutableString *category;

@end

@implementation IDKLauncherViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoSearchResults"]) {
        IDKResultsTableViewController *destViewController = segue.destinationViewController;
        destViewController.whatType = _category;
        
        NSNumber *dummyPrice = [[NSNumber alloc]init];
        if([ _category isEqualToString:@"Events"]) {
            destViewController.isEvent = YES;
            dummyPrice = @1.00;
        } else {
            destViewController.isEvent = NO;
            dummyPrice = @4;
        }
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle ];
        
        NSLog(@"price:%@", [ f  numberFromString:self.maxPrice.text] );
        
        destViewController.maxPx = (![ self.maxPrice.text isEqual:@"" ]) ? [ f numberFromString:self.maxPrice.text] : dummyPrice;
        NSString *shortString = [[ NSString alloc] init];
        if( [_category isEqualToString:@"Events"] ) {
            shortString = [ self.maxPrice.text  substringWithRange:NSMakeRange(1,  _maxPrice.text.length-1 )];
        } else {
            shortString = self.maxPrice.text;
        }
        //        NSString *shortString = [ self.maxPrice.text  substringWithRange:NSMakeRange(1,  _maxPrice.text.length-1 )];
        
        NSLog(@"%@", shortString);
        
        destViewController.maxPx = (![ self.maxPrice.text isEqual:@"" ]) ? [ f numberFromString:shortString] : dummyPrice;
        destViewController.maxRadius = (![ self.maxRadius.text isEqual:@""])? [f numberFromString: self.maxRadius.text] : @5;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

- (void) formatPriceField {
    if([ self.category isEqualToString:@"Events"]) {
        // --- set the prepending $ sign
        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init ];
//        [currencyFormatter setLocale:[NSLocale currentLocale]];
//        [currencyFormatter setMaximumFractionDigits:2];
//        [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        
        NSNumber *someAmount = [NSNumber numberWithDouble:[self.maxPrice.text doubleValue]];
        NSString *string = [currencyFormatter stringFromNumber:someAmount];
        
        self.maxPrice.text = string;
    } else {
        NSNumberFormatter *blankFormatter = [[ NSNumberFormatter alloc] init ];
        [ blankFormatter setNumberStyle:NSNumberFormatterNoStyle ];
        NSNumber *someAmount = [ NSNumber numberWithDouble:[ self.maxPrice.text doubleValue]];
        if( [someAmount isEqual: @0 ]) {
            someAmount = @1;
        }
        NSString *string = [ blankFormatter stringFromNumber: someAmount ];
        self.maxPrice.text = string;
    }
    
}

// --- segmented control --- //
- (void) initSegmentedControl {
    NSArray *categories = [NSArray arrayWithObjects:@"Test", @"Restaurant", nil];
    self.catSelector = [[UISegmentedControl alloc] initWithItems:categories];
    _catSelector.selectedSegmentIndex = 1;
    _category = [[NSMutableString alloc] initWithString:@"Events"];
//    [_category setString: @"Events"];

    [self.catSelector addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.catSelector];
}

-(IBAction) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    [_category setString: [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]] ];
    [ self formatPriceField ];
    
    if( [_category isEqualToString:@"Events" ]){
        self.maxPrice.placeholder = @"Max in $";
        
    } else {
        self.maxPrice.placeholder = @"1, 2, 3 or 4";
    }
}

// --- pickers --- //
- (void) initPicker {
    _radiusArray = @[@"0.5", @"1", @"2", @"5", @"10"];
    _priceArray = @[@"1", @"2", @"3", @"4"];
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

- (IBAction)valueChanged:(id)sender {
    
    if( sender == self.maxRadius ) {
        NSLog(@" raidus is %@", self.maxRadius.text );
        NSString *radiusInput = self.maxRadius.text;
        if( radiusInput == nil || [radiusInput  isEqual: @""] ) {
            return;
        }
        if(  ![ radiusInput isEqual:@"0.5" ] &&
           ![ radiusInput isEqual:@"1" ] &&
           ![ radiusInput isEqual:@"2"] &&
           ![ radiusInput isEqual:@"5" ] &&
           ![ radiusInput isEqual:@"10" ] )   {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid radius" message:@"Must be 0.5, 1, 2, 5 or 10" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
            
            self.maxRadius.text = @"0.5";
            [alert show];
        }
    } else if ( sender == self.maxPrice ) {
         NSLog(@"Category: %@", self.category);
        
        if( ![_category  isEqual: @"Events"] ) {
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
        } else {
            [ self formatPriceField ];

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
    self.maxRadius.text = @"5";
    [ self formatPriceField ];
    
    
    [[self.searchButton layer] setBorderWidth:3.0f];
    [[self.searchButton layer] setBorderColor:[UIColor grayColor].CGColor];
    
    
    [[self.randomizerButton layer] setBorderWidth:3.0f];
    [[self.randomizerButton layer] setBorderColor:[UIColor grayColor].CGColor];

    
    /*self.searchButton.layer.borderWidth = 1.0f;
    self.searchButton.layer.cornerRadius = 6.0f; 
    self.searchButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.randomizerButton.layer.borderWidth = 1.0;
    self.randomizerButton.layer.cornerRadius = 6.0;
    self.randomizerButton.layer.borderColor = [UIColor grayColor].CGColor; */

    
//    [[self.searchButton layer] setCornerRadius:3.0f];
//    self.maxRadius.inputView = self.picker;
//    NSLog(@"check:%@", [self.picker numberOfComponents] );
}


//Mahdi

- (void)viewWillAppear:(BOOL)animated
{
    UIImage *image = [UIImage imageNamed: @"ios-top.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
    self.navigationItem.title = @"IDK!?";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
