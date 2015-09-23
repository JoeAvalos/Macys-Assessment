//
//  WebserviceHandler.h
//  AcronymsAssesment
//
//  Created by Joe Avalos on 9/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShortForm&LongForm.h"

@interface WebserviceHandler : NSObject

+(void)getShortFormOrLongFormFor:(NSString*)str withCompletion: ( void(^)(NSArray* arrSFLF, NSError* error) )result;

@end
