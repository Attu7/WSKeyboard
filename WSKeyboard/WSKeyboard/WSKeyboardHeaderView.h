//
//  WSKeyboardHeaderView.h
//  WSKeyboard
//
//  Created by Attu on 16/8/25.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WSKeyboardHeaderViewDelegate <NSObject>

- (void)changeKeyboardEmojiState:(BOOL)isSelect;

- (void)submitKeyboardText:(NSString *)text;

@end

@interface WSKeyboardHeaderView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) id<WSKeyboardHeaderViewDelegate> delegate;

@end
