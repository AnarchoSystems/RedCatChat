//
//  RandomMessages.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import Foundation


enum Messages {
    
    static func random() -> String {
        if Bool.random() {
            return userMessage()
        }
        else {
            return staticQuotes.randomElement()!
        }
    }
    
    private static func userMessage() -> String {
        [
            "\(personalStatementAbout()) \(Names.random()).",
            "\(Names.random())\(statementBeginningWithPerson())",
            "\(gossip()) \(Names.random()) and \(Names.random()) \(randomBinaryRel())",
            repetetiveStatement().joined(separator: Names.random()),
        ].randomElement()!
    }
    
    private static func repetetiveStatement() -> [String] {
        [
            ["", " has recently said incredibly racist shit. Don't trust ", "!"],
        ["You should really ask ", " about that. ", " is kind of an expert."],
        ["", " is a fine individual. ", " has repeatedly made clear they're on the side of the working class."],
            ["I don't know what to say about ", ". ",
             " is usually right, but sometimes, ",
             " has so monumentally stupid takes that I don't know what to think about that."],
            ["", "? Nobody likes ", "! Who even is ", "? What an odd name is ", "?"],
            ["I like ", ", but \(Names.random()), \(Names.random()) and \(Names.random()) don't."]
        ].randomElement()!
    }
    
    private static func statementBeginningWithPerson() -> String {
        [
            "? That one is cool!",
            " is sooo stupid!",
            " is a class reductionist!",
            " has quite a nuanced take on politics.",
            " is a liberal.",
            " is an accelerationist.",
            " talks fast so people think they're intelligent."
        ].randomElement()!
    }
    
    private static func personalStatementAbout() -> String {
        [
            "I really don't like",
            "I'm friends with",
            "I like",
            "I admire",
            "I hate"
        ].randomElement()!
    }
    
    private static func gossip() -> String {
        [
            "I think",
            "I know for a fact that",
            "I heard \(Names.random()) say that",
            "\(Names.random()) said that \(Names.random()) said that \(Names.random()) heard \(Names.random()) say that rumor has it that", // swiftlint:disable:this line_length
            "You should know that"
        ].randomElement()!
    }
    
    private static func randomBinaryRel() -> String {
        [
            "are worst enemies.",
            "are in love with each other.",
            "are friends.",
            "don't know each other yet.",
            "know each other.",
            "have a history.",
            "are neutral towards each other."
        ].randomElement()!
    }
    
    private static let staticQuotes : [String] = [
        "I know that I know nothing.",
        "Recognize your self!",
        "Lorem Ipsum is a boring placeholder.",
        "Capitalism sucks!",
        "Open source rules!",
        "Thine, mine - these are bourgeois categories!",
        "Hey, is this a commie chat?!?!",
        "My best friend is a kangaroo :D",
        "Leftists don't do compromises? Bernie WAS the compromise!",
        "Seize the memes of production!",
        "But if you hate capitalism, why do you use smart phones then?",
        "We NEED to have billionaires - why else would anyone be motivated to hire people to innovate?",
        "You can achieve EVERYTHING if you just try hard enough (except universal health care in the US).",
        "I'm so color blind, I don't even see discrimination and violence against marginalized communities!",
        "Capitalism will devour itself eventually. We don't need to do anything. Relax, yall.",
        "It's the ECONOMY, stupid!",
        "All socialism hitherto has been a showcase of class reductionism.",
        "If rising sea levels are a problem, can't people just sell their home to Aquaman and go away?",
        "Crime! Why does nobody on the left want to ban crime?!",
        "Facts don't care about your feelings!",
        "The left want to destroy our nation by burning flags. I'm for free speech, but flags have rights!",
        "The land of the free should be free from drugs - including Alcohol, because that worked so well!",
        "It's called \"the human RACE\", so somebody's got to win, right?",
        "As a libertarian, I want to abolish the police, too! Instead, we should trade certificates that allow a certain number of crimes and slowly reduce the number of certificates, then the market will solve the problem!", // swiftlint:disable:this line_length
    ]
    
}
