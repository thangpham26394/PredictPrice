//
//  AccessoryView.m
//  AcessoryViewCustom
//
//  Created by citigo on 6/17/17.
//  Copyright © 2017 citigo. All rights reserved.
//

#import "AccessoryView.h"
#import "MoneyCell.h"

@implementation AccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    self.frame = frame;
    
    UINib *cellNib = [UINib nibWithNibName:@"MoneyCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MoneyCell"];
    
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.potentialValues.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoneyCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MoneyCell" forIndexPath:indexPath];
    cell.label.text = [self.potentialValues[indexPath.row] stringValue];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10 , 10, 10, 10);
}

@end
