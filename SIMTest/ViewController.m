//
//  ViewController.m
//  SIMTest
//
//  Created by Ostap.Horbach on 8/19/15.
//  Copyright (c) 2015 Ostap.Horbach. All rights reserved.
//

#import "ViewController.h"
#import "SIMManager.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[SIMManager sharedManager] setSimStatusChangedCallback:^(SIMStatus simStatus) {
        switch (simStatus) {
            case SIMStatusInserted:
                NSLog(@"SIM was inserted");
                break;
                
            case SIMStatusRemoved:
                NSLog(@"SIM was removed");
                break;
                
            default:
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testTapped:(id)sender {
    NSLog(@"isSimAvailable %@", @([[SIMManager sharedManager] isSimAvailable]));
    NSLog(@"isSimInserted %@", @([[SIMManager sharedManager] isSimInserted]));
}

@end
