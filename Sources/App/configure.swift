import Vapor
import telegram_vapor_bot

// configures your application
public func configure(_ app: Application) throws {
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 80
    
    let connection: TGConnectionPrtcl = TGLongPollingConnection()
    TGBot.configure(connection: connection, botId: readToken(from: "token"), vaporClient: app.client)
    try TGBot.shared.start()
    TGBot.log.logLevel = .error
    
    DefaultBotHandlers.shared.addHandlers(app: app, bot: TGBot.shared)

    // register routes
    try routes(app)
}
