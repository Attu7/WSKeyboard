//
//  WSKeyboardViewController.h
//  WSKeyboard
//
//  Created by Attu on 16/8/26.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSKeyboardDelegate <NSObject>

- (void)keyboardTextFieldResponed:(NSString *)text;

- (void)keyboardEmojiResponed:(NSString *)emojiName;

- (void)keyboardRemoveFromParentController;

@end

@interface WSKeyboardViewController : UIViewController

@property (nonatomic, strong) NSString *toName;

@property (nonatomic, assign) id<WSKeyboardDelegate> delegate;

- (void)showKeyboardInParentController:(UIViewController *)parentController;

@end
