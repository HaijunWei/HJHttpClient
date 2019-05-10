//
//  HJHTTPRequestFormFile.m
//
//  Created by Haijun on 2019/5/10.
//

#import "HJHTTPRequestFormFile.h"

@implementation HJHTTPRequestFormFile

+ (instancetype)fileWithData:(NSData *)data
                        name:(NSString *)name
                    fileName:(NSString *)fileName
                    mineType:(NSString *)mineType {
    HJHTTPRequestFormFile *file = [self new];
    file.data = data;
    file.name = name;
    file.fileName = fileName;
    file.mineType = mineType;
    return file;
}

@end
