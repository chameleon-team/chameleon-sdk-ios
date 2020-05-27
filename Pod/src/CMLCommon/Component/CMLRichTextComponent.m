//
//  CMLRichTextComponent.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/3/12.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLRichTextComponent.h"
#import "CMLRichTextModel.h"

@implementation CMLRichTextComponent

- (UILabel *)loadView {
    return [UILabel new];
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    if(self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        
    }
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes{
    
    if (attributes[@"richMessage"] && [attributes[@"richMessage"] isKindOfClass:[NSDictionary class]]) {

        NSError *error = nil;
        CMLRichTextModel *noteModel = [[CMLRichTextModel alloc] initWithDictionary:attributes[@"richMessage"] error:&error];
        if (!error) {
            ((UILabel *)(self.view)).attributedText = [noteModel attributeText];
        }
    }
}

@end
