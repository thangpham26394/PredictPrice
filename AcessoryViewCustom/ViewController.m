//
//  ViewController.m
//  AcessoryViewCustom
//
//  Created by citigo on 6/17/17.
//  Copyright © 2017 citigo. All rights reserved.
//

#import "ViewController.h"
#import "AccessoryView.h"
#import "AutoCorrectMoney.h"

@interface ViewController ()<AccessoryViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *suggestTextField;

@property (strong, nonatomic) NSArray *potentialValues;
@property (strong, nonatomic) AccessoryView *customView;
@property (strong, nonatomic) AccessoryView *suggestView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.suggestTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    // Do any additional setup after loading the view, typically from a nib.
    self.customView = [[AccessoryView alloc] init];
    self.suggestView = [[AccessoryView alloc] init];
    self.suggestView.delegate = self;
    self.customView.potentialValues = self.potentialValues;
    self.textField.inputAccessoryView = self.customView;
    self.suggestTextField.inputAccessoryView = self.suggestView;
    
    
    [self.textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.textField addTarget:self action:@selector(onTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    [self.suggestTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.suggestTextField addTarget:self action:@selector(onSuggestTextFieldChanged) forControlEvents:UIControlEventEditingChanged];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTextFieldChanged {
    NSString *valueString = self.textField.text;
    self.potentialValues = [AutoCorrectMoney potentialMoneyWith:[valueString doubleValue]];
    self.customView.potentialValues = self.potentialValues;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.customView.collectionView reloadData];
        self.textField.inputAccessoryView = self.customView;
    });
    
    self.suggestView.potentialValues  = [[NSArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.suggestView.collectionView reloadData];
        self.suggestTextField.inputAccessoryView = self.suggestView;
    });
}

- (void)onSuggestTextFieldChanged {
    NSString *currentText = self.suggestTextField.text;
    NSMutableArray *suitableValues = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < self.potentialValues.count; i ++) {
        if ([[self.potentialValues[i] stringValue] hasPrefix:currentText]) {
            [suitableValues addObject:self.potentialValues[i]];
        }
    }
    
    //Add thêm giá trị người dùng đang nhập
    double defaultValue = [currentText doubleValue] == 0? [self.textField.text doubleValue] : [currentText doubleValue];
    if (![suitableValues containsObject:@(defaultValue)]) {
        [suitableValues addObject:@(defaultValue)];
    }
    

    self.suggestView.potentialValues = suitableValues;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.suggestView.collectionView reloadData];
        self.suggestTextField.inputAccessoryView = self.suggestView;
    });
    
}

- (void)didSelecteValue:(double)value {
    self.suggestTextField.text = [NSString stringWithFormat:@"%.0f",value];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

@end
