//
//  WebserviceHandler.m
//  AcronymsAssesment
//
//  Created by Joe Avalos on 9/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import "WebserviceHandler.h"
#import <AFNetworking.h>

static NSString * const ACRONYM_INITIALISMS_URL = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?%@=%@";

@implementation WebserviceHandler

+(void)getShortFormOrLongFormFor:(NSString *)str withCompletion:(void (^)(NSArray *, NSError* error))result{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *strForm = [str rangeOfString:@" "].location == NSNotFound ? @"sf" : @"lf";
    NSString *strFilledURL = [NSString stringWithFormat:ACRONYM_INITIALISMS_URL, strForm ,str];
    [manager GET:strFilledURL parameters:nil success:^(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSMutableArray *arrLFSF = [NSMutableArray new];
        NSArray *root = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if( root.count > 0 ){
            
            NSDictionary *base = root[0];
            NSArray *results = base[@"lfs"];
            
            
            for( NSDictionary *aResult in results){
                ShortForm_LongForm *sflf = [WebserviceHandler getModelFromDictionary:aResult];

                NSArray *variation = aResult[@"vars"];
                NSMutableArray *arrVars = [NSMutableArray new];
                for( int i =1; i < variation.count; i++ ){
                    [arrVars addObject: [self getModelFromDictionary:variation[i]] ];
                }
                sflf.arrVariations = arrVars;
                
                [arrLFSF addObject:sflf];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            result(arrLFSF, nil);
        });
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        result(nil, error);
    }];
}

+(ShortForm_LongForm*)getModelFromDictionary:(NSDictionary*)aDict{
    ShortForm_LongForm *sflf = [ShortForm_LongForm new];
    sflf.strResult = aDict[@"lf"];
    sflf.numFrequency = [NSNumber numberWithInteger:[aDict[@"freq"] integerValue]];
    sflf.numSince = [NSNumber numberWithInteger:[aDict[@"since"] integerValue]];
    return sflf;
}

@end
