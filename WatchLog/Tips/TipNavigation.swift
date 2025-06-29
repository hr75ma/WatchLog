//
//  TipNavigation.swift
//  WatchLog
//
//  Created by Marcus Hörning on 29.06.25.
//

import Foundation
import TipKit

struct NavigationTipNewLogEntry: Tip {
    var title: Text {
        Text("Neuer Wachbucheintrag")
    }
    var message: Text? {
        Text("Über das + wird ein neuer Wachbucheintrag erstellt.")
    }
    
    var image: Image? {
        
    Image(systemName: "document.badge.plus.fill")
        
        }
    
}

struct NavigationTipRefresh: Tip {
    var title: Text {
        Text("Liste akutalisieren")
    }
    var message: Text? {
        Text("Ziehe mit dem Finger die Liste nach unten um eine Aktualisierung der Einträge durchzuführen.")
    }
    
    var image: Image? {
        
    Image(systemName: "arrow.clockwise.circle")
        
        }
    
}
