//
//  MoneyCell.m
//  AcessoryViewCustom
//
//  Created by citigo on 6/17/17.
//  Copyright © 2017 citigo. All rights reserved.
//

#import "MoneyCell.h"

@implementation MoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
}

@end
