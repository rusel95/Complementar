//
//  DefaultBotHandlers.swift
//  
//
//  Created by Ruslan Popesku on 15.06.2022.
//

import Vapor
import telegram_vapor_bot

final class DefaultBotHandlers {
    
    enum Command: String, CaseIterable {
        case startLove = "/start_love"
        case pauseLove = "/pause_love"
    }
    
    // MARK: - PROPERTIES
    
    static let shared = DefaultBotHandlers()
    
    private var isMakingComplements: Bool = false
    
    private let complements: [String] = [
        "Myshka, you are the best!",
        "Tsipa, smile!",
        "Kot sends you a good mood!",
        "Just smile",
        "Send some your photo!",
        "Don't be sad",
        "Don't forget to trade, if possible!",
        "Moya Kachechka!",
        "Kotuha-murkotuha-murkichnya",
        "Malaya, I'm going to cook you",
        "You light up a room",
        "You have such a kind soul",
        "You make me want to be a better person",
        "You have the kindest eyes",
        "You have beautiful eyes",
        "You are the kind of friend I’ve always wanted",
        "When I’m around you, I’m the best possible version of myself",
        "You inspire me",
        "I love your laugh and smile",
        "You have the most vibrant smile I've ever seen",
        "You impress me every day",
        "You have good energy",
        "You are interesting",
        "You are super smart",
        "You are really successful",
        "You are great at your hobby",
        "You’re trendy",
        "Your outlook on life is amazing",
        "You’re so positive",
        "You make me feel warm and fuzzy inside",
        "You have great confidence",
        "I love your hair",
        "You have great taste in music",
        "I love how bubbly you are",
        "I like being around you",
        "I can't believe how much you've improved my own music collection",
        "I admire the way you catch onto new things so quickly",
        "You have great skin",
        "You’re so caring for people",
        "You have such a big heart",
        "You’re great at sports",
        "You’re so creative",
        "You’re great at your job",
        "You’re a great mom/dad",
        "You’re always so helpful",
        "You’re a hard worker",
        "You make me less serious",
        "You make me want to grow as a person",
        "You’re outgoing",
        "You’re so easy going",
        "You’re my favorite person",
        "You’re so likable",
        "Your smile is contagious",
        "You’re so in control of your own life",
        "I look up to you",
        "You’re beautiful"
    ]
    
    // MARK: - METHODS
    
    func addHandlers(app: Vapor.Application, bot: TGBotPrtcl) {
        defaultHandler(app: app, bot: bot)
        commandStartHandler(app: app, bot: bot)
        commandPauseHandler(app: app, bot: bot)
    }
    
}

// MARK: - HELPERS

private extension DefaultBotHandlers {

    /// add handler for all messages except commands
    func defaultHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGMessageHandler(filters: (.all && !.command.names(Command.allCases.map { $0.rawValue }) )) { update, bot in
            let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: self.complements.randomElement() ?? "")
            try bot.sendMessage(params: params)
        }
        bot.connection.dispatcher.add(handler)
    }
    
    /// add handler for command "/start_love"
    func commandStartHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: [Command.startLove.rawValue]) { [weak self] update, bot in
            guard let self = self else { return }
            
            try update.message?.reply(text: "Starting showing the love! Wait for it", bot: bot)
            
            self.isMakingComplements = true
            while self.isMakingComplements {
                let randomTimeToSleep: UInt32 = UInt32.random(in: 3600...10000)
                sleep(randomTimeToSleep)
                try update.message?.reply(text: self.complements.randomElement() ?? "", bot: bot)
            }
        }
        bot.connection.dispatcher.add(handler)
    }

    /// add handler for command "/pause_love"
    func commandPauseHandler(app: Vapor.Application, bot: TGBotPrtcl) {
        let handler = TGCommandHandler(commands: [Command.pauseLove.rawValue]) { [weak self] update, bot in
            self?.isMakingComplements = false
        }
        bot.connection.dispatcher.add(handler)
    }
    
}
