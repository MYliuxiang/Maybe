//
//  KtvLabel.m
//  demo
//
//  Created by liuxiang on 2020/7/30.
//  Copyright © 2020 liuxiang. All rights reserved.
//

#import "KtvLabel.h"

@implementation KtvLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.textStorage = [NSTextStorage new];
    self.layoutManager = [NSLayoutManager new];
    self.textContainer = [NSTextContainer new];
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    
    
    [self sizeToFit];
    self.tag = 0;
    
    
    self.flagView = [UIView new];
    
    self.flagView.frame = CGRectZero;
    
    self.flagView.layer.borderColor = [UIColor redColor].CGColor;
    
    self.flagView.layer.borderWidth = 1.f;
    
    self.flagView.clipsToBounds = YES;
    
    [self addSubview:self.flagView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self configWithLabel:self];

}


- (void)setText:(NSString *)text
{
    [super setText:text];
    [self configWithLabel:self];
}


- (void)configWithLabel:(UILabel *)label

{

    self.textContainer.size = label.bounds.size;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = label.numberOfLines;
    self.textContainer.lineBreakMode = label.lineBreakMode;


    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSRange textRange = NSMakeRange(0, attributedText.length);
    [attributedText addAttribute:NSFontAttributeName value:label.font range:textRange];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = label.textAlignment;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];
    [self.textStorage setAttributedString:attributedText];

}



- (CGRect)characterRectAtIndex:(NSUInteger)charIndex

{

    //传回self.layoutManager的位置 实际就是字符的fram

    if (charIndex >= self.textStorage.length) {

        return CGRectZero;

    }
    
   

    NSRange characterRange = NSMakeRange(charIndex, 1);

    NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:characterRange actualCharacterRange:nil];

    return [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];

}

@end
