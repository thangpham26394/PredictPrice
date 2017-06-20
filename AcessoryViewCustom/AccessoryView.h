//
//  AccessoryView.h
//  AcessoryViewCustom
//
//  Created by citigo on 6/17/17.
//  Copyright © 2017 citigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccessoryViewDelegate <NSObject>

@optional
- (void)didSelecteValue:(double)value;
@end


@interface AccessoryView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *potentialValues;
@property (weak, nonatomic) id<AccessoryViewDelegate> delegate;

-(instancetype)init;
@end
