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
    double m = money;
    int tienTrieu = 0;
    
    //Check trường hợp tiền lớn hơn 1 tr
    if (money > 1000) {
        m = (int)money % 1000;
        tienTrieu = money - m;
        money = m;
    }
    //Check trường hợp tiền <sau khi loại hàng triệu nếu có> vẫn lớn hơn 500k thì trừ 500k để tính cho dễ
    BOOL shouldAdd500 = money > 500;
    if (shouldAdd500) {
        m -= 500;
    }
    double max = 1000;
    double min = 0;
    
    //Mảng chứa các loại tiền của VN vs mệnh giá từ 10k trở lên
    NSArray *VNMoneyType = @[@(10),@(20),@(50),@(100),@(200),@(500)];

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

        //Check nếu giá trị addValue chưa được add vào
        if (![potentialArray containsObject:@(addValue)]) {
            //Nếu giá trị addValue là 1 loại tiền thì add no vào luôn
            if ([VNMoneyType containsObject:@(addValue)]) {
                [potentialArray addObject:@(addValue)];
            } else {
                BOOL shouldNotAdd = NO;
                //Kiểm tra có nên add giá trị đang dự đoán vào potentialArray ko
                for ( NSUInteger j = 0;  j < VNMoneyType.count; j++) {
                    //Loại tiền đang xét trong mảng các loại tiền của VN
                    double tien = [VNMoneyType[j] doubleValue];
                    //Giá trị tiền nhỏ nhất thoả mãn đã được add vào potentialArray
                    double loaiTienVuaAdd = [[potentialArray firstObject] doubleValue];
                    //Giá trị dùng để kiểm tra tiền đang dự đoán có phù hợp hay không
                    double giaTriCheck = loaiTienVuaAdd;

                    if (loaiTienVuaAdd == 0) {
                        giaTriCheck = min + 10;
                    }
                    
                    //Kiểm tra nếu có tờ tiền có mệnh giá phù hợp và chưa add vào potentialArray thì sử dụng tờ tiền đó như addValue
                    if (tien >= giaTriCheck && tien < addValue && ![potentialArray containsObject:@(tien)]) {
                        addValue = tien;
                        continue;
                    }
                    
                    /*
                     *Trường hợp đặc biệt nếu tiền khởi điểm không phải tiền chẵn và giá trị cộng thêm = 50k thì loại < vì nó có thể chỉ cần cộng thêm 10k hoặc 20k>
                     *Tiền khởi điểm phải chẵn thì mới được tính case cộng thêm 50k vì khi đó không thể có lựa chọn vứt bớt tờ tiền lẻ nào khác nữa
                     */
                    if (start != tienchan && loaiTien == 50) {
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
    
    
    //Add giá trị tiền mặc định cần thanh toán
    if (![potentialArray containsObject:@(m)]) {
        [potentialArray insertObject:@(m) atIndex:0];
    }
    
    //Check nếu số tiền tính lúc trước đã trừ bớt 500k < do lớn hơn 500k > thì cộng bù vào
    if (shouldAdd500) {
        for (int i=0; i<potentialArray.count; i ++) {
            double newValue = [potentialArray[i] doubleValue] + 500;
            [potentialArray replaceObjectAtIndex:i withObject:@(newValue)];
        }
    }
    
    //Check nếu tiền nhập ban đầu lớn hơn 1 triệu
    if (tienTrieu > 0) {
        for (int i=0; i<potentialArray.count; i ++) {
            double newValue = [potentialArray[i] doubleValue] + tienTrieu;
            [potentialArray replaceObjectAtIndex:i withObject:@(newValue)];
        }
    }
    
    return potentialArray;
}

@end
