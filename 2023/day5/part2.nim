import std/sequtils
import std/strutils

import part1

proc read_seeds*(f: string): seq[(int, int)] =
  let line = readFile(f)
  var start: int
  for i, val in line.splitWhitespace().map(parseInt):
    if i mod 2 == 0:
      start = val
    else:
      result.add((start, val))

proc main() =
  let input = "input"
  let seeds = read_seeds(input & '/' & "seeds.txt")
  let seed_to_soil = read_map(input & '/' & "seed_to_soil.txt")
  let soil_to_fertilizer = read_map(input & '/' & "soil_to_fertilizer.txt")
  let fertilizer_to_water = read_map(input & '/' & "fertilizer_to_water.txt")
  let water_to_light = read_map(input & '/' & "water_to_light.txt")
  let light_to_temperature = read_map(input & '/' & "light_to_temperature.txt")
  let temperature_to_humidity = read_map(input & '/' & "temperature_to_humidity.txt")
  let humidity_to_location = read_map(input & '/' & "humidity_to_location.txt")
  
  var minLocation = high(int)
  for (start, l) in seeds:
    for seed in start..(start+l-1):
      let soil = apply_map(seed, seed_to_soil)
      let fetilizer = apply_map(soil, soil_to_fertilizer)
      let water = apply_map(fetilizer, fertilizer_to_water)
      let light = apply_map(water, water_to_light)
      let temperature = apply_map(light, light_to_temperature)
      let humidity = apply_map(temperature, temperature_to_humidity)
      let location = apply_map(humidity, humidity_to_location)
      if location < minLocation:
        minLocation = location
  echo minLocation

when isMainModule:
  main()