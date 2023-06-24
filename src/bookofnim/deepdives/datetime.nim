##
## datetime
## ========
## [bookmark](https://nim-lang.github.io/Nim/monotimes.html)

##[
## TLDR
- supports nanosecond resolution, but getTime() depends on platform & backend
- use monotimes when measuring durations with high precision, else cpuTime
- use time Duration when you need units of time, e.g. days/years/etc
- use time TimeInterval when you need to consider timezones in calculations
- all the expected arithmetic operators are available
  - div integer div for durations
  - < > logical stuff works as expected
- durations can be negative; Use abs(a) < abs(b) to compare the absolute duration.
- generally
  - datetimes are singular e.g. month
  - intervals are plural e.g. months

links
-----
- [date & times](https://nim-lang.github.io/Nim/times.html)
- [mono times](https://nim-lang.github.io/Nim/monotimes.html)
- [timezone names, but any unambiguous string can be used](https://en.wikipedia.org/wiki/Tz_database)

TODOs
-----
- time
  - high, low
  - newTimezone
  - zonedTimeFromAdjTime, zonedTimeFromTime

## time

time format strings
-------------------
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

time design
-----------
- 2 groups
  - datetime
  - durations & timeintervals
    - duration
    - intervals: only useful for calculations with timezones

time Duration (see types)
-------------------------
- more performant than timeinterval
- stored as [nano]seconds and always normalized (1hr == 60min)
- 1 day = 86400 seconds
  - careful when calcuting 1 day:
    - a single timezone can have multiple UTC offsets (daylight saving)
    - thus parsing 2 dates in this context and diffing may === 25 hours
    - this limitation doest exist in TimeInterval
- int.unit works, e.g. 1.years/months/seconds/etc

time TimeInterval (see types)
-----------------------------
- stored as fields of calendar units to support leap years

times types
-----------
- DateTime object[enum & int & bool & range]
  - leap seconds are supported but not surfaced
- DateTimeLocal object[array[range, string]]
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
- TimeIntervalParts  array[TimeUnit, int]
- TimeUnit enum (see TimeInterval)
- Timezone object(proc & string)
  - uses the systems local time or UTC
- WeekDay enum d(Mon-Sun) -> fullname
- YeardayRange 0 .. 365
- ZonedTime object[Time & int & bool]
  - point in time with an associated UTC ffset and DST flag
  - only used for implementing timezones
- DurationZero tuple(seconds: 0, nanosecond: 0)
  - useful for comparing against durations

time exceptions
---------------
- TimeFormatParseError: invalid input string
- TimeParseError: invalid TimeFormat

time procs
----------
- cpuTime() is useful for benchmarking
- utc/local convert to/from eachother; shorthand for (dt|time).inZone(utc|local())
- isDst true if daily saving time is in effect (not for js backend)
- isLeapDay true if datetime is leapday, e.g. feb29 in year 2000, affects time offset calculations
]##

{.push hint[XDeclaredButNotUsed]:off, warning[UnusedImport]:off .}

import std/[sugar, strformat]

echo "############################ time"

import std/times


echo "############################ time datetimes"
# TODO: getTime().getGMTime() used in niminaction example

let
  bday = dateTime(1969, mJan, 01, zone = utc()) ## \
    ## year, month, monthday, hour, minute, second, nanosecond, zone [local|utc]()
    ## weekday, yearday, isDst, monthdayZero, monthZero, timezone, utcOffset
    ## Month: mJan .. mDec
    ## Weekday: dMon .. dSun
    ## initDateTime is deprecated
  sometime = initTime(0, 0) ## \
    ## create time from a unix timestamp, nanosecond
  fdate = initTimeFormat("yyyy-MM-dd") ## \
    ## for parsing & formatting dates
  ftime = initTimeFormat("yyyy-MM-dd'T'HH:mm:sszzz") ## \
    ## for parsing & formatting times


echo fmt"local time {getClockStr()=}"
echo fmt"local date {getDateStr()=}"
echo fmt"local datetime {now()=}"
echo fmt"local stamp {$getTime()=}"
echo fmt"{now().timezone=}"
echo fmt"{now().utc.inZone(local()).timezone=}"
echo fmt"utc datetime {now().utc=}"
echo fmt"utc stamp {getTime().utc=}"
echo fmt"{getTime().utc.timezone=}"
echo fmt"epoch Time {$fromUnixFloat(0)=}"
echo fmt"epoch Time {$fromUnix(0)=}"
echo fmt"epoch Time {$fromUnix(0).utc=}"
echo fmt"epoch {$initTime(0,0)=}"
# echo fmt"epoch {epochTime()=}" # TODO(noah): throws in v2
echo fmt"{getTime().utc + 1.hours=}"
echo fmt"{$bday.utcOffset=}"
echo fmt"{$bday.toTime=}"
echo fmt"{$bday.toTime.toUnix=}" # time since epoch
# TODO(noah): throws in v2
# echo fmt"${bday.toTime.toUnixFloat=}" # same but using subsecond resolution
echo fmt"{$bday.weekday=}" # any dt unit (see above)
echo fmt"""{bday.format "YYYY'/'MMM' at 'htt"=}"""
echo fmt"""string to date {"1969-01-01".parse(fdate)=}"""
echo fmt"""string to formatted date {"1969-01-01".parse(fdate).format(fdate)=}"""
echo fmt"""string to time {$parseTime("1970-01-01T00:00:00+00:00",$ftime, utc())=}"""

echo "############################ time durations"
# DurationZero

let
  dailycoding = initDuration(hours = 16) ## \
    ## nanoseconds, microseconds, milliseconds, seconds, minutes, hours, days, weeks
    ## normalized to: seconds, nanosecond

echo fmt"{now() - bday=}"
echo fmt"{bday.between now()=}"
echo fmt"{getDayOfWeek(13, mJun, 1990)=}"
echo fmt"{getDayOfYear(1, mJan, 2000)=}"
echo fmt"{getDaysInMonth(mFeb, 2000)=}"
echo fmt"leap year {getDaysInYear(2000)=}"
echo fmt"be careful {convert(Days, Weeks, 14)=}"
echo fmt"floors result {convert(Days, Weeks, 13)=}"
echo fmt"be careful {dailycoding.inMinutes=}" ## inAnything
echo fmt"floors result {dailyCoding.inDays=}"
echo fmt"{dailycoding.toParts=}"
echo fmt"{dailycoding.toParts[Hours]=}" # Days, Weeks, etc


echo "############################ time intervals"

let
  relaxing = initTimeInterval(hours = 4, minutes = 60 * 4) ## \
    ## years, months, weeks, days, hours, minutes, seconds, milliseconds, microseconds, nanoseconds
    ## never normalized: hours 24 != days 1
    ## slower arithmetics due to requirement timezone
  hour = 1.hours ## shorthand for initTimeInterval

echo fmt"{$(getTime() + relaxing)}"
echo fmt"{relaxing.toParts=}"
echo fmt"{relaxing.toParts[Hours]=}"
