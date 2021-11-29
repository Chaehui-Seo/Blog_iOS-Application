//
//  UIFont+CustomFont.swift
//  Blog_Application
//
//  Created by 서채희 on 2021/10/31.
//

import Foundation
import UIKit

extension UIFont {
    static var Head1 : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
    }
    
    static var Head2 : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
    }
    
    static var Head3 : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
    }
    
    static var Head4 : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
    }
    
    static var Body1 : UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    
    static var Body2 : UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: 15) ?? UIFont.systemFont(ofSize: 15)
    }
    
    static var Body3 : UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
    static var Detail_10 : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 10) ?? UIFont.boldSystemFont(ofSize: 10)
    }
}
