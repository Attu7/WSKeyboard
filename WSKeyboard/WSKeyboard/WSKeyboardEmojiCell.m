//
//  WSKeyboardEmojiCell.m
//  WSKeyboard
//
//  Created by Attu on 16/8/26.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import "WSKeyboardEmojiCell.h"

@implementation WSKeyboardEmojiCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.emojiImageView];
        NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_emojiImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_emojiImageView)];
        NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_emojiImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_emojiImageView)];
        [self.contentView addConstraints:constraint_H];
        [self.contentView addConstraints:constraint_V];
    }
    return self;
}

- (void)loadImageWithEmojiName:(NSString *)emojiName {
    YYImage *image = [YYImage imageNamed:[NSString stringWithFormat:@"%@.gif", emojiName]];
    [self.emojiImageView setImage:image];
    
    [self updateConstraints];
    [self layoutSubviews];
}

- (YYAnimatedImageView *)emojiImageView {
    if (!_emojiImageView) {
        _emojiImageView = [[YYAnimatedImageView alloc] init];
        _emojiImageView.backgroundColor = [UIColor clearColor];
        _emojiImageView.image = [UIImage imageNamed:@"effect2"];
        [_emojiImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _emojiImageView;
}

@end
