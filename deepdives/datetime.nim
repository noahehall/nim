##
## datetime
## ========
## [bookmark](https://nim-lang.org/docs/times.html#getDayOfWeek%2CMonthdayRange%2CMonth%2Cint)

##[
## TLDR
- supports nanosecond resolution, but getTime() depends on platform & backend
- use monotimes when measuring durations with high precision
- use time Duration > time TimeInterval unless support for months/years required
- looks like all time procs are runtime only (no consts)
- all the expected arithmetic operators are available
  - div integer div for durations
  - < > logical stuff works as expected
- durations can be negative; Use abs(a) < abs(b) to compare the absolute duration.
- cpuTime() is useful for benchmarking

links
- [date & times](https://nim-lang.org/docs/times.html)
- [mono times](https://nim-lang.org/docs/monotimes.html)

## time format strings
- design
  - x atleast 1 digit
  - xx always 2 digits
  - xxx abbreviation
  - xxxx full
  - 'blah' embeds a literal, e.g. yyyy-MM-dd'T'HH:mm:sszzz
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
- int.unit works, e.g. 1.years/months/seconds/etc

## time TimeInterval (see types)
- stored as fields of calendar units to support leap years
- more robust than timeinterval as it supports timezone

## times types
- DateTime object[enum & int & bool & range]
  - leap seconds are supported but not surfaced
  - you likely want this for human readable stuff
  - enums: WeekDay, Timezone
  - ranges: [Nanosecond, Second,Minute, Hour, Yearday]Range
  - int: [monthday, month]Zero, year, utcOffset
  - bool: isDist
- DateTimeLocal object[array[range, string]]
  - range: month/day enum
- Duration object[seconds:int & nanosecond:range]
  - you likely want this for calculations
- DurationParts array[FixedTimeUnit, int]
- FixedTimeUnit rnage[Nanoseconds .. Weeks]
  - units of time that can be represented by a Duration
- HourRange 0 .. 23
- MinuteRange 0 .. 59
- Month enum(int, string) january = 1
- MonthdayRange 1 .. 31
- NanosecondRange 0 .. bunch of 9s
- SecondRange 0 .. 60
  - 60 included for leap second, but isnt surfaced in a DateTime
- Time object[seconds:int & nanosecond: range]
  - a point in time, like a birthday you forgot
- TimeFormat object[patterns, formatStr]
- TimeInterval object[int]
  - non-fixed duration of time
  - add/sub from a DateTime/Time
  - (nano,micro,milli)seconds
  - seconds, minutes, hours, days weeks, months ,years
- TimeIntervalParts  array[TimeUnit, int]
- TimeUnit enum (see TimeInterval)
- Timezone object(proc & string)
  - uses the systems local time or UTC
  - name
  - zonedTimeFromTimeImpl
  - zonedTimeFromAdjTimeImpl
- WeekDay enum d(Mon-Sun) -> fullname
- YeardayRange 0 .. 365
- ZonedTime object[Time & int & bool]
  - point in time with an associated UTC ffset and DST flag
  - only used for implementing timezones
- DurationZero tuple(seconds: 0, nanosecond: 0)
  - useful for comparing against durations

## time exceptions
- TimeFormatParseError: invalid input string
- TimeParseError: invalid TimeFormat
]##

import std/[sugar, strformat]

echo "############################ time"

import std/times

let
  hour = 1.hours
  halfhour = initDuration(minutes = 30)
  timeformat = initTimeFormat("yyyy-MM-dd")
  clockoutin = initTimeInterval(hours = 8)
  bday = dateTime(1969, mJan, 01, zone = utc()) ## \
    ## year, month, day, hour, minutes, seconds, nano, timezone (local/utc())



echo "############################ time pure"
# DurationZero

echo fmt"local time {getClockStr()=}"
echo fmt"local date {getDateStr()=}"
echo fmt"local datetime {now()=}"
echo fmt"local stamp {$getTime()=}"
echo fmt"{now().timezone=}"
echo fmt"utc datetime {now().utc=}"
echo fmt"utc stamp {getTime().utc=}"
echo fmt"{getTime().utc.timezone=}"
echo fmt"initDuration shorthand {1.hours=}"
echo fmt"epoch Time {$fromUnixFloat(0)=}"
echo fmt"epoch Time {$fromUnix(0)=}"
echo fmt"epoch Time {$fromUnix(0).utc=}"
echo fmt"epoch {$initTime(0,0)=}"
echo fmt"epoch {epochTime()=}"
echo fmt"{getTime().utc + 1.hours=}"
echo fmt"{$bday.toTime()=}"
echo fmt"{$bday.weekday}"
echo fmt"{$bday.yearday}"
echo fmt"{now() - bday=}"
echo fmt"{bday.between now()=}"
echo fmt"be careful {convert(Days, Weeks, 14)=}"
echo fmt"it floors result {convert(Days, Weeks, 13)=}"


echo fmt"""{bday.format "YYYY'/'MMM' at 'htt"=}"""
