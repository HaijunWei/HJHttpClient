//
//  HJHttpRequestFormFile.m
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHttpRequestFormFile.h"

@implementation HJHttpRequestFormFile

+ (instancetype)fileWithData:(NSData *)data
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType {
    HJHttpRequestFormFile *file = [self new];
    file.data = data;
    file.name = name;
    file.fileName = fileName;
    file.mineType = mineType;
    return file;
}

@end
