//
//  CMLStorageModule.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/3.
//

#import "CMLStorageModule.h"
#import "CMLUtility.h"
#import "CMLConstants.h"

@implementation CMLStorageModule
@synthesize cmlInstance;

CML_EXPORT_METHOD(@selector(setStorage:callBack:))
CML_EXPORT_METHOD(@selector(getStorage:callBack:))
CML_EXPORT_METHOD(@selector(removeStorage:callBack:))

- (void)setStorage:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback {
    
    NSString *key = parms[@"key"];
    NSString *value = parms[@"value"];
    if (!key || key.length <= 0 || !value || value.length <=0) {
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:value forKey:key];
    [ud synchronize];
    
    if (callback) {
        NSDictionary *result = @{@"errno": @"0", @"msg": @""};
        if(callback) callback(result);
    }
}

- (void)getStorage:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback {
    
    NSString *key = parms[@"key"];
    if (!key || key.length <= 0) {
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * value = [ud valueForKey:key];
    NSDictionary *result = @{@"errno": @"0", @"data":value?value:@"", @"msg": @"" };
    if (callback) {
        callback(result);
    }
}

- (void)removeStorage:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback {
    
    NSString *key = parms[@"key"];
    if (!key || key.length <= 0) {
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
    NSDictionary *result = @{@"errno": @"0", @"msg": @"" };
    if (callback) {
        callback(result);
    }
}

@end
