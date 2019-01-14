//
//  CMLClipboardModule.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/3.
//

#import "CMLClipboardModule.h"
#import "CMLUtility.h"
#import "CMLConstants.h"


@implementation CMLClipboardModule
@synthesize cmlInstance;

CML_EXPORT_METHOD(@selector(setClipBoardData:callBack:))
CML_EXPORT_METHOD(@selector(getClipBoardData:callBack:))

- (void)setClipBoardData:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback {
    
    NSString *data = parms[@"data"];
    if (!data || data.length <= 0) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = data;
   
    if (callback) {
        NSDictionary *result = @{@"errno": @"0", @"msg": @""};
        if(callback) callback(result);
    }
}

- (void)getClipBoardData:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSDictionary *result = @{@"errno": @"0", @"data":pasteboard.string?pasteboard.string:@"", @"msg": @""};
    if (callback) {
        callback(result);
    }
}

@end
