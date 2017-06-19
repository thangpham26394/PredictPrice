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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSArray *potentialValues;
@property (strong, nonatomic) AccessoryView *customView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    // Do any additional setup after loading the view, typically from a nib.
    self.customView = [[AccessoryView alloc] initWithFrame:CGRectMake(0, 200, [[UIScreen mainScreen] bounds].size.width, 70)];
    self.customView.potentialValues = self.potentialValues;
    self.textField.inputAccessoryView = self.customView;
    [self.textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [self.textField addTarget:self action:@selector(onTextFieldChanged) forControlEvents:UIControlEventEditingChanged];

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
    
}

- (IBAction)hideKeyboard:(id)sender {
    [self.textField resignFirstResponder];
}

@end
