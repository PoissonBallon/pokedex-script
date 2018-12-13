import Console
import HTTP
import SwiftSoup

let terminal = Terminal()
let worker = MultiThreadedEventLoopGroup(numberOfThreads: 2)
let pokedexRoot = "https://www.pokepedia.fr"
var nextPokemon: String?

func requestURL(_ string: String) throws -> HTTPResponse {
  guard let url = URL(string: string) else { throw HTTPError(identifier: "parseURL", reason: "Could not parse URL: \(string)") }
  let scheme: HTTPScheme = url.scheme == "https" ? .https : .http
  
  let res = try HTTPClient.connect(scheme: scheme, hostname: url.host ?? "", on: worker).flatMap(to: HTTPResponse.self) { client in
    var comps =  URLComponents()
    comps.path = url.path.isEmpty ? "/" : url.path
    comps.query = url.query
    let req = HTTPRequest(method: .GET, url: comps.url ?? .root)
    return client.send(req)
    }.wait()
  return res
}


func findEditUrl(response: HTTPResponse) throws -> String? {
  guard let data = response.body.data else { return nil }
  guard let htmlPage = String(data: data, encoding: .utf8) else { return nil }
  
  let soupDocument : Document = try SwiftSoup.parse(htmlPage)
  let links = try soupDocument.select("link").array()
  let editLink = try links.first { (try $0.attr("rel")) == "edit" }
  let editUrl = try editLink?.attr("href")
  return editUrl
}

func findInfo(response: HTTPResponse) throws -> PokemonInfo? {
  guard let data = response.body.data else { return nil }
  guard let htmlPage = String(data: data, encoding: .utf8) else { return nil }
  let soupDocument : Document = try SwiftSoup.parse(htmlPage)
  guard let textArea = try soupDocument.select("textarea").first()?.val() else { return nil }
  let info = PokemonInfo(with: textArea)
  return info
}

terminal.info("Welcome to Pokedex Script", newLine: true)
nextPokemon = "Bulbizarre"

while nextPokemon != nil {
  guard let pokemon = nextPokemon else { break }
  let htmlPage = try requestURL(pokedexRoot + "/" + pokemon)
  nextPokemon = nil
  guard let editUrl = try findEditUrl(response: htmlPage) else { break }
  let editPage = try requestURL(pokedexRoot + editUrl)
  let pokemonInfo = try findInfo(response: editPage)
}

