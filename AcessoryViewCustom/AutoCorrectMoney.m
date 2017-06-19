//
//  AutoCorrectMoney.m
//  AcessoryViewCustom
//
//  Created by citigo on 6/17/17.
//  Copyright © 2017 citigo. All rights reserved.
//

#import "AutoCorrectMoney.h"

@implementation AutoCorrectMoney


+ (NSArray *)potentialMoneyWith:(double)money {
    NSMutableArray *potentialArray = [[NSMutableArray alloc] init];
    double m = money; // money/1000
    BOOL shouldAdd500 = money > 500;
    if (shouldAdd500) {
        m -= 500;
    }
    double max = 1000;
    double min = 0;

    NSArray *VNMoneyType = @[@(10),@(20),@(50),@(100),@(200),@(500)];

    if ([VNMoneyType containsObject:@(m)]) {
        for (NSUInteger i = 0; i<VNMoneyType.count; i ++) {
            if ([VNMoneyType[i] doubleValue] >= m) {
                [potentialArray addObject:shouldAdd500? @([VNMoneyType[i] doubleValue] + 500): @([VNMoneyType[i] doubleValue]) ];
            }
        }
        return potentialArray;
    }


    //Tạm check cho trường hợp < 1,000,000 vnđ

    //Tìm min và max cho khoảng tiền dự đoán
    for (NSUInteger index = VNMoneyType.count; index >= 1; index --) {
        if (index == VNMoneyType.count) {
            //Check trong trường hợp là 500k
            if (m == 500) {
                min = 500;
                break;
            }
        } else {
            //Check trong các trường hợp nhỏ hơn 500 k
            while (min < m) {
                min += [VNMoneyType[index - 1] doubleValue];
            }
            if (min > m && index != 1) {
                min -= [VNMoneyType[index - 1] doubleValue];
            }
        }
    }

    //Tính các giá trị có thể được tạo thành tính từ min và các loại tiền
    if (min >= m) {
        min -= 10;
    }
    int tienle = (int)(min)%100;
    double tienchan = min - tienle;




    int i = 0;
    while ( min < max && i < VNMoneyType.count ) {
        NSUInteger loaiTien = [VNMoneyType[i] integerValue];
        if (min + loaiTien > max) {
            break;
        }
        double start = tienchan;
        if (loaiTien <= tienle) {
            start = min;
        }
        double addValue;
        if (loaiTien >= m) {
            addValue = loaiTien;
        } else {
            addValue = start + loaiTien;
        }


        if (![potentialArray containsObject:@(addValue)]) {
            if ([VNMoneyType containsObject:@(addValue)]) {
                [potentialArray addObject:@(addValue)];
            } else {
                BOOL shouldNotAdd = NO;
                //Kiểm tra nếu có 1 tờ tiền nào đó có mệnh giá lớn hơn min nhưng nhỏ hơn addValue thì không add giá trị đó vào nữa
                for ( NSUInteger j = 0;  j < VNMoneyType.count; j++) {
                    double tien = [VNMoneyType[j] doubleValue];
                    double loaiTienVuaAdd = [[potentialArray firstObject] doubleValue];
                    double giaTriCheck = loaiTienVuaAdd;
                    if (loaiTienVuaAdd == 0) {
                        giaTriCheck = min + 10;
                    }
                    
                    //Kiểm tra nếu có tờ tiền có mệnh giá phù hợp và chưa add vào potentialArray thì sử dụng tờ tiền đó như addValue
                    if (tien >= giaTriCheck && tien < addValue && ![potentialArray containsObject:@(tien)]) {
//                        j--;
                        addValue = tien;
                        continue;
                    }
                    
                    
                    if (tien >= giaTriCheck && tien <= addValue && loaiTien == 50) {
                        shouldNotAdd = YES;
                    }
                }
                if (!shouldNotAdd) {
                    [potentialArray addObject:@(addValue)];
                }
            }
        }


        i++;
    }

    
    if (![potentialArray containsObject:@(m)]) {
        [potentialArray insertObject:@(m) atIndex:0];
    }

    if (shouldAdd500) {
        for (int i=0; i<potentialArray.count; i ++) {
            double newValue = [potentialArray[i] doubleValue] + 500;
            [potentialArray replaceObjectAtIndex:i withObject:@(newValue)];
        }
    }
    
    return potentialArray;
}



@end
