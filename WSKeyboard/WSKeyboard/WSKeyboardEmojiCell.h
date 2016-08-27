//
//  WSKeyboardEmojiCell.h
//  WSKeyboard
//
//  Created by Attu on 16/8/26.
//  Copyright © 2016年 Attu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYImage.h"

@interface WSKeyboardEmojiCell : UICollectionViewCell

@property (strong, nonatomic) YYAnimatedImageView *emojiImageView;

- (void)loadImageWithEmojiName:(NSString *)emojiName;

@end
