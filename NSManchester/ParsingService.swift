//
//  File.swift
//  NSManchester
//
//  Created by Ross Butler on 15/01/2016.
//  Copyright © 2016 Ross Butler. All rights reserved.
//

import Foundation

class Speaker {
    let forename: String
    let surname: String
    
    init(forename: String, surname: String) {
        self.forename = forename
        self.surname = surname
    }
}

class Talk {
    let title: String
    let speaker : Speaker
    init(title: String, speaker: Speaker) {
        self.title = title
        self.speaker = speaker
    }
}

class Event {
    let date: NSDate
    let talks: Array<Talk>
    init(date: NSDate, talks: Array<Talk>) {
        self.date = date
        self.talks = talks
    }
}

class ParsingService : NSObject {
    
    // TODO: Re-implement without using NSJSONSerializaton - too many if lets
    func parse(data: NSData) -> Array<Event>? {
        
        var result = Array<Event>()
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
            
            if let speakers = json?.objectForKey("speakers") as? NSDictionary, events = json?.objectForKey("events") as? NSArray
            {
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_GB")
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                
                // Iterate over events array
                for event in events {
                    
                    // Treat each event as an NSDictionary
                    if let eventDictionary = event as? NSDictionary {
                        
                        var talks = Array<Talk>()
                        
                        if let talkDate = eventDictionary.objectForKey("date") as? String {
                            
                            if let date = dateFormatter.dateFromString(talkDate),
                                tempTalks = eventDictionary.objectForKey("talks") as? NSArray {
                                    
                                    for talk in tempTalks {
                                        if let talkDictionary = talk as? NSDictionary,
                                            speakerStr = talkDictionary.objectForKey("speaker"),
                                            speakerDict = speakers.objectForKey(speakerStr) as? NSDictionary,
                                            speakerForename = speakerDict.objectForKey("forename") as? String,
                                            speakerSurname = speakerDict.objectForKey("surname") as? String,
                                            title = talkDictionary.objectForKey("title") as? String
                                        {
                                            let speaker = Speaker(forename: speakerForename, surname: speakerSurname)
                                            let talk = Talk(title: title, speaker: speaker)
                                            talks.append(talk)
                                        }
                                    }
                                    let evt = Event(date: date, talks: talks)
                                    result.append(evt)
                            }
                        }
                    }
                }
            }
        }catch let error as NSError {
            NSLog("%@", error)
        }
        
        return (result.count > 0) ? result : nil;
    }
}