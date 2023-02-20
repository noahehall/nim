##
## datetime
## ========
## [bookmark](https://nim-lang.org/docs/times.html#10)

##[
## TLDR
- supports nanosecond resolution, but getTime() depends on platform & backend
- use monotimes when measuring durations with high precision
- use time Duration > time TimeInterval unless support for months/years required

links
- [date & times](https://nim-lang.org/docs/times.html)
- [mono times](https://nim-lang.org/docs/monotimes.html)

## time format strings
- design
  - x atleast 1 digit
  - xx always 2 digits
  - xxx abbreviation
  - xxxx full
- d 1/04/2012 -> 1
- dd 1/04/2012 -> 01
- ddd Saturday -> Sat
- dddd Saturday -> Saturday
- h am/pm hr
- H military hr
- m minutes
- M month
- s seconds
- t A(m) or P(m)
- yy year
- yyyy year 0 padded
- YYYY uint no padding
- uuuu int 0 padded
- UUUU int no padding
- z utc offset e.g. +7/-7
- zz utc offset + leading 0 e.g. +07
  - zzz +07:12
  - zzzz +07:12:21
  - ZZZ +0712
  - ZZZZ 071221
- g AD/BC
- fff milliseconds
- ffffff microseconds
- fffffffff nanoseconds

## time Duration (see types)
- more performant than timeinterval
- stored as [nano]seconds and always normalized (1hr == 60min)
- 1 day = 86400 seconds
  - careful when calcuting 1 day:
    - a single timezone can have multiple UTC offsets (daylight saving)
    - thus parsing 2 dates in this context and diffing may === 25 hours
    - this limitation doest exist in TimeInterval

## time TimeInterval ( see types)
- stored as fields of calendar units to support leap years
- more robust than timeinterval as it supports timezone

## times types
- DateTime object[enum & int & bool & range]
  - enums: WeekDay, Timezone
  - ranges: [Nanosecond, Second,Minute, Hour, Yearday]Range
  - int: [monthday, month]Zero, year, utcOffset
  - bool: isDist
  - FYI
    - leap seconds are supported but not surfaced
    - you likely want this for human readable stuff
- DateTimeLocal object[array[range, string]]
  - range: month/day enum
- Duration object[seconds:int & nanosecond:range]
  - FYI
    - you likely want this for calculations
- DurationParts array[FixedTimeUnit, int]
- FixedTimeUnit rnage[Nanoseconds .. Weeks]
  - FYI
    - units of time that can be represented by a Duration
- HourRange 0 .. 23
- MinuteRange 0 .. 59
- Month enum(int, string) january = 1
- MonthdayRange 1 .. 31
- NanosecondRange 0 .. bunch of 9s
- SecondRange 0 .. 60
  - FYI
    - 60 included for leap second, but isnt surfaced in a DateTime
- Time object[seconds:int & nanosecond: range]
  - FYI
    - a point in time, like a birthday you forgot
- TimeFormat object[patterns, formatStr]
- TimeInterval object[int]
  - (nano,micro,milli)seconds
  - seconds, minutes, hours, days weeks, months ,years
  - FYI
    - non-fixed duration of time
    - add/sub from a DateTime/Time
- TimeIntervalParts  array[TimeUnit, int]
- TimeUnit enum (see TimeInterval)
- Timezone object(proc & string)
  - name
  - zonedTimeFromTimeImpl
  - zonedTimeFromAdjTimeImpl
  - FYI
    - uses the systems local time or UTC
- WeekDay enum d(Mon-Sun) -> fullname
- YeardayRange 0 .. 365
- ZonedTime object[Time & int & bool]
  - FYI
    - point in time with an associated UTC ffset and DST flag
    - only used for implementing timezones

## time exceptions
- TimeFormatParseError: invalid input string
- TimeParseError: invalid TimeFormat
]##

import std/[sugar, strformat]
