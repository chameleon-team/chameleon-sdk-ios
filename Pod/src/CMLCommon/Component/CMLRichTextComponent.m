//
//  CMLRichTextComponent.m
//  CarpoolBlord
//
//  Created by mxf on 2018/9/27.
//
#import "CMLRichTextComponent.h"
#import "CMLNoteInfoModel.h"
#import "TTTAttributedLabel+DCWeex.h"

@interface CMLRichTextComponent() <TTTAttributedLabelDelegate>
@end

@implementation CMLRichTextComponent

- (UIView *)loadView {
    TTTAttributedLabel *label = [TTTAttributedLabel new];
    label.delegate = self;
    return label;
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    if(self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
    }
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes{
    
    if (attributes[@"richMessage"] && [attributes[@"richMessage"] isKindOfClass:[NSDictionary class]]) {
        
        NSError *error = nil;
        CMLNoteInfoModel *noteModel = [[CMLNoteInfoModel alloc] initWithDictionary:attributes[@"richMessage"] error:&error];
        if (!error) {
            ((UILabel *)(self.view)).attributedText = [noteModel attributeTextWithFont:nil lineSpacing:2 lineBreakMode:NSLineBreakByWordWrapping];
            TTTAttributedLabel *label = (TTTAttributedLabel *)(self.view);
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:14];
            [label setDCNoteInfo:noteModel];
            CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
            label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            if([noteModel.text_align isEqualToString:@"left"]){
                label.textAlignment = NSTextAlignmentLeft;
            }
            if([noteModel.text_align isEqualToString:@"right"]){
                label.textAlignment = NSTextAlignmentRight;
            }
            if([noteModel.text_align isEqualToString:@"center"]){
                label.textAlignment = NSTextAlignmentCenter;
            }
            
            [self fireEvent:@"layoutRichText" params:@{@"height":[NSString stringWithFormat:@"%f",label.frame.size.height]} domChanges:nil];
            //            NSMutableDictionary *stylesDict = [NSMutableDictionary new];
            //            [stylesDict one_setFloat:label1.size.height*2 forKey:@"height"];
            //            [stylesDict one_setFloat:label1.size.width*2 forKey:@"width"];
            //            [self updateLayoutStyles:stylesDict];
            //            [self setNeedsLayout];
        }
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents{
    NSNumber *index = [addressComponents objectForKey:@"index"];
    [self fireEvent:@"richTextClick" params:@{@"index":index} domChanges:nil];
}
@end
