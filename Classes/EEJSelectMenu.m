//
//  EEJSelectMenu.m
//  EEJSelectMenuExample
//
//  Created by Ehsan on 12/6/15.
//  Copyright © 2015 Ehsan Jahromi. All rights reserved.
//

#import "EEJSelectMenu.h"

static CGFloat const EEJSelectMenuTopGap = 20.0;
static CGFloat const EEJSelectMenuTitleHeight = 60.0;

@interface EEJSelectMenu () <EEJMenuItemDelegate>
@property (strong,nonatomic) EEJMenuItem *item;
@property (strong,nonatomic) NSMutableArray *buttons;
@property (strong,nonatomic) UIColor *menuColors;
@property (assign,nonatomic) long numberOfButtons;
@property (strong,nonatomic) NSArray *colorArray;
@end

@implementation EEJSelectMenu {
    BOOL even;
}

- (instancetype)initWithButtons:(NSArray *)buttons
                 animationStyle:(AnimationStyle)style
                          color:(UIColor *)color
                          title:(NSString *)title
                    andDelegate:(id<EEJSelectMenuDelegate>)delegate {
    self = [super init];
    if (self) {
        self.buttonNames = buttons;
        self.animationStyle = style;
        self.delegate = delegate;
        self.menuColors = color;
        self.menuTitle = title;
    }
    return self;
}

- (instancetype)initWithButtons:(NSArray *)buttons animationStyle:(AnimationStyle)style title:(NSString *)title andColors:(NSArray<UIColor *> *)colors {
    NSAssert(buttons.count == colors.count, @"number of buttons and colors must match");
    
    self = [super init];
    if (self) {
        self.buttonNames = buttons;
        self.animationStyle = style;
        self.colorArray = colors;
        self.menuTitle = title;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMenuItems];
}

- (void)setupMenuItems {
    
    [self setBackgroundColor:self.menuBackgroundColor];
    self.buttons = [NSMutableArray array];
    self.numberOfButtons = self.buttonNames.count;
    
    CGFloat finalTopHeight = self.menuTitle != nil ? (EEJSelectMenuTopGap + EEJSelectMenuTitleHeight) : EEJSelectMenuTopGap;
    CGFloat heightBasedOnNumberOfButtons = ((self.view.bounds.size.height - finalTopHeight) / self.numberOfButtons) - 1.0;
    
    if ([self.menuTitle length]) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(1, EEJSelectMenuTopGap, self.view.bounds.size.width - 2, EEJSelectMenuTitleHeight)];
        titleView.backgroundColor = self.titleBackgroundColor != nil ? self.titleBackgroundColor : [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, titleView.frame.size.width, titleView.frame.size.height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.menuTitle;
        titleLabel.textColor = self.titleTextColor != nil ? self.titleTextColor : [UIColor blackColor];
        [titleView addSubview:titleLabel];
        
        [self.view addSubview: titleView];
        
    }

    for (int i=0; i<self.numberOfButtons; i++) {
        self.item = [[EEJMenuItem alloc]
                     initWithFrame:CGRectMake(1, finalTopHeight + (i * heightBasedOnNumberOfButtons) + i, self.view.bounds.size.width - 2, heightBasedOnNumberOfButtons)];
        self.item.title = self.buttonNames[i];

        if(self.colorArray) {
            self.item.backgroundColor = self.colorArray[i];
        } else {
            self.item.backgroundColor = self.menuColors ? self.menuColors : [UIColor colorWithRed:88/255.0 green:115/255.0 blue:160/255.0 alpha:1.0];
        }
        
        self.item.selectedStateColor = self.selectedButtonColor;
        self.item.tag = 100 + i;
        self.item.delegate = self;
        
        
        [self.buttons addObject:self.item];
        [self.view addSubview:self.item];
    }
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __block float delay = 0.0;
    NSEnumerationOptions enumOption = 0;
    
    switch (self.animationStyle) {
    
        case EEJAnimationStyleFadeIn:{
            [self.buttons enumerateObjectsWithOptions:enumOption usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EEJMenuItem *menu = (EEJMenuItem *)obj;
                [self performSelector:@selector(fadeInAnimation:) withObject:menu afterDelay:delay];
                delay += 0.1;
            }];
        }
            
            break;
        case EEJAnimationStyleWiden:{
            [self.buttons enumerateObjectsWithOptions:enumOption usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EEJMenuItem *menu = (EEJMenuItem *)obj;
                [self performSelector:@selector(widenAnimation:) withObject:menu afterDelay:delay];
                delay += 0.1;
            }];
        }
            break;
        
        case EEJAnimationStyleScale:{
            [self.buttons enumerateObjectsWithOptions:enumOption usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EEJMenuItem *menu = (EEJMenuItem *)obj;
                [self performSelector:@selector(scaleAnimation:) withObject:menu afterDelay:delay];
                delay += 0.1;
            }];
        }
            break;
            
        case EEJAnimationStyleMoveInFromLeft:{
            [self.buttons enumerateObjectsWithOptions:enumOption usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EEJMenuItem *menu = (EEJMenuItem *)obj;
                [self performSelector:@selector(moveInFromLeftAnimation:) withObject:menu afterDelay:delay];
                delay += 0.1;
            }];
        }
            break;
            
        case EEJAnimationStyleMoveInFromRight:{
            [self.buttons enumerateObjectsWithOptions:enumOption usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EEJMenuItem *menu = (EEJMenuItem *)obj;
                [self performSelector:@selector(moveInFromRightAnimation:) withObject:menu afterDelay:delay];
                delay += 0.1;
            }];
        }
            break;
            
        case EEJAnimationStyleAlternate:{
            [self.buttons enumerateObjectsWithOptions:enumOption usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EEJMenuItem *menu = (EEJMenuItem *)obj;
                [self performSelector:@selector(alternateAnimation:) withObject:menu afterDelay:delay];
                delay += 0.1;
            }];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Animations

- (void)fadeInAnimation:(EEJMenuItem *)item {
    [UIView animateWithDuration:0.3 animations:^{
        item.alpha = 1.0;
    }];
}

- (void)widenAnimation:(EEJMenuItem *)item {
    // Grow from middle animation
    item.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3 animations:^{
        item.transform = CGAffineTransformMakeScale(1.0, 1.0);
        item.alpha = 1.0;
    }];
}

- (void)scaleAnimation:(EEJMenuItem *)item {
    // zoom out from middle animation
    item.transform = CGAffineTransformMakeScale(5.0, 5.0);
    [UIView animateWithDuration:0.3 animations:^{
        item.transform = CGAffineTransformMakeScale(1.0, 1.0);
        item.alpha = 1.0;
    }];
}

- (void)moveInFromLeftAnimation:(EEJMenuItem *)item {
    // animate in from sides
    item.frame = CGRectMake(-self.view.bounds.size.width, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        item.frame = CGRectMake(1.0, item.frame.origin.y, item.frame.size.width, item.frame.size.height); //for sides
        item.alpha = 1.0;
    }];
}

- (void)moveInFromRightAnimation:(EEJMenuItem *)item {
    // animate in from sides
    item.frame = CGRectMake(self.view.bounds.size.width, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        item.frame = CGRectMake(1.0, item.frame.origin.y, item.frame.size.width, item.frame.size.height); //for sides
        item.alpha = 1.0;
    }];
}

- (void)alternateAnimation:(EEJMenuItem *)item {
    CGFloat xPosition;
    if (even) {
        even = !even;
        xPosition = -self.view.bounds.size.width;
    }else {
        even = !even;
        xPosition = self.view.bounds.size.width;
    }
    
    // animate in from sides
    item.frame = CGRectMake(xPosition, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        item.frame = CGRectMake(1.0, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
        item.alpha = 1.0;
    }];
}

#pragma mark - Colors

- (void)setBackgroundColor:(UIColor *)color {
    
    self.view.backgroundColor = color ? color : [UIColor whiteColor];
}


#pragma mark - item delegation and animation

- (void)EEJMenuItemWasPressedWithButton:(EEJMenuItem *)button andTitle:(NSString *)title {
    [self selectedAnimation:button];
    
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(EEJSelectMenuButtonWasPressedWithTitle:)]) {
            [self.delegate EEJSelectMenuButtonWasPressedWithTitle:title];
        }
        
        if([self.delegate respondsToSelector:@selector(EEJSelectMenuButtonWasPressedWithTag:)]) {
            [self.delegate EEJSelectMenuButtonWasPressedWithTag:button.tag];
        }
    }
}

- (void)selectedAnimation:(EEJMenuItem *)button {
    
    for (EEJMenuItem *btn in self.buttons) {
        if (btn.tag == button.tag){
            continue;
        }
        [UIView animateWithDuration:0.3 animations:^{
            btn.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
    
}

#pragma mark - Display configurations
- (BOOL)shouldAutorotate {
    return NO;
}

@end

