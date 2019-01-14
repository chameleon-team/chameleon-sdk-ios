//
//  CMLCommonModule.m
//  Chameleon
//
//  Created by Chameleon-Team on 2018/12/29.
//

#import "CMLCommonModule.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <CoreLocation/CoreLocation.h>
#import "CMLWeexRenderPage.h"
#import "CMLModuleManager.h"
#import "CMLUtility.h"
#import "CMLConstants.h"
#import "CMLWKWebView.h"
#import "CMLUtility.h"

@interface CMLCommonModule ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void(^doneHandler)(NSInteger code, UIImage *image, NSString *type);
@property (nonatomic, copy) void(^locationDoneHandler)(NSInteger code, NSDictionary *locationDict);

/**
 相册数据
 */
@property (nonatomic, strong) NSDictionary *paramsData;

@end

@implementation CMLCommonModule
@synthesize cmlInstance;

CML_EXPORT_METHOD(@selector(getSDKInfo:))
CML_EXPORT_METHOD(@selector(getLaunchUrl:))

CML_EXPORT_METHOD(@selector(getSystemInfo:))
CML_EXPORT_METHOD(@selector(getLocationInfo:))
CML_EXPORT_METHOD(@selector(chooseImage:callBack:))

CML_EXPORT_METHOD(@selector(setTitle:callBack:))
CML_EXPORT_METHOD(@selector(openPage:callBack:))
CML_EXPORT_METHOD(@selector(closePage:callBack:))

CML_EXPORT_METHOD(@selector(reloadPage:callBack:))
CML_EXPORT_METHOD(@selector(rollbackWeb:callBack:))
CML_EXPORT_METHOD(@selector(canIUse:callBack:))


- (void)getSDKInfo:(CMLMoudleCallBack)callback
{
    if (callback) {
        NSDictionary *versionDict = @{@"version": CMLSDKVersion};
        NSDictionary *result = @{@"errno": @"0", @"data":_CMLJSONStringWithObject(versionDict), @"msg": @""};
        callback(result);
    }
}

- (void)getLaunchUrl:(CMLMoudleCallBack)callback
{
    if (callback) {
        
        id viewController = self.cmlInstance.viewController;
        if (viewController && [viewController isKindOfClass:[CMLWKWebView class]]) {
            viewController = ((CMLWKWebView *)viewController).viewController;
        }
        if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
            CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
            NSDictionary *result = @{@"errno": @"0", @"data":pageVC.url?:@"", @"msg": @""};
            callback(result);
        }
    }
}

- (void)getSystemInfo:(CMLMoudleCallBack)callback
{
    if (callback) {
        NSDictionary *sysInfo = [CMLUtility getEnvironment];
        if (sysInfo) {
            NSDictionary *result = @{@"errno": @"0", @"data":_CMLJSONStringWithObject(sysInfo), @"msg": @""};
            callback(result);
        }
    }
}
- (void)getLocationInfo:(CMLMoudleCallBack)callback
{
    if (callback) {
        [self startLocation];
        self.locationDoneHandler = ^(NSInteger code, NSDictionary *locationDict) {
           
            if (code == 0) {
                NSDictionary *result = @{@"errno": @"0", @"data":_CMLJSONStringWithObject(locationDict), @"msg": @""};
                callback(result);
                
            }else{
                NSDictionary *result = @{@"errno": @"-1", @"data":@"", @"msg": @""};
                callback(result);
            }
        };
    }
}

- (void)chooseImage:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
    
     self.paramsData = parms;
    
     __weak typeof(self) weakSelf = self;
    self.doneHandler = ^(NSInteger code, UIImage *image, NSString *type) {
        if(image){
            [weakSelf pickupBase64Image:image type:type callBack:callback ];
        } else {
            NSDictionary *result = @{@"errno": @(code), @"data":@"", @"msg": @""};
            if(callback) callback(result);
        }
    };
    NSString *type = parms[@"type"];
    //调起拍照
    if ([type isEqualToString:@"camera"]) {
        [self showCamera];
        
    }else if ([type isEqualToString:@"album"]){
         [self callPhotoLibary];
        
    }else if ([type isEqualToString:@"choice"]){
         [self callCameraOrPhotoLibary];
    }
}

- (void)setTitle:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
    
    NSString *title = parms[@"title"]?parms[@"title"]:@"";
   
    id viewController = self.cmlInstance.viewController;
    if (viewController && [viewController isKindOfClass:[CMLWKWebView class]]) {
        viewController = ((CMLWKWebView *)viewController).viewController;
    }
    if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
        CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
        [pageVC setTopNavTitle:title];
        if (callback) {
            NSDictionary *result = @{@"errno": @"0", @"msg": @""};
            if(callback) callback(result);
        }
    }
}

- (void)openPage:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
    
    NSString *closeCurrent = parms[@"closeCurrent"];
    NSString *encodeUrl = parms[@"url"];
    if ([closeCurrent boolValue]) {
        if ([CMLRootViewController() isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)CMLRootViewController() popViewControllerAnimated:YES];
        }
    }
    
    CMLWeexRenderPage *weexDemo = [[CMLWeexRenderPage alloc] initWithLoadUrl:encodeUrl];
    weexDemo.service = [CMLEnvironmentManage chameleon].weexService;
    if ([CMLRootViewController() isKindOfClass:[UINavigationController class]]) {
         [(UINavigationController *)CMLRootViewController() pushViewController:weexDemo animated:YES];
    }
}

- (void)closePage:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
   
    if ([CMLRootViewController() isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)CMLRootViewController() popViewControllerAnimated:YES];
    }
}

- (void)reloadPage:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
    
    NSString *url = parms[@"url"];
    
    id viewController = self.cmlInstance.viewController;
    if (viewController && [viewController isKindOfClass:[CMLWKWebView class]]) {
        viewController = ((CMLWKWebView *)viewController).viewController;
    }
    
    if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
        [(CMLRenderPage *) viewController reloadJSBundleWithUrl:url];
        if (callback) {
            NSDictionary *result = @{@"errno": @(0), @"msg": @""};
            if(callback) callback(result);
        }
    }
}
- (void)rollbackWeb:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
    
    id viewController = self.cmlInstance.viewController;
    if (viewController && [viewController isKindOfClass:[CMLWKWebView class]]) {
        viewController = ((CMLWKWebView *)viewController).viewController;
    }
    
    if (viewController && [viewController isKindOfClass:[CMLRenderPage class]]) {
        CMLRenderPage *pageVC = (CMLRenderPage *)viewController;
        [pageVC needsFusionWebViewToBeEngagement];
        if (callback) {
            NSDictionary *result = @{@"errno": @(0), @"msg": @""};
            if(callback) callback(result);
        }
    }
}

- (void)canIUse:(NSDictionary *)parms callBack:(CMLMoudleCallBack)callback
{
    
   NSString *method = parms[@"method"];
    
   NSDictionary *allModules = [[CMLModuleManager sharedManager] getAllModules];
  
    __block BOOL haveMethod = NO;
    [allModules.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *moduleName = obj;
        if (moduleName) {
            CMLModuleConfig *exportModule = [[CMLModuleManager sharedManager] moduleWithName:moduleName];
            [exportModule.methods.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop2) {
                NSString *methodName = obj;
                if ([method isEqualToString:methodName]) {
                    haveMethod = YES;
                    *stop2 = YES;
                }
            }];
        }
        if (haveMethod) {
            *stop = YES;
        }
    }];
    
    if (callback) {
        NSString *errnoValue = haveMethod?@"0":@"1";
        NSDictionary *result = @{@"errno": errnoValue, @"data":@"", @"msg": @""};
        if(callback) callback(result);
    }
}


#pragma mark -- 相机相关

- (void)showCamera
{
    
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                if(granted){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self callCamera];
                    });
                }else{
                    return;
                }
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
            [self callCamera];
            break;
        case AVAuthorizationStatusDenied: {

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请授权使用您的相机，操作路径：“设置->隐私->相机->app”" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 if(self.doneHandler) self.doneHandler(3, nil, nil);
            }])];
            [CMLRootViewController() presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
        default:
            [self callCamera];
            break;
    }
}

- (void)callCamera
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = [self isImagePickerAllowEditing];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
       
        [CMLRootViewController() presentViewController:picker animated:YES completion:nil];
    }else{
        //如果没有提示用户
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"你没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 没有摄像头
             if(self.doneHandler) self.doneHandler(1, nil, nil);
        }])];
        [CMLRootViewController() presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)callPhotoLibary
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = [self isImagePickerAllowEditing];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate   = self;
    [CMLRootViewController() presentViewController:picker animated:YES completion:nil];
}

- (void)callCameraOrPhotoLibary
{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          if(self.doneHandler) self.doneHandler(2, nil, nil);
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //摄像头
        [self showCamera];
    }];
  
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //从相册选择
        [self callPhotoLibary];
    }];
   
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];

    [CMLRootViewController() presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * editedimage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSURL *imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSDictionary * urlParms = [self getUrlParms:imageUrl.absoluteString];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    __weak typeof(self) weakSelf = self;
    [CMLRootViewController() dismissViewControllerAnimated:YES completion:^{
        if(weakSelf.doneHandler) weakSelf.doneHandler(0, editedimage?:image, urlParms[@"ext"]);
    }];
    
}

- (void)pickupBase64Image:(UIImage *)image type:(NSString *)type callBack:(CMLMoudleCallBack)callback
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGFloat quality = 1.0f; NSData *data = nil;
        
        BOOL ispng = [[type lowercaseString] isEqualToString:@"png"];
        if(weakSelf.paramsData[@"quality"] && !ispng){
            quality = [weakSelf.paramsData[@"quality"] floatValue] / 100.0f;
            data = UIImageJPEGRepresentation(image, quality);
        } else {
            
            data = UIImagePNGRepresentation(image);
        }
        NSString *base64 = _CMLBase64DataEncode(data);
        NSDictionary *result = @{@"errno": @"0", @"data":_CMLJSONStringWithObject(@{@"type":ispng?@"png":@"jpg",@"image":base64?:@""}), @"msg": @""};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(callback) callback(result);
        });
    });
}

//点击Cancel按钮后执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    [CMLRootViewController() dismissViewControllerAnimated:YES completion:^{
        if(weakSelf.doneHandler) weakSelf.doneHandler(2, nil, nil);
    }];
}

- (NSDictionary *)getUrlParms:(NSString *)url
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if(url && [url isKindOfClass:[NSString class]] && url.length > 0){
        NSArray *querys = [url componentsSeparatedByString:@"&"];
        for(NSString *query in querys){
            NSArray *values = [query componentsSeparatedByString:@"="];
            NSString *key = values.count > 0 ? values[0] : nil;
            NSString *value = values.count > 1 ? values[1] : @"";
            if(key.length > 0){
                dict[key] = [value stringByRemovingPercentEncoding];
            }
        }
    }
    return dict;
}

- (BOOL)isImagePickerAllowEditing
{
    if(self.paramsData){
        return [self.paramsData[@"cut"] boolValue];
    }
    return YES;
}

#pragma mark -- 定位相关
//开始定位
- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
    
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        if (self.locationDoneHandler) {
            self.locationDoneHandler(-1, nil);
        }
    }
    if ([error code] == kCLErrorLocationUnknown) {
   
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = locations[0];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
     __weak typeof(self) weakSelf = self;
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            NSNumber *longitude = [NSNumber numberWithDouble:placemark.location.coordinate.longitude];;
            NSNumber *latitude = [NSNumber numberWithDouble:placemark.location.coordinate.latitude];
        
            if (!city) {
                city = placemark.administrativeArea;
            }
            NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
            [locationDic setObject:city forKey:@"city"];
            [locationDic setValue:longitude forKey:@"lng"];
            [locationDic setValue:latitude forKey:@"lat"];
            if (weakSelf.locationDoneHandler) {
                weakSelf.locationDoneHandler(0, locationDic);
            }
        }
        else if (error == nil && [array count] == 0)
        {
            if (weakSelf.locationDoneHandler) {
                weakSelf.locationDoneHandler(-1, nil);
            }
        }
        else if (error != nil)
        {
            if (weakSelf.locationDoneHandler) {
                weakSelf.locationDoneHandler(-1, nil);
            }
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}

@end
