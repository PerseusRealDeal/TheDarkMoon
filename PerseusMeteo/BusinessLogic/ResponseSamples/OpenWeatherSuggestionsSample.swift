//
//  OpenWeatherSuggestionsSample.swift
//  TheDarkMoon
//
//  Created in 7535 (04.10.2026.)
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//

// MARK: - OpenWeatherMap Suggestions JSON Request

/*

http://api.openweathermap.org/geo/1.0/direct?q=Новосибирск&limit=5&appid=###

*/

// MARK: - OpenWeatherMap Suggestions JSON Response

let sampleOpenWeatherMapSuggestions = """
[
  {
    "state" : "Novosibirsk Oblast",
    "lat" : 55.028217099999999,
    "country" : "RU",
    "name" : "Novosibirsk",
    "local_names" : {
      "de" : "Nowosibirsk",
      "sl" : "Novosibirsk",
      "es" : "Novosibirsk",
      "kk" : "Новосібір",
      "et" : "Novosibirsk",
      "ca" : "Districte urbà de Novossibirsk",
      "fi" : "Novosibirsk",
      "fr" : "Novossibirsk",
      "be" : "Новасібірск",
      "ku" : "Novosîbîrsk",
      "cs" : "Novosibirsk",
      "uz" : "Novosibirsk",
      "he" : "נובוסיבירסק",
      "en" : "Novosibirsk",
      "kn" : "ನೋವೋಸಿಬಿರ್ಸ್ಕ್",
      "da" : "Novosibirsk",
      "az" : "Novosibirsk",
      "ar" : "نوفوسيبيرسك",
      "lt" : "Novosibirskas",
      "uk" : "Новосибірськ",
      "ko" : "노보시비르스크",
      "ja" : "ノヴォシビルスク管区",
      "oc" : "Novosibirsk",
      "ru" : "Новосибирск",
      "lv" : "Novosibirska",
      "sk" : "Novosibirsk",
      "hi" : "नोवोसिबिर्स्क",
      "pt" : "Novosibirsk",
      "pl" : "Nowosybirsk",
      "hr" : "Novosibirsk",
      "ro" : "Novosibirsk"
    },
    "lon" : 82.923450900000006
  },
  {
    "state" : "Novosibirsk Oblast",
    "lat" : 54.967814449999999,
    "country" : "RU",
    "name" : "Novosibirsk",
    "local_names" : {
      "en" : "Novosibirsk",
      "ca" : "Novossibirsk",
      "ku" : "Novosîbîrsk",
      "ja" : "ノヴォシビルスク",
      "ru" : "Новосибирск",
      "zh" : "新西伯利亚"
    },
    "lon" : 82.951598942783761
  }
]
"""
