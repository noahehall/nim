echo "############################ REEEAAALLLY should list"
# GC_Strategy (enum) the application should use
  # gcThroughput,             ## optimize for throughput
  # gcResponsiveness,         ## optimize for responsiveness (default)
  # gcOptimizeTime,           ## optimize for speed
  # gcOptimizeSpace            ## optimize for memory footprint
# owned[T] mark a ref/ptr/closure as owned
# pointer use addr operator to get a pointer to a variable
# using statement provides syntactic convenience where the same param names & types are used over and over

echo "############################ skipped list"
# @see https://nim-lang.org/docs/system.html#7 are somewhere on this page
# AllocStats
# AtomType
# Endianness
# FileSeekPos
# ForeignCell
# lent[T]
# sink[T]
# StackTraceEntry a single entry in a stack trace
# TFrame something to do with callstacks
# TypeOfMode something to do with proc/iter invocations
# asm assembler statements enabled direct embedding of assemlber code in nim code

echo "############################ macros"
#[
  I basically skipped everything related to macros
  I should have captured everything in this file (which is what im doing now)
]#

#[
  # stuff
    ForLoopStmt
    NimNode
    instantiationInfo
]#

echo "############################ effect system"
#[
  theres an effect system but i've yet to see concrete documentation sans the few mentions here n there
  likely its in the manual which i havent reached yet
  @see https://nim-lang.org/docs/manual.html#effect-system
  swing back to this once you get more familiar with the language
]#

#[
  IOEffect
  ExecIOEffect executing IO operation
  ReadIOEffect describes a read IO operation
  RootEffect custom effects should inherit from this
  TimeEffect
  WriteIOEffect
]#
