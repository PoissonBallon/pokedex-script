//
//  PokemonInfo.swift
//  Async
//
//  Created by Allan Vialatte on 13/12/2018.
//

import Foundation

struct PokemonInfo {
  let ruban: String?
  let infobox: String?
}

extension PokemonInfo {
  init(with textArea: String) {
    self.ruban = textArea.slice(from: "{{Ruban Pokémon", to: "}}")
    self.infobox = textArea.slice(from: "{{Infobox Pokémon", to: "}}")
  }
}

extension String {
  func slice(from: String, to: String) -> String? {
    return (range(of: from)?.upperBound).flatMap { substringFrom in
      (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
        String(self[substringFrom..<substringTo])
      }
    }
  }
}
