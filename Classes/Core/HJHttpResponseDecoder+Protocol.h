//
//  HJHttpResponseDecoder+Protocol.h
//
//  Created by Haijun on 2019/5/10.
//

@protocol HJHttpResponseDecoder <NSObject>
/*
 解析响应值，
 只支持返回 HJHttpResponse 或者 NSError
 */
- (id)request:(HJHttpRequest *)req didGetURLResponse:(NSHTTPURLResponse *)response responseData:(id)responseData error:(NSError *)error;

@end
