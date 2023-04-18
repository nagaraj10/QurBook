
import UIKit

class Language{
    
    public static let instance = Language()
    var langCode = NSLocale.preferredLanguages[0]
    var regionCode = Locale.current.regionCode!
  
    
    func getlangCode()->String{
        return self.langCode
    }
    
    func getregionCode()->String{
        return self.regionCode
    }
    
    func setlanguage() -> String{
    
        return  self.langCode
    }
    
    func selectedlanguage(language: String){
        langCode =  language
    }
    
}
