//
//  TipNavigation.swift
//  WatchLog
//
//  Created by Marcus Hörning on 29.06.25.
//

import Foundation
import TipKit



struct NavigationTipNewLogEntry: Tip {
    static let setNavigationNewLogEvent = Event(id: "setNewLogEvent")
    
    var title: Text {
        Text("Neuer Wachbucheintrag")
    }
    
    var message: Text? {
        Text("Über das + wird ein neuer Wachbucheintrag erstellt.")
    }
    
    var image: Image? {
        
    Image(systemName: "document.badge.plus.fill")
        
    }
    
    var rules: [Rule] {
        
        #Rule(Self.setNavigationNewLogEvent) { event in
            event.donations.count == 0
        }
    }
}

struct NavigationTipRefresh: Tip {
    static let setNavigationRefreshEvent = Event(id: "setNavigatioRefreshEvent")
    
    var title: Text {
        Text("Liste akutalisieren")
    }
    
    var message: Text? {
        Text("Ziehe mit dem Finger die Liste nach unten um eine Aktualisierung der Einträge durchzuführen.")
    }
    
    var image: Image? {
        
    Image(systemName: "arrow.clockwise.circle")
        
        }
    
    var rules: [Rule] {
        
        #Rule(Self.setNavigationRefreshEvent) { event in
            event.donations.count > 2
        }
    }
    
}
