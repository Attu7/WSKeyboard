//
//  WSKeyboardEmojiView.h
//  WSKeyboard
//
//  Created by Attu on 16/8/26.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardEmojiViewDelegate <NSObject>

- (void)submitKeyboardEmojiName:(NSString *)emojiName;

@end

@interface WSKeyboardEmojiView : UIView

@property (nonatomic, assign) id<KeyboardEmojiViewDelegate> delegate;

@end
