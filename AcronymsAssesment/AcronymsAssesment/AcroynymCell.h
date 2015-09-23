//
//  AccroynymCell.h
//  AcronymsAssesment
//
//  Created by Joe Avalos on 9/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcroynymCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (weak, nonatomic) IBOutlet UILabel *lblFreq;
@property (weak, nonatomic) IBOutlet UILabel *lblSince;

@end
