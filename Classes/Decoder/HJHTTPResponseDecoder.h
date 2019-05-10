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

@interface HJHTTPResponseDecoder : NSObject<HJHTTPResponseDecoder>

@end

NS_ASSUME_NONNULL_END
