//
//  WSKeyboardHeaderView.m
//  WSKeyboard
//
//  Created by Attu on 16/8/25.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import "WSKeyboardHeaderView.h"

@interface WSKeyboardHeaderView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *inputView;

@end

@implementation WSKeyboardHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self addSubview:self.inputView];
        [self addSubview:self.sendButton];
        [self.inputView addSubview:self.textField];
        [self.inputView addSubview:self.emojiButton];
        
        NSArray *constraint_H_view = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_inputView]-8-[_sendButton(==60)]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_inputView, _sendButton)];
        NSArray *constraint_V_inputView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_inputView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_inputView)];
        NSArray *constraint_V_sendButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_sendButton]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendButton)];
        [self addConstraints:constraint_H_view];
        [self addConstraints:constraint_V_inputView];
        [self addConstraints:constraint_V_sendButton];
        
        NSArray *constraint_H_inputView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[_textField]-0-[_emojiButton(==30)]-4.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField, _emojiButton)];
        NSArray *constraint_V_textField = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField)];
        NSArray *constraint_V_emojiButton = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_emojiButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_emojiButton)];
        [self.inputView addConstraints:constraint_H_inputView];
        [self.inputView addConstraints:constraint_V_textField];
        [self.inputView addConstraints:constraint_V_emojiButton];
        

    }
    return self;
}

#pragma mark - Event

- (void)onClickEmojiButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.textField resignFirstResponder];
    } else {
        [self.textField becomeFirstResponder];
    }
    [self.delegate changeKeyboardEmojiState:sender.selected];
}

- (void)onClickSendButton:(UIButton *)sender {
    if ([self.textField.text length] == 0) {
        return;
    }
    [self.delegate submitKeyboardText:self.textField.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.emojiButton.selected) {
        self.emojiButton.selected = !self.emojiButton.selected;
        [self.delegate changeKeyboardEmojiState:NO];
    }
   
    return YES;
}

#pragma mark - InitViews

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _textField;
}

- (UIButton *)emojiButton {
    if (!_emojiButton) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_emojiButton setImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
        [_emojiButton setImage:[UIImage imageNamed:@"entrancelogger_tw"] forState:UIControlStateSelected];
        [_emojiButton addTarget:self action:@selector(onClickEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        _sendButton.backgroundColor = [UIColor colorWithRed:234/255.0f green:55/255.0f blue:140/255.0f alpha:1.0f];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _sendButton.layer.cornerRadius = 4.0f;
        _sendButton.layer.masksToBounds = YES;
        [_sendButton addTarget:self action:@selector(onClickSendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = [UIColor whiteColor];
        [_inputView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _inputView.layer.cornerRadius = 4.0f;
        _inputView.layer.masksToBounds = YES;
    }
    return _inputView;
}

@end
