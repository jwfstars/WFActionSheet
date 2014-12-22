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
//    [WFActionSheet appearence].tintColor = [UIColor greenColor];
    [WFActionSheet showActionSheetWithTitle:@"" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@[@"other",@"other",@"other",] cancelBlock:nil otherBlock:^(NSInteger buttonIndex) {
            NSLog(@"000 - %ld",(long)buttonIndex);
    }];
}
@end
