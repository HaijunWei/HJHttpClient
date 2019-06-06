//
//  HJHttpResponseDecoder.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "HJHttpRequest+Decoder.h"
#import "HJHttpResponse+Decoder.h"
#import "HJHttpResponseDecoder+Protocol.h"

NS_ASSUME_NONNULL_BEGIN

extern NSErrorDomain const HJHttpResponseDecoderDomain;

typedef NS_ENUM(NSInteger, HJHttpResponseCode) {
    /* 正常响应码 */
    HJHttpResponseCodeNormal = 200,
    /* 解析响应值失败 */
    HJHttpResponseCodeDecoderFailure = -1,
};

typedef NSString *HJHttpResponseKey;

extern HJHttpResponseKey const HJHttpResponseCodeKey;
extern HJHttpResponseKey const HJHttpResponseDataKey;
extern HJHttpResponseKey const HJHttpResponseMessageKey;


@interface HJHttpResponseDecoder : NSObject<HJHttpResponseDecoder>

/// 响应对象键值映射，@{HJHttpResponseKey:xxx}
@property (nonatomic, strong) NSDictionary *responseKeyMapping;

#pragma mark - Public

/// 将要解析返回数据，如果有附加的解析步骤在此方法操作
/// @param responseObject 响应数据对象
- (id)willGenerateResponse:(id)responseObject;

#pragma mark - Helpers

/**
 反序列化数据
 
 @param cls object类型
 @param path 解析路径
 @param data 待处理数据
 @return object
 */
- (id)deserializationWithResponseDataCls:(Class)cls deserializationPath:(NSString *)path data:(id)data;

@end

NS_ASSUME_NONNULL_END
