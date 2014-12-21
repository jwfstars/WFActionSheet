//
//  WFActionSheet.m
//  WFActionSheetDemo
//
//  Created by Wenfan Jiang on 14/12/21.
//  Copyright (c) 2014年 Wenfan Jiang. All rights reserved.
//
@import Foundation;
@import UIKit;
#import "WFActionSheet.h"
#import "UIView+WF.h"


@interface WFActionSheet()

@property (copy, nonatomic) WFActionSheetCancelBlock cancelBlock;
@property (copy, nonatomic) WFActionSheetDestructiveBlock destructBlock;
@property (copy, nonatomic) WFActionSheetOtherBlock otherBlock;
@property (copy, nonatomic) NSString *cancelTitle;
@property (copy, nonatomic) NSString *destructTitle;
@property (strong, nonatomic) NSArray *otherTitles;


@property (weak, nonatomic) UIView *cover;
@property (weak, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIView *buttonsView;
@property (strong, nonatomic) NSMutableArray *buttonsArray;
@property (weak, nonatomic) UIButton *cancelButton;

//properties
@property (assign, nonatomic) CGFloat animationDuration;
@property (assign, nonatomic) CGFloat springLevel;
@property (assign, nonatomic) CGFloat buttonCornerRadius;
@property (assign, nonatomic) CGFloat mainCornerRadius;
@property (assign, nonatomic) CGFloat buttonMargin;


@property (strong, nonatomic) UIColor *buttonBorderColor;
@property (assign, nonatomic) CGFloat buttonBorderWidth;

@property (assign, nonatomic) CGFloat leftRightMarin;
@property (assign, nonatomic) CGFloat cancelButtonMargin;
@property (assign, nonatomic) CGFloat buttonHeight;
@end

static WFActionSheet *sharedInstance;
@implementation WFActionSheet
#pragma mark - 初始化单例
+ (WFActionSheet *)actionSheet
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WFActionSheet alloc]init];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        sharedInstance.window = window;
    });
    
    return sharedInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}
+ (WFActionSheet *)appearence
{
    return [WFActionSheet actionSheet];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _animationDuration = 0.4;
        _springLevel = 0.6;
        _mainCornerRadius = 2.5;
        _buttonCornerRadius = _mainCornerRadius;
        _buttonMargin = 1;
        _leftRightMarin = 10;
        _buttonHeight = 40;
        _cancelButtonMargin = 10;
        _tintColor = [UIColor orangeColor];
    }
    return self;
}




- (void)setupButtons
{
    [self addDestructButton];
    [self addOtherButton];
    [self addCancelButton];
}

- (UIView *)cover
{
    if (_cover == nil) {
        CGRect windowFrame = [[UIScreen mainScreen] bounds];
        UIView *cover = [[UIView alloc]init];
        cover.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        cover.frame = windowFrame;
        cover.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [cover addGestureRecognizer:tap];
        _cover = cover;
        
        [_window addSubview:_cover];
        NSLog(@"%@",NSStringFromCGRect(cover.frame));
    }
    return _cover;
}

- (UIView *)buttonsView
{
    if (_buttonsView == nil) {
        UIView *view = [UIView new];
//        view.backgroundColor = [UIColor yellowColor];
        _buttonsView = view;
        _buttonsView.layer.cornerRadius = _mainCornerRadius;
        _buttonsView.clipsToBounds = YES;
        [_window addSubview:_buttonsView];
        
        //buttons
        [self setupButtons];
    }
    return _buttonsView;
}


- (void)addCancelButton
{
    if (_cancelTitle) {
        UIButton *cancelButton = [UIButton new];
        [cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = _tintColor;
        cancelButton.layer.cornerRadius = _buttonCornerRadius;
        cancelButton.layer.borderWidth = _buttonBorderWidth;
        cancelButton.layer.borderColor = [_buttonBorderColor CGColor];
        [_window addSubview:cancelButton];
        _cancelButton = cancelButton;
    }
}


- (void)addDestructButton
{
    if (_destructTitle) {
        UIButton *destructButton = [UIButton new];
        [destructButton setTitle:_destructTitle forState:UIControlStateNormal];
        [destructButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        destructButton.backgroundColor = _tintColor;
        destructButton.layer.borderWidth = _buttonBorderWidth;
        
        [self.buttonsArray addObject:destructButton];
    }
}



- (void)addOtherButton
{
    for (NSString *otherTitle in _otherTitles) {
        
        UIButton *otherButton = [UIButton new];
        [otherButton setTitle:otherTitle forState:UIControlStateNormal];
        [otherButton setTitleColor:_tintColor forState:UIControlStateNormal];
        otherButton.backgroundColor = [UIColor whiteColor];
        otherButton.layer.borderWidth = _buttonBorderWidth;
        
        [self.buttonsArray addObject:otherButton];
    }
}


- (CGFloat)buttonViewHeight
{
    return _buttonsArray.count * (_buttonHeight + _buttonMargin) - _buttonMargin;
}

- (void)show
{
    self.cover.alpha = 0;
    self.buttonsView.alpha = 1;
    
    _buttonsView.frame = CGRectMake(_leftRightMarin, _window.heightOfView, _window.widthOfView - 2*_leftRightMarin, [self buttonViewHeight]);
    
    
    [self.buttonsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        [self.buttonsView addSubview:obj];
        button.frame = CGRectMake(0, idx * (_buttonHeight + _buttonMargin), _buttonsView.widthOfView, _buttonHeight);
    }];
    
    _buttonsView.y = _window.heightOfView;
    [UIView animateWithDuration:_animationDuration delay:0 usingSpringWithDamping:_springLevel initialSpringVelocity:0 options:0 animations:^{
        
        self.cover.alpha = 0.6;
        _buttonsView.y = _window.heightOfView - [self buttonViewHeight] - _buttonHeight - 2*_cancelButtonMargin;
        
    } completion:^(BOOL finished) {
        
    }];

    
    _cancelButton.frame = CGRectMake(_buttonsView.x, _window.heightOfView, _buttonsView.widthOfView, _buttonHeight);
    [UIView animateWithDuration:_animationDuration delay:0.2 usingSpringWithDamping:_springLevel initialSpringVelocity:0 options:0 animations:^{
        _cancelButton.y = CGRectGetMaxY(_buttonsView.frame) + _cancelButtonMargin;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hide
{
    [UIView animateWithDuration:_animationDuration animations:^{
        self.buttonsView.alpha = 0;
        self.cancelButton.alpha = 0;
        self.cover.alpha = 0;
    } completion:^(BOOL finished) {
        [self.buttonsView removeFromSuperview];
        [self.cover removeFromSuperview];
        [self.cancelButton removeFromSuperview];
        
        [self.buttonsArray removeAllObjects];
        _buttonsArray = nil;
        
        
        NSLog(@"%@",_cover);
        NSLog(@"%@",_buttonsView);
    }];
}



- (NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}


+ (void)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles cancel:(WFActionSheetCancelBlock)cancel destruct:(WFActionSheetDestructiveBlock)destruct other:(WFActionSheetOtherBlock)other
{
    WFActionSheet *actionSheet = [WFActionSheet actionSheet];

    actionSheet.cancelBlock = cancel;
    actionSheet.destructBlock = destruct;
    actionSheet.otherBlock = other;
    
    actionSheet.cancelTitle = cancelButtonTitle;
    actionSheet.destructTitle = destructiveButtonTitle;
    actionSheet.otherTitles = otherButtonTitles;
    
    
    
    
    [actionSheet show];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end
