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
#import "AGWindowView.h"

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
@interface WFActionSheet()

@property (copy, nonatomic) WFActionSheetCancelBlock cancelBlock;
@property (copy, nonatomic) WFActionSheetOtherBlock otherBlock;
@property (copy, nonatomic) NSString *cancelTitle;
@property (copy, nonatomic) NSString *destructTitle;
@property (strong, nonatomic) NSArray *otherTitles;


@property (weak, nonatomic) UIView *cover;
@property (weak, nonatomic) UIView *window;
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

@property (assign, nonatomic) CGFloat buttonWidth;

//ios7
@property (assign, nonatomic) CGFloat windowMax;
@property (assign, nonatomic) CGFloat windowMin;
@end

static WFActionSheet *sharedInstance;
@implementation WFActionSheet
#pragma mark - 初始化单例
+ (WFActionSheet *)actionSheet
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WFActionSheet alloc]init];
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
        _buttonWidth = 280;
        _cancelButtonMargin = 10;
        _tintColor = [UIColor orangeColor];
    }
    return self;
}







- (UIView *)buttonsView
{
    if (_buttonsView == nil) {
        UIView *view = [UIView new];
//        view.backgroundColor = [UIColor yellowColor];
        _buttonsView = view;
        _buttonsView.layer.cornerRadius = _mainCornerRadius;
        _buttonsView.clipsToBounds = YES;
        if (iPad) {
            
        }else {
            _buttonsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
        [_window addSubview:_buttonsView];
        
        //buttons
        [self setupButtons];
    }
    return _buttonsView;
}


- (void)setupButtons
{
    [self addDestructButton];
    [self addOtherButton];
    [self addCancelButton];
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
        if (iPad) {
            [self.buttonsArray addObject:cancelButton];
        }else {
            cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [_window addSubview:cancelButton];
        }
        _cancelButton = cancelButton;
        
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
        destructButton.tag = 0;
        if (iPad) {
            
        }else {
            destructButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
        
        [self.buttonsArray addObject:destructButton];
        [destructButton addTarget:self action:@selector(otherbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}



- (void)addOtherButton
{
    int i=0;
    for (NSString *otherTitle in _otherTitles) {
        
        UIButton *otherButton = [UIButton new];
        [otherButton setTitle:otherTitle forState:UIControlStateNormal];
        [otherButton setTitleColor:_tintColor forState:UIControlStateNormal];
        otherButton.backgroundColor = [UIColor whiteColor];
        otherButton.layer.borderWidth = _buttonBorderWidth;
        if (_destructTitle) {
            otherButton.tag = i+1;
        }else {
            otherButton.tag = i;
        }
        if (iPad) {
            
        }else {
            otherButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
        
        
        [self.buttonsArray addObject:otherButton];
        [otherButton addTarget:self action:@selector(otherbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
}


- (CGFloat)buttonViewHeight
{
    return _buttonsArray.count * (_buttonHeight + _buttonMargin) - _buttonMargin;
}



- (void)cancelButtonClick:(UIButton *)sender
{
    if (_cancelBlock) {
        _cancelBlock();
    }
    [self hide];
}


- (void)otherbuttonClick:(UIButton *)sender
{
    if (_otherBlock) {
        _otherBlock(sender.tag);
    }
    [self hide];
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
//        [cover addGestureRecognizer:tap];
        _cover = cover;
        
        [_window addSubview:_cover];
    }
    return _cover;
}



- (void)show
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (iOS8) {
        self.window = window;
    }else {
        AGWindowView *windowView = [[AGWindowView alloc] initAndAddToKeyWindow];
        self.window = windowView;
    }
    _windowMax = MAX(window.widthOfView, window.heightOfView);
    _windowMin = MIN(window.widthOfView, window.heightOfView);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willRotate:) name:UIApplicationWillChangeStatusBarOrientationNotification  object:nil];
    
    if (iPad) {
        [self showInIPAD];
    }else {
        [self showInIPHONE];
    }
    return;
}



- (void)showInIPHONE
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


- (void)showInIPAD
{
    self.cover.alpha = 0;
    self.buttonsView.alpha = 0;
    
    _buttonsView.widthOfView = _buttonWidth;
    _buttonsView.heightOfView = [self buttonViewHeight];
    _buttonsView.center = _window.center;
    _buttonsView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [self.buttonsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        [self.buttonsView addSubview:obj];
        button.frame = CGRectMake(0, idx * (_buttonHeight + _buttonMargin), _buttonWidth, _buttonHeight);
    }];
    
    
    [UIView animateWithDuration:_animationDuration delay:0 usingSpringWithDamping:_springLevel/1.5 initialSpringVelocity:0 options:0 animations:^{
        
        self.cover.alpha = 0.6;
        _buttonsView.alpha = 1;
        _buttonsView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hide
{
    [UIView animateWithDuration:_animationDuration/1.5 animations:^{
        if (iPad) {
            self.buttonsView.alpha = 0;
            self.cancelButton.alpha = 0;
        }else {
            self.buttonsView.y = _window.heightOfView;
            self.cancelButton.y = _window.heightOfView;
        }
        self.cover.alpha = 0;
    } completion:^(BOOL finished) {
        [self.buttonsView removeFromSuperview];
        [self.cover removeFromSuperview];
        [self.cancelButton removeFromSuperview];
        
        [self.buttonsArray removeAllObjects];
        _buttonsArray = nil;
        
        if (iOS8) {
            
        }else {
            [self.window removeFromSuperview];
        }
        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}



+ (void)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles cancelBlock:(WFActionSheetCancelBlock)cancel otherBlock:(WFActionSheetOtherBlock)other
{
    WFActionSheet *actionSheet = [WFActionSheet actionSheet];

    actionSheet.cancelBlock = cancel;
    actionSheet.otherBlock = other;
    
    actionSheet.cancelTitle = cancelButtonTitle;
    actionSheet.destructTitle = destructiveButtonTitle;
    actionSheet.otherTitles = otherButtonTitles;
    
    [actionSheet show];
}


- (void)willRotate:(NSNotification *)notification
{
    if (iOS8) {
    }else {
        UIApplication *app = notification.object;
        if (!UIInterfaceOrientationIsLandscape(app.statusBarOrientation)) {
            _window.widthOfView = _windowMax;
            _window.heightOfView = _windowMin;
        }else {
            _window.widthOfView = _windowMin;
            _window.heightOfView = _windowMax;
        }
    }
    
//    NSLog(@"%@",NSStringFromCGRect(_window.frame));
    if (iPad) {
        _buttonsView.center = _window.center;
    }else {
        _buttonsView.y = _window.heightOfView - [self buttonViewHeight] - _buttonHeight - 2*_cancelButtonMargin;
        _cancelButton.y = CGRectGetMaxY(_buttonsView.frame) + _cancelButtonMargin;
    }
}


- (void)dealloc
{
    NSLog(@"dealloc");
}



- (NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}

@end
