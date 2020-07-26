//
//  DCNoteInfoModel.m
//  DiCarpool
//
//  Created by Tiger Xia on 7/20/15.
//  Copyright (c) 2015 DiDi. All rights reserved.
//

#import "CMLNoteInfoModel.h"
#import "UIColor+CMLExtends.h"

@implementation CMLNoteInfoModel

- (UIColor *)messageColor
{
    if (self.color_text.length > 0) {
        return [UIColor cml_colorWithHexString:self.color_text];
    } else if (self.color.length > 0) {
        return [UIColor cml_colorWithHexString:self.color];
    }
    return nil;
}

- (BOOL)isVaild {
    if (self.message.length > 0) {
        return YES;
    }
    return NO;
}

- (NSAttributedString *)boldAttributeText {
    return [self configAttributeTextMustBold:YES defaultFont:nil];
}

- (NSAttributedString *)attributeText {
    BOOL isBold = self.bold && self.bold.boolValue;
    if ( isBold ) {
        return [self boldAttributeText];
    } else {
        return [self configAttributeTextMustBold:NO defaultFont:nil];
    }
}

- (NSAttributedString *)attributeTextWithDefaultSize:(CGFloat)fontSize {
    // 优先取外部传入的fontSize，没有的话取api下发的
    UIFont *defaultFont = fontSize > 0 ? [UIFont systemFontOfSize:fontSize] : nil;
    return [self configAttributeTextMustBold:NO defaultFont:defaultFont];
}

- (NSAttributedString *)attributeTextWithDefaultBoldSize:(CGFloat)fontSize {
    // 优先取外部传入的fontSize，没有的话取api下发的
    UIFont *defaultFont = fontSize > 0 ? [UIFont boldSystemFontOfSize:fontSize] : nil;
    return [self configAttributeTextMustBold:NO defaultFont:defaultFont];
}

- (NSAttributedString *)attributeTextWithDefaultFont:(UIFont *)defaultFont {
    return [self configAttributeTextMustBold:NO defaultFont:defaultFont];
}

- (NSAttributedString *)attributeTextWithFont:(UIFont *)font
                                  lineSpacing:(CGFloat)lineSpacing
                                lineBreakMode:(NSLineBreakMode)mode {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:[self configAttributeTextMustBold:NO defaultFont:font]];
    if (lineSpacing > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpacing;
        paragraphStyle.lineBreakMode = mode;
        [attString addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, attString.length)];
    }
    return attString;
}

- (NSAttributedString *)configAttributeTextMustBold:(BOOL)isBold defaultFont:(UIFont *)defaultFont {
    NSMutableAttributedString *attributedString = nil;
    if (self.message.length>0) {
        NSRange range = NSMakeRange(0, self.message.length);
        attributedString = [[NSMutableAttributedString alloc] initWithString:self.message];
        if (self.color_text.length > 0 || self.color.length > 0) {
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:self.messageColor
                                     range:range];
        }
        //设置全本文的字号
        UIFont *attFont = nil;
        if (defaultFont) {
            //优先取外部传入的默认字体
            attFont = defaultFont;
        }else if (self.font.integerValue > 0) {
            attFont = isBold ? [UIFont boldSystemFontOfSize:self.font.integerValue/2] : [UIFont systemFontOfSize:self.font.integerValue/2];
        }
        if (attFont) {
            [attributedString addAttribute:NSFontAttributeName
                                     value:attFont
                                     range:range];
        }
        if (self.rich_message.count>0) {
            for (CMLRichMessageRegularApiModel *m in self.rich_message) {
                int start = m.start.intValue;
                int length = m.end.intValue - m.start.intValue + 1;
                if (start >= 0 && length > 0) {
                    NSRange range = NSMakeRange(start,length);
                    if ((range.location+range.length)<=attributedString.length) {
                        if (m.richColor) {
                            [attributedString addAttribute:NSForegroundColorAttributeName value:m.richColor range:range];
                        }
                        int font_size = [m.font_size intValue];
                        isBold = [m.bold boolValue];
                        if (m.font_name && [m.font_name isEqualToString:@"dina"] && font_size > 0) { // 独立端特殊字体
                            UIFont *font = [UIFont fontWithName:@"DINAlternate-Bold" size:ceil(font_size / 2)];
                            [attributedString addAttribute:NSFontAttributeName value:font range:range];
                        } else if (m.font_name && [m.font_name isEqualToString:@"avnext"] && font_size > 0) { // 特殊数字字体
                            UIFont *font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:ceil(font_size / 2)];
                            [attributedString addAttribute:NSFontAttributeName value:font range:range];
                        } else if (font_size>0) {
                            UIFont *font = isBold ? [UIFont boldSystemFontOfSize:ceil(font_size/2)] : [UIFont systemFontOfSize:ceil(font_size/2)];
                            [attributedString addAttribute:NSFontAttributeName value:font range:range];
                        } else if (isBold && defaultFont != nil) {
                            UIFont *font = isBold ? [UIFont boldSystemFontOfSize:defaultFont.pointSize] : defaultFont;
                            [attributedString addAttribute:NSFontAttributeName value:font range:range];
                        } else if (isBold && self.font != nil) {
                            UIFont *font = [UIFont boldSystemFontOfSize:self.font.integerValue/2];
                            [attributedString addAttribute:NSFontAttributeName value:font range:range];
                        }
                        
                        if (m.link_url.length > 0) {
                            [attributedString addAttribute:NSLinkAttributeName value:m.link_url?:@"" range:range];
                            if (m.richColor) {
                                [UITextView appearance].linkTextAttributes = @{NSForegroundColorAttributeName : m.richColor};
                            }
                        }
                        
                        if (m.bg_color.length) {
                            [attributedString addAttributes:@{NSBackgroundColorAttributeName:m.richBgColor} range:range];
                        }
                        
                        if (m.word_space.length) {
                            NSNumber *space = [NSNumber numberWithFloat:[m.word_space floatValue]];
                            [attributedString addAttributes:@{NSKernAttributeName : space} range:range];
                        }
                        
                    }
                }
            }
        }
    }
    return attributedString;
}

+ (NSAttributedString *)attributedStringForMessage:(CMLNoteInfoModel *)richMessage font:(UIFont *)font defaultColor:(UIColor *)color  {
    NSArray *richModel = richMessage.rich_message;
    NSString *message = richMessage.message;
    NSMutableAttributedString *attString = nil;
    if ([message isKindOfClass:[NSString class]] && message.length > 0) {
        attString = [[NSMutableAttributedString alloc] initWithString:message];
        if ( color ) {
            [attString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attString.length)];
        }
        if ( font ) {
            [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attString.length)];
        }
        if (richModel.count > 0) {
            for (CMLRichMessageRegularApiModel *m in richModel) {
                if ([m.start integerValue] < [m.end integerValue] && [m.end integerValue] < attString.length) {
                    NSRange range = NSMakeRange(m.start.intValue, (m.end.intValue - m.start.intValue + 1));
                    if ( m.richColor ) {
                        [attString addAttribute:NSForegroundColorAttributeName value:m.richColor range:range];
                    }
                }
            }
        }
    }
    return attString;
}

@end


@implementation CMLRichMessageRegularApiModel

- (UIColor *)richColor
{
    if (self.color.length > 0) {
        return [UIColor cml_colorWithHexString:self.color];
    }
    return nil;
}


- (UIColor *)richBgColor
{
    if (self.bg_color.length > 0) {
        return [UIColor cml_colorWithHexString:self.bg_color];
    }
    return nil;
}

@end
