//
//  HJHTTPResponseDecoder.h
//
//  Created by Haijun on 2019/5/9.
//

#import <Foundation/Foundation.h>
#import "HJHTTPRequest+Decoder.h"
#import "HJHTTPResponse+Decoder.h"
#import "HJHTTPResponseDecoder+Protocol.h"

NS_ASSUME_NONNULL_BEGIN

extern NSErrorDomain const HJHTTPResponseDecoderDomain;
/* 解析响应值失败 */
extern NSInteger const HJHTTPResponseDecoderFailure;
/* 正常状态响应码 */
extern NSInteger const HJHTTPResponseDecoderNormalStatusCode;

typedef NSString *HJHTTPResponseKey;

extern HJHTTPResponseKey const HJHTTPResponseCodeKey;
extern HJHTTPResponseKey const HJHTTPResponseDataKey;
extern HJHTTPResponseKey const HJHTTPResponseMessageKey;


@interface HJHTTPResponseDecoder : NSObject<HJHTTPResponseDecoder>

/// 响应对象键值映射，@{HJHTTPResponseKey:xxx}
@property (nonatomic, strong) NSDictionary *responseKeyMapping;

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
