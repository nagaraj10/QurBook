
import UIKit
import Speech

class Language{
    
    public static let instance = Language()
    var langCode = NSLocale.preferredLanguages[0]
    var regionCode = Locale.current.regionCode!
    
    func checkIfTheLocaleIsSupported(locale:String) -> Locale{
        let supportedLocales = SFSpeechRecognizer.supportedLocales()
        let currentLocale = Locale.init(identifier: locale)
        if (supportedLocales.contains(currentLocale)) {
            return currentLocale
        }
        return Locale.init(identifier:self.langCode)
    }
    
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
