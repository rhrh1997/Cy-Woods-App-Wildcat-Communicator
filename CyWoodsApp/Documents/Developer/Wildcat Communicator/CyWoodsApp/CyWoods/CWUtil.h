//
//  CWUtil.h
//  CyWoods
//
//  Created by Andrew Liu on 9/6/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@interface CWUtil : NSObject

+(NSData *)encrypt:(NSData *)data withPassword:(NSString *)pass;
+(NSData *)decrypt:(NSData *)data withPassword:(NSString *)pass;
+(NSString *)encodeBase64WithString:(NSString *)strData;
+(NSString *)encodeBase64WithData:(NSData *)objData;
+(NSData *)decodeBase64WithString:(NSString *)strBase64;

+(NSString *)encodePassword:(NSString *)pass forUser:(NSString *)user;
+(NSString *)decodePassword:(NSString *)pass forUser:(NSString *)user;
+(NSString *)toJson:(id)data;
+(id)jsonFromString:(NSString *)str;

+(void)savePlist:(id)plist toFile:(NSString *)file;

@end
