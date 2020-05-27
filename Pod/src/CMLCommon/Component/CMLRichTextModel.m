//
//  CMLRichTextModel.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/3/12.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLRichTextModel.h"
#import "UIColor+CMLExtends.h"

@implementation CMLRichTextModel

- (UIColor *)messageColor
{
    if (self.color_text.length > 0) {
        return [UIColor cml_colorWithString:self.color_text];
    } else if (self.color.length > 0) {
        return [UIColor cml_colorWithString:self.color];
    }
    return nil;
}

- (NSAttributedString *)attributeText {
    return [self configAttributeTextMustBold:NO defaultFont:nil];
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
        if ( defaultFont ) {
            [attributedString addAttribute:NSFontAttributeName
                                     value:defaultFont
                                     range:range];
        } else {
            if (self.font && self.font.integerValue > 0) {
                [attributedString addAttribute:NSFontAttributeName
                                         value:[UIFont systemFontOfSize:ceil(self.font.integerValue/2)]
                                         range:range];
            }
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
                        if (m.font_name && [m.font_name isEqualToString:@"dina"] && font_size > 0) {
                            UIFont *font = [UIFont fontWithName:@"DINAlternate-Bold" size:ceil(font_size / 2)];
                            [attributedString addAttribute:NSFontAttributeName value:font range:range];
                        } else if (font_size>0) {
                            UIFont *font = isBold ? [UIFont boldSystemFontOfSize:ceil(font_size/2)] : [UIFont systemFontOfSize:ceil(font_size/2)];
                            [attributedString addAttribute:NSFontAttributeName value:font range:range];
                        } else if (isBold && defaultFont != nil) {
                            UIFont *font = isBold ? [UIFont boldSystemFontOfSize:defaultFont.pointSize] : defaultFont;
                            [attributedString addAttribute:NSFontAttributeName value:font range:range];
                        }
                        
                        if (m.link_url.length > 0) {
                            [attributedString addAttribute:NSLinkAttributeName value:m.link_url?:@"" range:range];
                            if (m.richColor) {
                                [UITextView appearance].linkTextAttributes = @{NSForegroundColorAttributeName : m.richColor};
                            }
                        }
                        
                        if (m.bg_color.length) {
                            [attributedString setAttributes:@{NSBackgroundColorAttributeName:m.richBgColor} range:range];
                        }
                    }
                }
            }
        }
    }
    return attributedString;
}

@end

@implementation CMLRichMessageRegularApiModel

- (UIColor *)richColor
{
    if (self.color.length > 0) {
        return [UIColor cml_colorWithString:self.color];
    }
    return nil;
}


- (UIColor *)richBgColor
{
    if (self.bg_color.length > 0) {
       return [UIColor cml_colorWithString:self.bg_color];
    }
    return nil;
}

@end


