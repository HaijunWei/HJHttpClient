//
//  HJHTTPResponse.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJHTTPResponse : NSObject

/// 原始响应值
@property (nonatomic, strong) id rawData;
/// 响应值
@property (nonatomic, strong) id data;
/// 状态码
@property (nonatomic, assign) NSInteger code;
/// 响应消息
@property (nonatomic, copy) NSString *message;
/// 响应头
@property (nonatomic, strong) NSDictionary *allHeaderFields;

/// 附加参数，用于支持扩展功能
@property (nonatomic, strong) NSMutableDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
