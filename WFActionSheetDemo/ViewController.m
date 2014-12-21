//
//  ViewController.m
//  WFActionSheetDemo
//
//  Created by Wenfan Jiang on 14/12/21.
//  Copyright (c) 2014年 Wenfan Jiang. All rights reserved.
//

#import "ViewController.h"

#import "WFActionSheet.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(UIButton *)sender {
    
    
    [WFActionSheet showActionSheetWithTitle:@"" cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"destructiveButton" otherButtonTitles:@[@"other",@"other",@"other",] cancel:nil destruct:nil other:nil];
}
@end
