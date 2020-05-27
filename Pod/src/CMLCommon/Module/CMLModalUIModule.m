//
//  CMLModalUIModule.m
//  Chameleon
//
//  Created by Chameleon-Team on 2019/1/3.
//

#import "CMLModalUIModule.h"
#import "CMLWeexRenderPage.h"
#import "CMLUtility.h"
#import "CMLConstants.h"
#import "UIView+Toast.h"
#if __has_include("MBProgressHUD.h")
#import "MBProgressHUD.h"
#endif

@implementation CMLModalUIModule
@synthesize cmlInstance;

CML_EXPORT_METHOD(@selector(showToast:callBack:))
CML_EXPORT_METHOD(@selector(alert:callBack:))
CML_EXPORT_METHOD(@selector(confirm:callBack:))

CML_EXPORT_METHOD(@selector(showLoading:callBack:))
CML_EXPORT_METHOD(@selector(hideLoading:callBack:))


- (void)showToast:(NSDictionary *)param callBack:(CMLMoudleCallBack)callback {
    
    if ([param[@"message"] isKindOfClass:[NSString class]]) {
        
        NSString *message = param[@"message"];
        double duration = [param[@"duration"] doubleValue]/1000;
        if (duration == 0) {
            duration = 2;
        }
        if (!message || message.length <= 0) {
            return;
        }
        [CMLRootViewController().view makeToast:message duration:duration position:CSToastPositionCenter];
        if (callback) {
            NSDictionary *result = @{@"errno": @"0",@"msg": @""};
            if(callback) callback(result);
        }
        return;
        
    }else if ([param[@"message"] isKindOfClass:[NSDictionary class]]){
        NSString *message = _CMLJSONStringWithObject(param[@"message"]);
       
        double duration = [param[@"duration"] doubleValue]/1000;
        if (duration == 0) {
            duration = 2;
        }
        
        if (!message|| message.length <= 0) {
            return;
        }
        [CMLRootViewController().view makeToast:message duration:duration position:CSToastPositionCenter];
        
        if (callback) {
            NSDictionary *result = @{@"errno": @"0",@"msg": @""};
            if(callback) callback(result);
        }
        return;
    }
}
- (void)alert:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback {
    
    if (!parms) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:parms[@"message"]?:@"" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:([UIAlertAction actionWithTitle:parms[@"confirmTitle"]?parms[@"confirmTitle"]:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *result = @{@"errno":@"0", @"msg":@""};
        if (callback) {
            callback(result);
        }
        
    }])];
    [CMLRootViewController() presentViewController:alertController animated:YES completion:nil];
}

- (void)confirm:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback {
    
    if (!parms) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:parms[@"message"]?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:parms[@"cancelTitle"]?parms[@"cancelTitle"]:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
           NSDictionary *result = @{@"errno": @"0", @"data":parms[@"cancelTitle"]?parms[@"cancelTitle"]:@"", @"msg": @"" };
                if (callback) {
                    callback(result);
                }
        }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:parms[@"confirmTitle"]?parms[@"confirmTitle"]:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         NSDictionary *result = @{@"errno": @"0", @"data":parms[@"confirmTitle"]?parms[@"confirmTitle"]:@"", @"msg": @"" };
        if (callback) {
            callback(result);
        }
        
    }])];
    [CMLRootViewController() presentViewController:alertController animated:YES completion:nil];
    
}

- (void)showLoading:(NSDictionary *)param callBack:(CMLMoudleCallBack)callback {
    
#if __has_include("MBProgressHUD.h")
    id viewController = self.cmlInstance.viewController;
    UIView *showView = nil;
    if (viewController && [viewController isKindOfClass:[CMLWeexRenderPage class]]) {
        showView = ((UIViewController *)viewController).view;
    }
    if (!showView) {
        showView = CMLRootViewController().view;
    }
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    NSString *title = param[@"title"];
    if (title && title.length > 0) {
        hud.label.text = title;
    }
    BOOL dimBackground = [param[@"mask"] boolValue];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = dimBackground ? [UIColor colorWithWhite:0.f alpha:.2f] : [UIColor clearColor];
    
#endif

}

- (void)hideLoading:(NSDictionary *)param callBack:(CMLMoudleCallBack)callback {
    
#if __has_include("MBProgressHUD.h")
    id viewController = self.cmlInstance.viewController;
    UIView *showView = nil;
    if (viewController && [viewController isKindOfClass:[CMLWeexRenderPage class]]) {
        showView = ((UIViewController *)viewController).view;
    }
    if (!showView) {
        showView = CMLRootViewController().view;
    }
    [MBProgressHUD hideHUDForView:showView animated:YES];
    
#endif
   
}



@end
