/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#if __has_include("SocketRocket.h")
#import <SocketRocket/SocketRocket.h>
#import "WXWebSocketHandler.h"
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface SRWebSocket (CMLWeex)
@property (nonatomic, copy) NSString *wx_Identifier;
@property (nonatomic, weak) id<WXWebSocketDelegate> wx_WebSocketDelegate;
@end

NS_ASSUME_NONNULL_END
#endif
