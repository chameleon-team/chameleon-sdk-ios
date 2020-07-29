//
//  DCNoteInfoModel.h
//  DiCarpool
//
//  Created by Tiger Xia on 7/20/15.
//  Copyright (c) 2015 DiDi. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@protocol CMLRichMessageRegularApiModel @end;
@protocol DCNoteInfoModel @end;

@interface CMLNoteInfoModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *message;          ///< 文本
@property (nonatomic, copy) NSString<Optional> *icon_url;         ///< 图片uri
@property (nonatomic, copy) UIImage <Ignore>   *image;            ///< Image 对象
@property (nonatomic, copy) NSString<Optional> *background_color; ///< 背景色
@property (nonatomic, copy) NSString<Optional> *background_color_begin; ///< 渐变背景色起点颜色
@property (nonatomic, copy) NSString<Optional> *background_color_end; ///< 渐变背景色终点颜色
@property (nonatomic, copy) NSString<Optional> *background_color_angle; ///< 渐变背景色角度
@property (nonatomic, copy) NSString<Optional> *border_corner;    ///< 边框角度（单位pt）
@property (nonatomic, copy) NSString<Optional> *border_color;     ///< 边框颜色（单位pt）
@property (nonatomic, copy) NSString<Optional> *border_width;     ///< 边框宽度（单位pt）
@property (nonatomic, copy) NSString<Optional> *border_top_padding; ///< 文本距边框上下间距
@property (nonatomic, copy) NSString<Optional> *border_left_padding; ///< 文本距边框左右间距
@property (nonatomic, copy) NSString<Optional> *color_text;       ///< 文本颜色（16进制文本）
@property (nonatomic, copy) NSNumber<Optional> *font;             ///< 文本字体（单位px）
@property (nonatomic, copy) NSString<Optional> *bold;             ///< 是否粗体（0 or 1）
@property (nonatomic, copy) NSString<Optional> *msg_url;          ///< 富文本点击事件
@property (nonatomic, copy) NSString<Optional> *color;            ///< 文字颜色
@property (nonatomic, copy) NSString<Optional> *mk_id;            ///< 如果作为运营展示会下发，运营标识
@property (nonatomic, copy) NSString<Optional> *channel_id;       ///< 如果作为运营展示会下发，运营位号
@property (nonatomic, copy) NSString<Optional> *size;             ///< 文本字号
@property (nonatomic, copy) NSString<Optional> *fixed_size_width; ///< 可以指定一个固定尺寸, 和fixed_size_height同时使用, 控制图片大小
@property (nonatomic, copy) NSString<Optional> *fixed_size_height;///< 可以指定一个固定尺寸, 和fixed_size_width同时使用, 控制图片大小
@property (nonatomic, copy) NSString<Optional> *text_align;       ///< 文本排版（居中/居左/居右）

///< 描述message具体富文本样式
@property (nonatomic, copy) NSArray <Optional, CMLRichMessageRegularApiModel> *rich_message;

///< 文字图片一起时 是否图片在右边 default is NO 图片在左边. 判断是否为 @"1"
@property (nonatomic, copy) NSString<Optional> *is_icon_right;

- (BOOL)isVaild;
- (UIColor *)messageColor;
- (NSAttributedString *)attributeText;
- (NSAttributedString *)boldAttributeText;

/**
 获取富文本，内部生成的是 [UIFont systemFontOfSize:]，而且会覆盖 label 上设置的属性，如果要使用自定义的字体参加下面的方法 attributedStringForMessage:font:color

 @param fontSize  如果存在黑体设置，需要默认字体大小
 @return 返回富文本
 */
- (NSAttributedString *)attributeTextWithDefaultSize:(CGFloat)fontSize;

/**
 获取富文本，内部生成的是 [UIFont boldSystemFontOfSize:]，而且会覆盖 label 上设置的属性，如果要使用自定义的字体参加下面的方法 attributedStringForMessage:font:color
 
 @param fontSize  字体大小
 @return 返回富文本
 */
- (NSAttributedString *)attributeTextWithDefaultBoldSize:(CGFloat)fontSize;

/**
 获取带有默认字体的富文本（优先默认字体字号，不会用api的字号）
 @param defaultFont 默认字体
 @return 返回富文本
*/
- (NSAttributedString *)attributeTextWithDefaultFont:(UIFont *)defaultFont;

/**
 生成富文本

 @param font 传入UIFont，可自定义字体
 @param lineSpacing 自定义行间距
 @param mode 截断模式。注：NSAttributedString如果设置了ParagraphStyle，UILabel会以ParagraphStyle的lineBreakMode代替UILabel的lineBreakMode属性值。
 
 @return 返回富文本
 */
- (NSAttributedString *)attributeTextWithFont:(UIFont *)font
                                  lineSpacing:(CGFloat)lineSpacing
                                lineBreakMode:(NSLineBreakMode)mode;

/**
 生成富文本，可以传入自定义的字体
 e.g. : [DCNoteInfoModel attributedStringForMessage:actionModel.title font:[UIFont fontWithName:@"DINAlternate-Bold" size:26] defaultColor:[UIColor blackColor]];

 @param font 自定义字体的名字
 @return 返回富文本
 */
+ (NSAttributedString *)attributedStringForMessage:(CMLNoteInfoModel *)richMessage
                                              font:(UIFont *)font
                                      defaultColor:(UIColor *)color;

@end

@interface CMLRichMessageRegularApiModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *text;       ///< 描述的具体文本
@property (nonatomic, copy) NSString<Optional> *font_size;  ///< 描述文本的字体 (单位px)
@property (nonatomic, copy) NSString<Optional> *start;      ///< 描述文本的起点 (从0开始)
@property (nonatomic, copy) NSString<Optional> *end;        ///< 描述文本的终点 (end 不能超过 length - 1)
@property (nonatomic, copy) NSString<Optional> *color;      ///< 描述文本的颜色 (16进制文本)
@property (nonatomic, copy) NSString<Optional> *bold;       ///< 是否粗体（0 or 1）
@property (nonatomic, copy) NSString<Optional> *font_name;  ///< 是否使用特殊字体: http://wiki.intra.xiaojukeji.com/pages/viewpage.action?pageId=142601763
@property (nonatomic, copy) NSString<Optional> *bg_color;   ///< 背景色  http://wiki.intra.xiaojukeji.com/pages/viewpage.action?pageId=156928578
@property (nonatomic, copy) NSString<Optional> *link_url;      ///< 文案跳转 url
@property (nonatomic, copy) NSString<Optional> *word_space;  ///< 字间距
@property (nonatomic, strong) NSNumber <Optional> *click;     ///是否支持点击
@property (nonatomic, strong) NSDictionary <Optional> *callback;  ///点击回调

- (UIColor *)richColor;
- (UIColor *)richBgColor;
@end
