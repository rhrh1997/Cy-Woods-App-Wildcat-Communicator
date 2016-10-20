//
//  CWDetailValueCell.h
//  CyWoods
//
//  Created by Andrew Liu on 8/9/13.
//  Copyright (c) 2013 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWDetailValueCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UILabel *subtitle;
@property (nonatomic, weak) IBOutlet UILabel *detail;

@end
