//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/10/25.
//

import Foundation

struct Sound {
    let name: String
    let fileName: String
}

struct SoundLibrary {
    static let sounds: [Sound] = [
        Sound(name: "Arpeggio", fileName: "Arpeggio"),
        Sound(name: "Breaking", fileName: "Breaking"),
        Sound(name: "Canopy", fileName: "Canopy"),
        Sound(name: "Chalet", fileName: "Chalet"),
        Sound(name: "Chirp", fileName: "Chirp"),
        Sound(name: "Daybreak", fileName: "Daybreak"),
        Sound(name: "Departure", fileName: "Departure"),
        Sound(name: "Dollop", fileName: "Dollop"),
        Sound(name: "Journey", fileName: "Journey"),
        Sound(name: "Kettle", fileName: "Kettle"),
        Sound(name: "Mercury", fileName: "Mercury"),
        Sound(name: "Milky Way", fileName: "Milky Way"),
        Sound(name: "Quad", fileName: "Quad"),
        Sound(name: "Radial", fileName: "Radial"),
        Sound(name: "Reflection", fileName: "Reflection"),
        Sound(name: "Scavenger", fileName: "Scavenger"),
        Sound(name: "Seedling", fileName: "Seedling"),
        Sound(name: "Shelter", fileName: "Shelter"),
        Sound(name: "Sprinkles", fileName: "Sprinkles"),
        Sound(name: "Steps", fileName: "Steps"),
        Sound(name: "Storytime", fileName: "Storytime"),
        Sound(name: "Tease", fileName: "Tease"),
        Sound(name: "Tilt", fileName: "Tilt"),
        Sound(name: "Unfold", fileName: "Unfold"),
        Sound(name: "Valley", fileName: "Valley")
    ]
}
