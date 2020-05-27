//
//  CMLRichTextModel.h
//  Chameleon
//
//  Created by Chameleon-Team on 2019/3/12.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "JSONModel.h"

@protocol CMLRichMessageRegularApiModel @end;

@interface CMLRichTextModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *message;          ///< 文本
@property (nonatomic, copy) NSString<Optional> *icon_url;         ///< 图片uri
@property (nonatomic, copy) NSString<Optional> *background_color; ///< 背景色
@property (nonatomic, copy) NSString<Optional> *border_corner;    ///< 边框角度（单位pt）
@property (nonatomic, copy) NSString<Optional> *border_color;     ///< 边框颜色（单位pt）
@property (nonatomic, copy) NSString<Optional> *border_width;     ///< 边框宽度（单位pt）
@property (nonatomic, copy) NSString<Optional> *color_text;       ///< 文本颜色（16进制文本）
@property (nonatomic, copy) NSNumber<Optional> *font;             ///< 文本字体（单位px）
@property (nonatomic, copy) NSString<Optional> *bold;             ///< 是否粗体（0 or 1）
@property (nonatomic, copy) NSString<Optional> *msg_url;          ///< 富文本点击事件
@property (nonatomic, copy) NSString<Optional> *color;            ///< 富文本点击事件

///< 描述message具体富文本样式
@property (nonatomic, copy) NSArray <Optional, CMLRichMessageRegularApiModel> *rich_message;

- (NSAttributedString *)attributeText;

@end

@interface CMLRichMessageRegularApiModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *text;       ///< 描述的具体文本
@property (nonatomic, copy) NSString<Optional> *font_size;  ///< 描述文本的字体 (单位px)
@property (nonatomic, copy) NSString<Optional> *start;      ///< 描述文本的起点 (从0开始)
@property (nonatomic, copy) NSString<Optional> *end;        ///< 描述文本的终点 (end 不能超过 length - 1)
@property (nonatomic, copy) NSString<Optional> *color;      ///< 描述文本的颜色 (16进制文本)
@property (nonatomic, copy) NSString<Optional> *bold;       ///< 是否粗体（0 or 1）
@property (nonatomic, copy) NSString<Optional> *font_name;  ///< 是否使用特殊字体
@property (nonatomic, copy) NSString<Optional> *bg_color;   ///< 背景色
@property (nonatomic, copy) NSString<Optional> *link_url;      ///< 文案跳转 url


- (UIColor *)richColor;
- (UIColor *)richBgColor;
@end

