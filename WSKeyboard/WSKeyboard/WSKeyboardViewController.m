//
//  WSKeyboardViewController.m
//  WSKeyboard
//
//  Created by Attu on 16/8/26.
//  Copyright © 2016年 Attu. All rights reserved.
//

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#import "WSKeyboardViewController.h"
#import "WSKeyboardHeaderView.h"
#import "WSKeyboardEmojiView.h"

@interface WSKeyboardViewController ()<WSKeyboardHeaderViewDelegate, KeyboardEmojiViewDelegate>

@property (nonatomic, strong) WSKeyboardHeaderView *headerView;
@property (nonatomic, strong) WSKeyboardEmojiView *emojiView;
@property (nonatomic, strong) UIControl *bgView;
@property (nonatomic, strong) NSLayoutConstraint *constraint_Bottom_headerView;
@property (nonatomic, strong) NSLayoutConstraint *constraint_Bottom_emojiView;

@property (nonatomic, assign) CGFloat emojiViewHeight;

@end

@implementation WSKeyboardViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bgView];
    
    NSArray *constraint_H_headerView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_headerView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headerView)];
    NSLayoutConstraint *constraint_Height_headerView = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0f];
    self.constraint_Bottom_headerView = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:50.0f];
    
    NSArray *constraint_H_bgView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bgView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bgView)];
    NSLayoutConstraint *constraint_Top_bgView = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint_Bottom_bgView = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    [self.view addConstraints:constraint_H_headerView];
    [self.view addConstraint:constraint_Height_headerView];
    [self.view addConstraint:self.constraint_Bottom_headerView];
    [self.view addConstraints:constraint_H_bgView];
    [self.view addConstraint:constraint_Top_bgView];
    [self.view addConstraint:constraint_Bottom_bgView];
    
    //EmojiView
    [self.view addSubview:self.emojiView];
    
    NSArray *constraint_H_EmojiView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_emojiView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_emojiView)];
    NSLayoutConstraint *constraint_Height_EmojiView = [NSLayoutConstraint constraintWithItem:self.emojiView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5f constant:37.0f];
    self.emojiViewHeight = screenW/2 + 37.0f;
    self.constraint_Bottom_emojiView = [NSLayoutConstraint constraintWithItem:self.emojiView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.emojiViewHeight];
    [self.view addConstraints:constraint_H_EmojiView];
    [self.view addConstraint:constraint_Height_EmojiView];
    [self.view addConstraint:self.constraint_Bottom_emojiView];
    
    

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.headerView.textField.text = self.toName;
    [self.headerView.textField becomeFirstResponder];
}

- (void)showKeyboardInParentController:(UIViewController *)parentController {
    if (self.parentViewController == parentController) {
        return;
    }
    
    [self willMoveToParentViewController:parentController];
    [parentController addChildViewController:self];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [parentController.view addSubview:self.view];
    
    NSDictionary *layoutViews = @{@"view":self.view};
    NSArray *constraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:layoutViews];
    NSArray *constraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:layoutViews];
    [parentController.view addConstraints:constraints_H];
    [parentController.view addConstraints:constraints_V];
    

//    [self beginAppearanceTransition:YES animated:NO];
//    [self endAppearanceTransition];
//    [self.headerView.textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01f];
}

- (void)didTapBgView {
    if (self.headerView.textField.isFirstResponder) {
        [self.headerView.textField resignFirstResponder];
        self.constraint_Bottom_headerView.constant = 0;
        [self.view layoutIfNeeded];
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    } else {
        self.constraint_Bottom_headerView.constant = 0;
        self.constraint_Bottom_emojiView.constant = 0;
        [self.view layoutIfNeeded];
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    [self.delegate keyboardRemoveFromParentController];
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    self.constraint_Bottom_headerView.constant = -height;
    [self.view layoutIfNeeded];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {

}

#pragma mark - WSKeyboardHeaderViewDelegate

- (void)changeKeyboardEmojiState:(BOOL)isSelect {
    if (isSelect) {
        self.constraint_Bottom_emojiView.constant = 0;
        self.constraint_Bottom_headerView.constant = -self.emojiViewHeight;
        self.headerView.textField.placeholder = self.headerView.textField.text;
        self.headerView.textField.text = nil;
    } else {
        self.constraint_Bottom_emojiView.constant = self.emojiViewHeight;
        self.headerView.textField.text = self.headerView.textField.placeholder;
    }
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)submitKeyboardText:(NSString *)text {
    [self.delegate keyboardTextFieldResponed:text];
}

- (void)submitKeyboardEmojiName:(NSString *)emojiName {
    [self.delegate keyboardEmojiResponed:emojiName];
}

#pragma mark - init Views

- (WSKeyboardHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WSKeyboardHeaderView alloc] init];
        [_headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (WSKeyboardEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[WSKeyboardEmojiView alloc] init];
        _emojiView.delegate = self;
        [_emojiView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _emojiView;
}

- (UIControl *)bgView {
    if (!_bgView) {
        _bgView = [[UIControl alloc] init];
        [_bgView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _bgView.backgroundColor = [UIColor clearColor];
        [_bgView addTarget:self action:@selector(didTapBgView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
