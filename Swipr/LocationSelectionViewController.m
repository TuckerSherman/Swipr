//
//  LocationSelectionViewController.m
//  Swipr
//
//  Created by Tucker Sherman on 11/8/14.
//  Copyright (c) 2014 J and T. All rights reserved.
//

#import "LocationSelectionViewController.h"

@interface LocationSelectionViewController ()

@end

@implementation LocationSelectionViewController{
    NSArray*cityNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityPicker.delegate = self;
    self.cityPicker.dataSource = self;
    self.mapView.delegate = self;
    
    self.mapView.centerCoordinate = self.searchLocation;
    NSLog(@"displaying: %f, %f",self.searchLocation.latitude, self.searchLocation.longitude);
    self.cities = @{@"Portland":@{@"latitude":@45.5200, @"longitude":@122.6819},
                    @"Use My Current Location": @"here",
                    @"Vancouver":@{@"latitude":@49.2500, @"longitude":@123.1000},
                    @"Calgary": @{@"latitude":@51.0500, @"longitude":@114.0667}
                    };
    cityNames = [self.cities allKeys];
    
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)setCatButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"back we go");
    }];
    
}
- (IBAction)doneButton:(id)sender {
     [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectRow:(NSInteger)row
      inComponent:(NSInteger)component
         animated:(BOOL)animated{
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return self.cities.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component{
    
    return cityNames[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    switch (row) {
        case 0:{
            NSLog(@"%@",cityNames[0]);
            //if the user has allowed location services use their current location

     
            break;
        }

        case 1:{
            NSLog(@"%@",cityNames[1]);
            //parse the selected city's coordinates and set them as the search location
//            NSDictionary* cityCoordinates = [self.cities objectForKey:cityNames[1]];
//            NSNumber* latitude =[cityCoordinates objectForKey:@"latitude"];
//            NSNumber* longitude = [cityCoordinates objectForKey:@"longitude"];
//            CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);

        }
            break;
        case 2:{
            {
                NSLog(@"%@",cityNames[2]);
//            NSDictionary* cityCoordinates = [self.cities objectForKey:cityNames[0]];
//            NSNumber* latitude =[cityCoordinates objectForKey:@"latitude"];
//            NSNumber* longitude = [cityCoordinates objectForKey:@"longitude"];
//            CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
            //parse the selected city's coordinates and set them as the search location
            }
        }

            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
