//
//  CMLUtility.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/24.
//  Copyright © 2018年 Chameleon-Team. All rights reserved.
//

#import "CMLUtility.h"
#import "CMLReachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

UIViewController *CMLRootViewController()
{
    id<UIApplicationDelegate> delegate= [UIApplication sharedApplication].delegate;
    if([delegate respondsToSelector:@selector(window)]){
        UIWindow *window = [(NSObject *)delegate valueForKey:@"window"];
        UIViewController *controller = window.rootViewController;
        while (controller.presentedViewController) {
            controller = controller.presentedViewController;
        }
        return controller;
    }
    return nil;
}

id _CMLObjectFromJSON(NSString *json)
{
    if(!json) return nil;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if(data){
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers | NSJSONReadingMutableContainers error:&error];
        if(error){
           return nil;
        }
        return object;
    }
    
    return nil;
}
NSString *_CMLJSONStringWithObject(id object)
{
    if([NSJSONSerialization isValidJSONObject:object]){
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
        if(error || !data){
            return nil;
        }
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

NSString *_CMLBase64DataEncode(NSData *input)
{
    if(input){
        return [input base64EncodedStringWithOptions:0];
    }
    return nil;
}

@implementation CMLUtility

+ (NSDictionary *)getEnvironment
{
    NSString *platform = [@"iOS" lowercaseString];
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion] ?: @"";
    CGFloat deviceWidth = [self portraitScreenSize].width;
    CGFloat deviceHeight = [self portraitScreenSize].height;
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:platform forKey:@"os"];
    [data setObject:sysVersion forKey:@"osVersion"];
    [data setObject:@(deviceWidth * scale) forKey:@"deviceWidth"];
    [data setObject:@(deviceHeight * scale) forKey:@"deviceHeight"];
    [data setObject:@(scale) forKey:@"scale"];
    
    NSMutableDictionary *extraParams = [NSMutableDictionary dictionary];
    [extraParams setObject:[CMLUtility uuidString] forKey:@"imei"];
    [extraParams setObject:[CMLUtility registeredDeviceName] forKey:@"model"];
    [extraParams setObject:[CMLUtility getNetconnType] forKey:@"netType"];
   
    [data setObject:extraParams forKey:@"extraParams"];

    return data;
}

+ (CGSize)portraitScreenSize
    {
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            return [UIScreen mainScreen].bounds.size;
        }
        static CGSize portraitScreenSize;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            portraitScreenSize = CGSizeMake(MIN(screenSize.width, screenSize.height),
                                            MAX(screenSize.width, screenSize.height));
        });
        
        return portraitScreenSize;
}

+ (NSString *)uuidString
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef= CFUUIDCreateString(NULL, uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
    CFRelease(uuidRef);
    CFRelease(uuidStringRef);
    
    return [uuid lowercaseString];
}

+ (NSString *)registeredDeviceName
{
    NSString *machine = [[UIDevice currentDevice] model];
    NSString *systemVer = [[UIDevice currentDevice] systemVersion] ? : @"";
    NSString *model = [NSString stringWithFormat:@"%@:%@",machine,systemVer];
    return model;
}

+ (NSString *)getNetconnType{
    
    NSString *netconnType = @"";
    
    CMLReachability *reach = [CMLReachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
            
            netconnType = @"no network";
        }
            break;
            
        case ReachableViaWiFi:{
            netconnType = @"Wifi";
        }
            break;
            
        case ReachableViaWWAN:
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

@end


