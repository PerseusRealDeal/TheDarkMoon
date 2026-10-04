//
//  OpenMeteoSuggestionsSample.swift
//  TheDarkMoon
//
//  Created in 7535 (04.10.2026.)
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year. For instance, "Sep 01, 2026" is the beginning of 7535.
//

// MARK: - Open-Meteo Suggestions JSON Request

/*

https://geocoding-api.open-meteo.com/v1/search?name=Новосибирск&count=5&language=ru&format=json

*/

// MARK: - Open-Meteo Suggestions JSON Response

let sampleOpenMeteoSuggestions = """
{
  "results" : [
    {
      "id" : 1496747,
      "admin1_id" : 1496745,
      "country" : "Россия",
      "admin2" : "Новосибирский Район",
      "population" : 1612833,
      "country_id" : 2017370,
      "admin1" : "Новосибирская Область",
      "longitude" : 82.931749999999994,
      "elevation" : 113,
      "latitude" : 55.022590000000001,
      "admin2_id" : 1496742,
      "timezone" : "Asia/Novosibirsk",
      "feature_code" : "PPLA",
      "name" : "Новосибирск",
      "country_code" : "RU"
    },
    {
      "id" : 2122736,
      "admin1_id" : 2121529,
      "country" : "Россия",
      "country_id" : 2017370,
      "admin1" : "Сахалин",
      "longitude" : 141.96523999999999,
      "elevation" : 6,
      "latitude" : 47.477449999999997,
      "timezone" : "Asia/Sakhalin",
      "feature_code" : "PPL",
      "name" : "Новосибирское",
      "country_code" : "RU"
    },
    {
      "id" : 6610951,
      "admin1_id" : 1502020,
      "country" : "Россия",
      "country_id" : 2017370,
      "admin1" : "Красноярский Край",
      "longitude" : 91.694599999999994,
      "elevation" : 300,
      "latitude" : 56.073480000000004,
      "timezone" : "Asia/Krasnoyarsk",
      "feature_code" : "PPL",
      "name" : "Новосибирский",
      "country_code" : "RU"
    },
    {
      "id" : 2122737,
      "admin1_id" : 2013162,
      "country" : "Россия",
      "country_id" : 2017370,
      "admin1" : "Саха (Якутия)",
      "longitude" : 142,
      "elevation" : 9999,
      "latitude" : 75,
      "timezone" : "Asia/Sakhalin",
      "feature_code" : "ISLS",
      "name" : "Новосибирские Острова",
      "country_code" : "RU"
    }
  ],
  "generationtime_ms" : 2.6015043000000002
}
"""
