//
//  TTTAttributedLabel+DCWeex.m
//  CarpoolBusiness
//
//  Created by Lux on 2020/4/29.
//

#import "TTTAttributedLabel+DCWeex.h"
///< Router
//#import "DCURLSchemeMgr.h"
///<
#import "CMLNoteInfoModel.h"
#import "NSDictionary+CMLExtends.h"
#import "NSArray+CMLExtends.h"
#import "UIColor+CMLExtends.h"

@implementation TTTAttributedLabel (DCWeex)

- (void)setDCNoteInfo:(CMLNoteInfoModel *)model {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:model.attributeText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.attributeText.string length])];
    self.attributedText = attributedString;
    
//    self.attributedText = model.attributeText;
    self.extendsLinkTouchArea = NO;
    
    ///< 配置点击信息
    NSArray *list = model.rich_message;
    for (int i = 0; i < list.count; i++){
        CMLRichMessageRegularApiModel *item = [list cml_objectAtIndex:i];
        if(item){
            NSString *text = item.text;
            int start = item.start.intValue;
            int end = item.end.intValue;
            if (start < 0) {
                start = 0;
            }
            if (end < 0) {
                end = 0;
            }
            if (end + 1 > model.message.length) {
                end = MAX((int)text.length - 1, 0);
            }
            //swap(start, end)
            if (end < start) {
                end = end ^ start;
                start ^= end;
                end ^= start;
            }
            
            NSRange range = {start, end - start + 1};
            
            //链接形式
            NSString *linkUri = item.link_url;
            NSNumber *click = item.click;
            BOOL canClick = [click boolValue];
            
            if(end > model.message.length - 1) {
                return;
            }
            
            if ((linkUri && linkUri.length > 0) || canClick) {
                ///< 由于传入的 Model 不做持有，所以链接转交给 link 持有
                NSURL *url = [NSURL URLWithString:linkUri];
                NSTextCheckingResult *result = [NSTextCheckingResult linkCheckingResultWithRange:range URL:url];
                
                NSMutableDictionary *attrDict = [[NSMutableDictionary alloc] initWithDictionary:[item toDictionary]];
                [attrDict cml_setInt:i forKey:@"index"];
        
                NSDictionary *normalStyle = [self p_normalAttributesWithColor:[UIColor cml_colorWithHexString:item.color]];
                
                
                TTTAttributedLabelLink *link = [[TTTAttributedLabelLink alloc] initWithAttributes:normalStyle activeAttributes:normalStyle inactiveAttributes:attrDict textCheckingResult:result];
                
                //            [self addLinkWithTextCheckingResult:result];
                __weak typeof(self) weakSelf = self;
                [link setLinkTapBlock:^(TTTAttributedLabel *oneLabel, TTTAttributedLabelLink *oneLink) {

                    NSDictionary *attrDict = oneLink.inactiveAttributes;
                    NSString *click = [attrDict valueForKey:@"click"];
                    if(click.intValue == 1){
                        [weakSelf.delegate attributedLabel:oneLabel didSelectLinkWithAddress:oneLink.inactiveAttributes];
                    } else {
//                        [[DCURLSchemeMgr sharedInstance] callInsideURL:oneLink.result.URL];
                    }
                }];
                [self addLink:link];
            }
        }
    }
}

- (NSDictionary *)p_normalAttributesWithColor:(UIColor *)color {
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes cml_setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    if ([NSMutableParagraphStyle class]) {
        [mutableLinkAttributes cml_setValue:color forKey:(NSString *)kCTForegroundColorAttributeName];
    } else {
        [mutableLinkAttributes cml_setValue:(__bridge id)[color CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    }
    return mutableLinkAttributes.copy;
}

@end
