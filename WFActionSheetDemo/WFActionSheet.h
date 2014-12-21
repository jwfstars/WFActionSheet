//
//  WFActionSheet.h
//  WFActionSheetDemo
//
//  Created by Wenfan Jiang on 14/12/21.
//  Copyright (c) 2014年 Wenfan Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WFActionSheetCancelBlock)();
typedef void (^WFActionSheetDestructiveBlock)();
typedef void (^WFActionSheetOtherBlock)(NSInteger buttonIndex);


@class WFActionSheet;
@interface WFActionSheet : NSObject

@property (strong, nonatomic) UIColor *tintColor;

+ (WFActionSheet *)appearence;

+ (void)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles cancel:(WFActionSheetCancelBlock)cancel destruct:(WFActionSheetDestructiveBlock)destruct other:(WFActionSheetOtherBlock)other;

@end
