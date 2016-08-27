//
//  ViewController.m
//  WSKeyboard
//
//  Created by Attu on 16/8/25.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import "ViewController.h"
#import "WSKeyboardHeaderView.h"
#import "WSKeyboardViewController.h"

@interface ViewController ()<UITextFieldDelegate, WSKeyboardDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet WSKeyboardHeaderView *keyboard;

@property (nonatomic, strong) WSKeyboardViewController *keyboardVC;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)keyboardTextFieldResponed:(NSString *)text {
    NSLog(@"textField -- %@", text);
}

- (void)keyboardEmojiResponed:(NSString *)emojiName {
    NSLog(@"emoji -----   %@", emojiName);
}

- (void)keyboardRemoveFromParentController {
    self.keyboardVC = nil;
}

- (IBAction)onClickShow:(UIButton *)sender {
    self.keyboardVC = [[WSKeyboardViewController alloc] init];
    self.keyboardVC.delegate = self;
    self.keyboardVC.toName = @"@王宝强";
    [self.keyboardVC showKeyboardInParentController:self];
}

- (IBAction)onClickHide:(UIButton *)sender {
    NSLog(@"%@", self.keyboardVC);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
