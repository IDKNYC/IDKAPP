//
//  IDKCoinFlipperViewController.m
//  IDK
//
//  Created by MahdiMakki on 6/5/14.
//  Copyright (c) 2014 Capstone. All rights reserved.
//

#import "IDKCoinFlipperViewController.h"

@interface IDKCoinFlipperViewController ()

@end



@implementation IDKCoinFlipperViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.result = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 280, 22)];
    self.result.textAlignment = NSTextAlignmentCenter;
    self.result.font = [UIFont systemFontOfSize:20];
    self.result.alpha = 0.0;
    [self.view addSubview:self.result];
}

- (void) viewWillAppear:(BOOL)animated
{
    UIImage *image = [UIImage imageNamed: @"ios-search-top.png"];
    self.navigationController.navigationBar.topItem.title = @"Back";
    //self.navigationItem.leftBarButtonItem.title = @"Back";
    /*UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 84)];
     imageview.image = image;
     imageview.contentMode = UIViewContentModeScaleAspectFill;
     UILabel *label = [[UILabel alloc] initWithFrame:imageview.frame];
     label.text =@"IDK!?";
     label.textColor = [UIColor whiteColor];
     label.font = [UIFont boldSystemFontOfSize:20.0f];
     label.textAlignment = NSTextAlignmentCenter;
     label.frame = CGRectMake(20, 20, 140, 64);
     self.navigationItem.titleView = imageview;
     [imageview addSubview:label];*/
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
    self.navigationItem.title = @"IDK!?";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Flip:(UIButton *)sender
{
    [self process];
    [self.option1 resignFirstResponder];
    [self.option2 resignFirstResponder];
};



-(IBAction)dismissKeyboard:(UIButton *)sender
{
    [self.option1 resignFirstResponder];
    [self.option2 resignFirstResponder];
}

-(void) process
{  //i want it to do the random stuff here then print it on the label based on the rendom result..
    if (self.result.alpha > 0.0f) {
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.result.alpha = 0.0;
                         }
                         completion:^(BOOL finished){}];
    }
    
    NSInteger number = arc4random_uniform(100);
    NSString *result;
    if(number < 50)
        result = self.option1.text;
    else
        if (number > 50) {
            
            result = self.option2.text;
        }
    [UIView animateWithDuration:0.4
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.result.text = result;
                         self.result.alpha = 1.0;
                     }
                     completion:^(BOOL finished){}];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
