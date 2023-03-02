//
//  ScheduleTimeViewController.swift
//  Baseet App
//
//  Created by apple on 23/11/22.
//

import UIKit
import Alamofire

var isScheduledDateTime:String!
var isFromSchedule:String!

class ScheduleTimeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
   
    @IBOutlet weak var scheduleOrderBtn: UIButton!
    
    @IBOutlet weak var restNameLbl: UILabel!
    
    var finalDiscountAppledAmount:Int!
    
    @IBOutlet weak var tblVieww: UITableView!
    
    var mulitTimeSortedArray = [String]()
    
    let datePicker = UIDatePicker()
    
    var scheduleClosure:(()->())?
    
    let TimePicker = UIDatePicker()
    
    var day: Int!
    
    var restauraentID:String!
    
    var restaurentFoodPicksVCVM: RestaurentFoodPicksVCVM?
    
    var restauraneName:String!
    var imageName:String!
    var currentDate:String!
    var currentTime:String!
    var day1Str:String!
    var day2Str:String!
    var day3Str:String!
    var day4Str:String!
    var day5Str:String!
    var day6Str:String!
    var day7Str:String!
    var countriesData = [[String:Any]]()
    
    @IBOutlet weak var restImg: UIImageView!
    
    @IBOutlet weak var DateTF: UITextField!{
        didSet{
            DateTF.leftViewMode = UITextField.ViewMode.always
            DateTF.leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 10, height: 10))
            let image = UIImage(named: "16")
            imageView.image = image
            DateTF.leftView = imageView
        }
    }
    
    @IBOutlet weak var TimeTF: UITextField!{
        didSet{
            TimeTF.leftViewMode = UITextField.ViewMode.always
            TimeTF.leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 10, height: 10))
            imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: "time_16")
            imageView.image = image
            TimeTF.leftView = imageView
        }
    }
    
    var dayArray = [Int]()
    var openingTimeArray = [String]()
    var closingTimeArray = [String]()
    var day2OpeningTimeArray = [String]()
    var day2ClosingTimeArray = [String]()
    var day3OpeningTimeArray = [String]()
    var day3ClosingTimeArray = [String]()
    var day4OpeningTimeArray = [String]()
    var day4ClosingTimeArray = [String]()
    var day5OpeningTimeArray = [String]()
    var day5ClosingTimeArray = [String]()
    var day6OpeningTimeArray = [String]()
    var day6ClosingTimeArray = [String]()
    var day7OpeningTimeArray = [String]()
    var day7ClosingTimeArray = [String]()
    var timeArray = [String]()
    var startTimeArray = [String]()
    var endTimeArray = [String]()
    var day1EmptyArray = [String]()
    let date = Date()
    var day1Value:Int!
    let thePicker = UIPickerView()
    var dayName:String!
    var Closedtime:String!
    var Opendedtime:String!
    
    let myPickerData = ["Peter", "Jane", "Paul", "Mary", "Kevin", "Lucy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.restauraentID = UserDefaults.standard.string(forKey: "RestaurentId")
        TimeTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter Time", comment: "")
        DateTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter Date", comment: "")
        scheduleOrderBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Schedule Order", comment: ""), for: .normal)
        print(restauraentID!)
        self.showDatePicker()
        //self.getScheduleTime()
        self.getCurrentDate()
        thePicker.delegate = self
        thePicker.dataSource = self
        TimeTF.inputView = thePicker
        TimeTF.delegate = self
        DateTF.delegate = self
        restNameLbl.text = restauraneName!
        restImg.loadImageUsingURL(self.imageName)
        self.view.backgroundColor = .clear
        self.view.backgroundColor = .black.withAlphaComponent(0.6)
        self.getCurrentTime()
        print(currentTime!)
        
    }
    
    func getCurrentTime(){
        let today = Date()
        let hours   = (Calendar.current.component(.hour, from: today))
        let minutes = (Calendar.current.component(.minute, from: today))
        let seconds = (Calendar.current.component(.second, from: today))
        print("\(hours):\(minutes):\(seconds)")
        currentTime = (String(format: "%02d:%02d:%02d", hours, minutes, seconds))
        print(currentTime!)
    }
    
    func getCurrentDate(){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        currentDate = dateFormatter.string(from: date)
        print(currentDate!)
        dayName = date.dayNameOfWeek()
    }
    
    func timeInterval(){
        
        if DateTF.text == currentDate{
            print(Closedtime ?? "")
            if currentTime > Opendedtime ?? ""{
                timeArray.removeAll()
                let timeFormat = DateFormatter()
                timeFormat.dateFormat = "HH:mm:ss"
                timeFormat.locale = Locale(identifier: "en_US")
                var fromTime = timeFormat.date(from: currentTime)
                let toTime = timeFormat.date(from: Closedtime)
                var dateByAddingThirtyMinute: Date?
                var timeinterval: TimeInterval? = nil
                timeinterval = toTime?.timeIntervalSince(fromTime!) ?? 0.0
                let numberOfIntervals = Float(timeinterval! / 3600)
                print("Start time \(numberOfIntervals)")
                for iCount in 0..<(Int(numberOfIntervals * 2)) {
                    dateByAddingThirtyMinute = fromTime?.addingTimeInterval(1800)
                    fromTime = dateByAddingThirtyMinute
                    var formattedDateString: String?
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss"
                    if let dateByAddingThirtyMinute {
                        formattedDateString = dateFormatter.string(from: dateByAddingThirtyMinute)
                    }
                    print("Time after 30 min \(formattedDateString ?? "")")
                    timeArray.append(formattedDateString!)
                    print(timeArray)
                }
            }else{
                //timeArray.removeAll()
                let timeFormat = DateFormatter()
                timeFormat.dateFormat = "HH:mm:ss"
                timeFormat.locale = Locale(identifier: "en_US")
                var fromTime = timeFormat.date(from: Opendedtime)
                let toTime = timeFormat.date(from: Closedtime)
                var dateByAddingThirtyMinute: Date?
                var timeinterval: TimeInterval? = nil
                timeinterval = toTime?.timeIntervalSince(fromTime!) ?? 0.0
                let numberOfIntervals = Float(timeinterval! / 3600)
                print("Start time \(numberOfIntervals)")
                for iCount in 0..<(Int(numberOfIntervals * 2)) {
                    dateByAddingThirtyMinute = fromTime?.addingTimeInterval(1800)
                    fromTime = dateByAddingThirtyMinute
                    var formattedDateString: String?
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss"
                    if let dateByAddingThirtyMinute {
                        formattedDateString = dateFormatter.string(from: dateByAddingThirtyMinute)
                    }
                    print("Time after 30 min \(formattedDateString ?? "")")
                    timeArray.append(formattedDateString!)
                    print(timeArray)
                }
            }
        }else{
            timeArray.removeAll()
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "HH:mm:ss"
            timeFormat.locale = Locale(identifier: "en_US")
            var fromTime = timeFormat.date(from: Opendedtime)
            let toTime = timeFormat.date(from: Closedtime)
            var dateByAddingThirtyMinute: Date?
            var timeinterval: TimeInterval? = nil
            timeinterval = toTime?.timeIntervalSince(fromTime!) ?? 0.0
            let numberOfIntervals = Float(timeinterval! / 3600)
            print("Start time \(numberOfIntervals)")
            for iCount in 0..<(Int(numberOfIntervals * 2)) {
                dateByAddingThirtyMinute = fromTime?.addingTimeInterval(1800)
                fromTime = dateByAddingThirtyMinute
                var formattedDateString: String?
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                if let dateByAddingThirtyMinute {
                    formattedDateString = dateFormatter.string(from: dateByAddingThirtyMinute)
                }
                print("Time after 30 min \(formattedDateString ?? "")")
                timeArray.append(formattedDateString!)
                print(timeArray)
            }
        }
    }
    
    
    @IBAction func placeORderAction(_ sender: Any)
    {
        if DateTF.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter Date", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else if TimeTF.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter Time", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.dismiss(animated: true)
            isScheduledDateTime = "\(DateTF.text!) \(TimeTF.text! ?? "")"
            print(isScheduledDateTime)
            self.scheduleClosure?()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == DateTF {
            self.getScheduleTime()
        }
    }
    
    
    func DayOfWeek(date: String) -> String?
    {
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let _date = dateFormatter.date(from: date) else { return nil }
        let weekday = Calendar(identifier: .gregorian).component(.weekday, from: _date)
        return Calendar.current.weekdaySymbols[weekday-1]
    }
    
    func getScheduleTime(){
        if Reachability.isConnectedToNetwork(){
            let token = UserDefaults.standard.string(forKey: "AuthToken")
            let headers : HTTPHeaders = [
                "Authorization": " \(token!)"
            ]
            print(headers)
            let parameters = [
                "date": "\(DateTF.text!)",
                "id": "\(restauraentID!)"
                ]
            print(parameters)
            AF.request("\(Constants.Common.finalURL)/customer/get-restsch", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers)
                .responseJSON { [self] response in
                        switch response.result {
                        case .success(let json):
                            guard  let response = json as? NSArray else{
                               return
                            }
                            if response.count == 0{
                                self.showToast(message: "No Time Slots Found.", font: .systemFont(ofSize: 16))
                            }else{
                                self.countriesData.removeAll()
                                self.openingTimeArray.removeAll()
                                self.closingTimeArray.removeAll()
                                self.timeArray.removeAll()
                                self.mulitTimeSortedArray.removeAll()
                                self.countriesData = response as! [[String : Any]]
                                for time in response{
                                    let dict = time as! [String:AnyObject]
                                    self.Closedtime = dict["closing_time"] as? String ?? ""
                                    Opendedtime = dict["opening_time"] as? String ?? ""
                                    self.openingTimeArray.append(Opendedtime)
                                    self.closingTimeArray.append(Closedtime)
                                    isFromSchedule = "isFromSchedule"
                                    if DateTF.text == currentDate{
                                        print(Closedtime ?? "")
                                        if currentTime > Opendedtime ?? ""{
                                            if Closedtime <= currentTime{
                                                self.openingTimeArray.removeAll()
                                                self.closingTimeArray.removeAll()
                                                self.timeArray.removeAll()
                                                self.mulitTimeSortedArray.removeAll()
                                                
                                                self.showToast(message: "No Time Slots Found.", font: .systemFont(ofSize: 16))
                                                self.TimeTF.text = ""
                                                self.DateTF.text = ""
                                            }else{
                                                self.timeInterval()
                                                self.timeArray.append(contentsOf: closingTimeArray)
                                                print(timeArray)
                                                self.openingTimeArray.removeAll()
                                            }
                                            
                                        }else{
                                            self.timeInterval()
                                            self.timeArray.append(contentsOf: closingTimeArray)
                                            print(timeArray)
                                            self.openingTimeArray.removeAll()
                                            
                                            self.showToast(message: "No Time Slots Found.", font: .systemFont(ofSize: 16))
                                            self.DateTF.text = ""
                                            self.TimeTF.text = ""
                                           
                                        }
                                    }else{
                                        self.timeInterval()
                                        self.openingTimeArray.append(contentsOf: timeArray)
                                        self.openingTimeArray
                                        self.closingTimeArray.removeAll()
                                    }
                            }
                            
                                
                           
                            }
                        case .failure(let error):
                            print(error)
                            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                }
        }else{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: "Please Check Internet Connection"), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    

    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        DateTF.inputAccessoryView = toolbar
        DateTF.inputView = datePicker
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())

    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        DateTF.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func showTimePicker(){
        TimePicker.datePickerMode = .time
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancedTimePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        TimeTF.inputAccessoryView = toolbar
        TimeTF.inputView = TimePicker
        TimePicker.minimumDate = Date()
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func doneTimePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        TimeTF.text = formatter.string(from: TimePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancedTimePicker(){
        self.view.endEditing(true)
    }
    
   
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if DateTF.text == currentDate{
            if currentTime > Opendedtime ?? ""{
                if Closedtime <= currentTime{
                    return 0
                }else{
                    return timeArray.count
                }
                
            }else{
                return timeArray.count
            }
        }else{
            return openingTimeArray.count
        }
        
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if DateTF.text == currentDate{
            print(Closedtime ?? "")
            if currentTime > Opendedtime ?? ""{
                if Closedtime <= currentTime{
                    return ""
                }else{
                    return timeArray[row]
                }
            }else{
                return timeArray[row]
            }
        }else{
            return openingTimeArray[row]
        }
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if DateTF.text == currentDate{
            print(Closedtime ?? "")
            if currentTime > Opendedtime ?? ""{
                TimeTF.text = timeArray[row]
            }else{
                TimeTF.text = timeArray[row]
            }
        }else{
            TimeTF.text = openingTimeArray[row]
        }
    }
   
}

extension Date {
    func dayNameOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

