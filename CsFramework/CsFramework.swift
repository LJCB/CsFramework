//
//  CsFramework.swift
//  CsFramework
//
//  Created by Luis J. Capistran on 6/12/19.
//  Copyright © 2019 CSGroup. All rights reserved.
//

import UIKit

open class CsFramework: NSObject {
  
  open class func formatMoney(_ price: Double) -> String{
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
   
    currencyFormatter.locale = Locale.current
    let priceString = currencyFormatter.string(for: price) ?? "0.00"
    print(priceString.dropFirst(2)) // Displays $9,999.99 in the US locale
    return String(priceString.dropFirst(2))
  }
  
  open class func formatDate(stringDate:String ,withFormat: String) -> String{
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatterGet.locale = Locale(identifier: "en_US")
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatterPrint.locale = Locale(identifier: "en_US")
    dateFormatterPrint.dateFormat = withFormat
    
    if let date = dateFormatterGet.date(from: stringDate) {
      print(dateFormatterPrint.string(from: date))
      return dateFormatterPrint.string(from: date)
    } else {
      return stringDate
    }
  }
  
  open class func textMask(text: String, mask: String) -> String {
    let cleanPhoneNumber = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    var result = ""
    var index = cleanPhoneNumber.startIndex
    for ch in mask {
      if index == cleanPhoneNumber.endIndex {
        break
      }
      if ch == "X" {
        result.append(cleanPhoneNumber[index])
        index = cleanPhoneNumber.index(after: index)
      } else {
        result.append(ch)
      }
    }
    return result
  }
  
  open class func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    if let filter = CIFilter(name: "CIQRCodeGenerator"){
      filter.setValue(data, forKey: "inputMessage")
      let transform = CGAffineTransform(scaleX: 3, y: 3)
      if let output = filter.outputImage?.transformed(by: transform) {
        return UIImage(ciImage: output)
      }
    }
    return nil
  }
  
  open class func takeSelectPicture(VCName: UIViewController, imagePicker:UIImagePickerController, title: String, message: String, takeButtonTitle: String, selectImageButtonTittle:String,cancelButtonTittle:String) {
    let pickerAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
    
    pickerAlert.addAction(UIAlertAction(title: takeButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
        imagePicker.sourceType = UIImagePickerController.SourceType.camera;
        imagePicker.allowsEditing = false
        VCName.present(imagePicker, animated: true, completion: nil)
      }
    }))
    
    pickerAlert.addAction(UIAlertAction(title: selectImageButtonTittle, style: .default, handler: { (action: UIAlertAction!) in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        imagePicker.allowsEditing = true
        VCName.present(imagePicker, animated: true, completion: nil)
      }
    }))
    
    pickerAlert.addAction(UIAlertAction(title: cancelButtonTittle, style: .destructive, handler: { (action: UIAlertAction!) in
      pickerAlert.dismiss(animated: true, completion: nil)
    }))
    VCName.present(pickerAlert, animated: true, completion: nil)
  }
  
  open class func takePicture(VCName: UIViewController, imagePicker:UIImagePickerController) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      imagePicker.sourceType = UIImagePickerController.SourceType.camera;
      imagePicker.allowsEditing = false
      VCName.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  open class func selectImage(VCName: UIViewController, imagePicker:UIImagePickerController) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
      imagePicker.allowsEditing = true
      VCName.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  open class func goToSpecificView(viewController: UIViewController, nameStoryboardDestination: String,nameVCDestination: String ){
    let storyboard = UIStoryboard(name: nameStoryboardDestination, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: nameVCDestination)
    viewController.show(vc, sender:viewController)
  }
  
  open class func setYearValidation(pickerDate: UIDatePicker, minAge: Int, maxAge: Int) {
    let currentDate: Date = Date()
    var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    var components: DateComponents = DateComponents()
    components.calendar = calendar
    components.year = minAge * -1
    let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
    components.year = maxAge * -1
    let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
    pickerDate.minimumDate = minDate
    pickerDate.maximumDate = maxDate
  }
  
  open class func showSimpleAlert(VCName: UIViewController, tittle: String, message: String, buttonTittle: String) {
    let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: buttonTittle, style: .default, handler: nil))
    VCName.present(alert, animated: true)
  }
  
  open class func ShowSimpleAlertAction(VCName:UIViewController ,tittle: String, message: String, titleButton: String, onSuccess: @escaping () -> Void) {
    let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: titleButton, style: .default, handler: { (tap) in
      onSuccess()
    }))
    VCName.present(alert, animated: true)
  }
  
  open class func showAlertOption(VCName: UIViewController ,tittle: String, message: String, okButtonTittle: String, cancelButtonTittle: String, onSuccess: @escaping () -> Void, onCancel: @escaping () -> Void) {
    let alert = UIAlertController(title: tittle, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: okButtonTittle, style: .default, handler: { (tap) in
      onSuccess()
    }))
    alert.addAction(UIAlertAction(title: cancelButtonTittle, style: .default, handler: { (tap) in
      onCancel()
    }))
    VCName.present(alert, animated: true)
  }
  
  open class func isToday(formatDate: String, stringDate: String) -> Bool{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formatDate
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = dateFormatter.date(from: stringDate) ?? Date()
    return Calendar.current.isDateInToday(date)
  }
  
  open class func isTomorrow(formatDate: String, stringDate: String) -> Bool{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formatDate
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = dateFormatter.date(from: stringDate) ?? Date()
    return Calendar.current.isDateInTomorrow(date)
  }
  
  open class func isYesterday(formatDate: String, stringDate: String) -> Bool{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formatDate
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let date = dateFormatter.date(from: stringDate) ?? Date()
    return Calendar.current.isDateInYesterday(date)
  }
  
  open class func differenceTwoDates(formatDate: String, startDate:String, endDate: String) -> DateComponents{
    let dateFormatter = DateFormatter()
    let requestedComponent: Set<Calendar.Component> = [.year, .month,.day,.hour,.minute,.second]
    dateFormatter.dateFormat = formatDate
    let startDate = dateFormatter.date(from: startDate) ?? Date()
    let endDate = dateFormatter.date(from: endDate) ?? Date()
    return Calendar.current.dateComponents(requestedComponent, from: startDate, to: endDate)
  }
  
}
