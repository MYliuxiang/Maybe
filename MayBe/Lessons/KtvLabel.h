//
//  KtvLabel.h
//  demo
//
//  Created by liuxiang on 2020/7/30.
//  Copyright © 2020 liuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KtvLabel : UILabel

@property (strong, nonatomic) NSTextStorage *textStorage;

@property (strong, nonatomic) NSLayoutManager *layoutManager;

@property (strong, nonatomic) NSTextContainer *textContainer;

@property (strong, nonatomic) UIView *flagView;

@property (assign, nonatomic) NSInteger tag;

- (CGRect)characterRectAtIndex:(NSUInteger)charIndex;

@end

NS_ASSUME_NONNULL_END
