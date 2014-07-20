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
    
    NSInteger number = arc4random_uniform(100);
    
    if(number < 50)
        self.result.text = self.option1.text;
    else
        if (number > 50) {
            
            self.result.text = self.option2.text;
        }

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
